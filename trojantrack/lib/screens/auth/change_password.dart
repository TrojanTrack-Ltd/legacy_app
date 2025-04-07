import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../utils/custom_extension.dart';
import '../../widgets/loading_indicator_overlay.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;
  const ChangePasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Key...
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Flag...
  bool _showPwd = true;
  bool _showConPwd = true;

  final _controller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confrimPasswordController =
      TextEditingController();

  // Loading Status notifier...
  final LoadingIndicatorNotifier _loadingIndicator = LoadingIndicatorNotifier();

  // form validation mode...
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: LoadingIndicator(
        loadingStatusNotifier: _loadingIndicator.statusNotifier,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Change Password"),
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: _autoValidate,
            child: SingleChildScrollView(
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/preview.jpg',
                        width: 180,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 12,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 4.0),
                                prefixIcon: Icon(Icons.lock),
                                labelText: 'Enter confirmation code',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10),
                            // Password...
                            TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _showPwd,
                              textInputAction: TextInputAction.next,
                              validator: (value) => value?.validatePassword(),
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
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: _changePassAction,
                              child: const Text(
                                'CHANGE PASSWORD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Change password action...
  Future<void> _changePassAction() async {
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
      await Provider.of<AuthsProvider>(context, listen: false).changePassword(
          _controller.text, _confrimPasswordController.text, widget.email);
      Navigator.of(context).pop();
      Navigator.of(context).maybePop();
    } catch (error) {
      context.showSnackBar(error);
    } finally {
      if (mounted) _loadingIndicator.hide();
    }
  }
}
