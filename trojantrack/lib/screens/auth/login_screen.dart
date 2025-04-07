import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import '../../screens/auth/confrim_screen.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_extension.dart';
import '../../provider/auth_provider.dart';
import '../../screens/auth/forgot_password.dart';
import '../../screens/auth/signup_screen.dart';
import '../../widgets/loading_indicator_overlay.dart';
import '../../widgets/rich_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key...
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Flag...
  bool _showPwd = true;

  // Loading Status notifier...
  final LoadingIndicatorNotifier _loadingIndicator = LoadingIndicatorNotifier();

  // form validation mode...
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  // Controller...
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dispose off focus nodes, controller, streams when this widget is removed from tree to avoid memory leaks...
  @override
  void dispose() {
    _loadingIndicator.disposeNotifier();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      loadingStatusNotifier: _loadingIndicator.statusNotifier,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Remove any active Focus node on screen tap...
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          // Body...
          body: _buildBody(),
        ),
      ),
    );
  }

  // Body...
  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/preview.jpg',
                  width: 180,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Login',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              // Email...
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (text) => text.validateEmail,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 10),
              // Password...
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _showPwd,
                textInputAction: TextInputAction.done,
                validator: (text) => text.validatePassword(),
                decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              _showPwd = !_showPwd;
                            });
                          }
                        },
                        icon: Icon(_showPwd
                            ? Icons.visibility
                            : Icons.visibility_off))),
              ),

              // Forgot password...
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text("Forgot Password?",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
              const SizedBox(height: 80),
              // Login..
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton(
                      onPressed: _signInAction,
                      child: Text(
                        'Login',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                  child: Text(
                '-------------------- Or --------------------',
                style: TextStyle(color: Colors.grey),
              )),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                        // elevation: MaterialStateProperty.all(5),
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 1.5, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () async {
                      try {
                        _loadingIndicator.show();
                        await Provider.of<AuthsProvider>(context, listen: false)
                            .login('', '', isSignWithGoogle: true);
                        // Navigator.of(context).pop();
                      } catch (e) {
                        context.showSnackBar(e);
                      } finally {
                        _loadingIndicator.hide();
                      }
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Image.asset(
                        "assets/google.png",
                        height: 25,
                      ),
                    ),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Sign in with Google',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 17,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
              ),
              const SizedBox(height: 30),

              // Don't have account? SignUp button...
              Align(
                alignment: Alignment.center,
                child: CustomRichText(
                  title: "Don't have an account? #Sign #Up",
                  normalTextStyle: Theme.of(context).textTheme.bodyLarge,
                  fancyTextStyle:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const SignUpScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign In action...
  Future<void> _signInAction() async {
    // Remove focus from textfield if any textfield has focus...
    FocusScope.of(context).requestFocus(FocusNode());

    // Validate Form fields data and return if data is not validated...
    if (!_formKey.currentState!.validate()) {
      if (mounted) {
        setState(() => _autoValidate = AutovalidateMode.always);
      }
      return;
    }

    // Save Detail if form data is validated...
    _formKey.currentState!.save();

    try {
      _loadingIndicator.show();
      // Call API...
      await Provider.of<AuthsProvider>(context, listen: false)
          .login(_emailController.text, _passwordController.text);
    } catch (error) {
      context.showSnackBar(error);
      if (error.toString().contains('User not confirmed in the system.')) {
        await Amplify.Auth.resendSignUpCode(username: _emailController.text);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ConfirmScreen(email: _emailController.text),
          ),
        );
      }
    } finally {
      if (mounted) _loadingIndicator.hide();
    }
  }
}
