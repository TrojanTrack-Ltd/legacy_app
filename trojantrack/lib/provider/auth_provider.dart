import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';

import '../amplifyconfiguration.dart';
import '../models/ModelProvider.dart';

class AuthsProvider with ChangeNotifier {
  bool _isUserLogin = false;
  bool get isUserLogin => _isUserLogin;

  set isUserLogin(bool value) => _isUserLogin = value;

  AuthUser? authUser;

  List<AuthUserAttribute> userAttibutes = [];

  Future<void> login(String email, String password,
      {bool isSignWithGoogle = false}) async {
    try {
      if (isSignWithGoogle) {
        // // Sign in with google...
        // final GoogleSignIn googleSignIn = GoogleSignIn();
        // // Google sign in...
        // GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        // if (googleSignInAccount == null) {
        //   return;
        // }
        // GoogleSignInAuthentication? googleSignInAuthentication =
        //     await googleSignInAccount.authentication;

        final result = await Amplify.Auth.signInWithWebUI(
          provider: AuthProvider.google,
        );

        isUserLogin = result.isSignedIn;
      } else {
        SignInResult res = await Amplify.Auth.signIn(
          username: email,
          password: password,
        );

        isUserLogin = res.isSignedIn;
      }

      notifyListeners();
    } on AuthException catch (e) {
      if (e.message.contains('already a user which is signed in')) {
        await Amplify.Auth.signOut();
        throw 'Problem logging in. Please try again.';
      } else if (e.message.contains('User not confirmed in the system.')) {
        throw 'User not confirmed in the system.';
      }

      throw '${e.message} - ${e.recoverySuggestion}';
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      // Sign up with email password...
      SignUpResult signUpResult = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: email,
          CognitoUserAttributeKey.name: name,
        }),
      );
      signUpResult.isSignUpComplete;
      notifyListeners();
    } on AuthException catch (e) {
      throw '${e.message} - ${e.recoverySuggestion}';
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendCode(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchUser() async {
    try {
      await configureAmplify();
      authUser = await Amplify.Auth.getCurrentUser();
      isUserLogin = authUser != null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> configureAmplify() async {
    final auth = AmplifyAuthCognito();
    final analytics = AmplifyAnalyticsPinpoint();

    AmplifyStorageS3 storage = AmplifyStorageS3();
    final AmplifyDataStore dataStorePlugin = AmplifyDataStore(
      modelProvider: ModelProvider.instance,
      syncExpressions: [
        DataStoreSyncExpression(
          TrojanTrackModel.classType,
          () {
            return QueryPredicate.all;
          },
        ),
      ],
    );
    final AmplifyAPI apiPlugin = AmplifyAPI();

    try {
      await Amplify.addPlugins(
          [auth, storage, apiPlugin, dataStorePlugin, analytics]);
      print(Amplify.isConfigured);
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException catch (e) {
      print(e.message);
    }
  }

  Future<void> verifyCode(
      String email, String code, Function(SignUpResult) afterVerify) async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );

      if (res.isSignUpComplete) {
        // Login user
        afterVerify(res);
      }
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      // Send password reset email...
      final res = await Amplify.Auth.resetPassword(username: email);

      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {}
      notifyListeners();
    } on AuthException catch (e) {
      throw '${e.message} - ${e.recoverySuggestion}';
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(
      String code, String password, String email) async {
    try {
      // Send password reset email...
      await Amplify.Auth.confirmResetPassword(
          username: email, newPassword: password, confirmationCode: code);

      notifyListeners();
    } on AuthException catch (e) {
      throw '${e.message} - ${e.recoverySuggestion}';
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchUserData() async {
    userAttibutes = await Amplify.Auth.fetchUserAttributes();
  }

  Future<void> logOut() async {
    isUserLogin = false;
    await Amplify.Auth.signOut();
    Amplify.DataStore.clear();

    notifyListeners();
  }
}
