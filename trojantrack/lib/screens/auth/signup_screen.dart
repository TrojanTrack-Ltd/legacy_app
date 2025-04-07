import 'package:flutter/material.dart';
import '../../screens/auth/confrim_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../utils/custom_extension.dart';
import '../../widgets/loading_indicator_overlay.dart';
import '../../widgets/rich_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Key...
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Flag...
  bool _showPwd = true;
  bool _showConPwd = true;

  // Loading Status notifier...
  final LoadingIndicatorNotifier _loadingIndicator = LoadingIndicatorNotifier();

  // form validation mode...
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  // Controller...
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confrimPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  // Body...
  Widget _buildBody() {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: LoadingIndicator(
        loadingStatusNotifier: _loadingIndicator.statusNotifier,
        child: SafeArea(
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
                    'Sign Up',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 30),
                  // Full name...
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'Full Name'),
                    validator: (value) => value.validateName,
                  ),
                  const SizedBox(height: 10),
                  // Email...
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) => value.validateEmail,
                  ),
                  const SizedBox(height: 10),
                  // Password...
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _showPwd,
                    textInputAction: TextInputAction.next,
                    validator: (value) => value.validatePassword(),
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
                  const SizedBox(height: 10),
                  // Confrim Password...
                  TextFormField(
                    controller: _confrimPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _showConPwd,
                    textInputAction: TextInputAction.done,
                    validator: (text) => text.validatePassword(
                        confrimPasswordVal: _passwordController.text),
                    decoration: InputDecoration(
                        hintText: 'Confrim Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _showConPwd = !_showConPwd;
                                });
                              }
                            },
                            icon: Icon(_showConPwd
                                ? Icons.visibility
                                : Icons.visibility_off))),
                  ),
                  const SizedBox(height: 35),
                  // Sign up..
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: ElevatedButton(
                          onPressed: _signUpAction,
                          child: Text(
                            'Sign up',
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
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                            // elevation: MaterialStateProperty.all(5),
                            fixedSize: MaterialStateProperty.all(Size(
                                MediaQuery.of(context).size.width / 1.5, 50)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () async {
                          try {
                            _loadingIndicator.show();
                            await Provider.of<AuthsProvider>(context,
                                    listen: false)
                                .login('', '', isSignWithGoogle: true);
                            Navigator.of(context).pop();
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 17,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                          ),
                        )),
                  ),
                  const SizedBox(height: 30),
                  // Already have an account login button...
                  Align(
                    alignment: Alignment.center,
                    child: CustomRichText(
                      title: "Already have an account? #Login",
                      normalTextStyle: Theme.of(context).textTheme.bodyLarge,
                      fancyTextStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Sign up action...
  Future<void> _signUpAction() async {
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
      await Provider.of<AuthsProvider>(context, listen: false).signUp(
          _nameController.text,
          _emailController.text,
          _passwordController.text);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ConfirmScreen(email: _emailController.text),
        ),
      );
    } catch (error) {
      context.showSnackBar(error);
    } finally {
      if (mounted) _loadingIndicator.hide();
    }
  }
}
