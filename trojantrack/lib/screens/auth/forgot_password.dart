import 'package:flutter/material.dart';
import '../../screens/auth/change_password.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../utils/custom_extension.dart';
import '../../widgets/loading_indicator_overlay.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  // form validation mode...
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  // Loading Status notifier...
  final LoadingIndicatorNotifier _loadingIndicator = LoadingIndicatorNotifier();

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
            title: Text('Forgot Password?',
                style: Theme.of(context).textTheme.titleLarge),
            centerTitle: true,
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  // Body
  Widget _buildBody() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          // Reset password filed
          _buildForm(),
          // Submit button event
          _buildSubmitButton()
        ],
      ),
    );
  }

  // Reset password filed
  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidate,
        child: TextFormField(
          controller: _emailController,
          autocorrect: true,
          validator: (text) => text?.validateEmail,
          decoration: const InputDecoration(
            hintText: 'Email',
          ),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
    );
  }

  // Submit button event
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ElevatedButton(
            onPressed: () async {
              // Remove focus from textfield if any textfield has focus...
              FocusScope.of(context).requestFocus(FocusNode());

              //Validate Form fields data and return if data is not validated...
              if (!_formKey.currentState!.validate()) {
                if (mounted) {
                  setState(() => _autoValidate = AutovalidateMode.always);
                }
                return;
              }

              // Save Detail if form data is validated...
              _formKey.currentState!.save();

              try {
                // Show progress indicator...
                _loadingIndicator.show();
                // reset password
                await Provider.of<AuthsProvider>(context, listen: false)
                    .forgotPassword(_emailController.text);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                        ChangePasswordScreen(email: _emailController.text),
                  ),
                );
              } catch (error) {
                context.showSnackBar(error);
              } finally {
                _loadingIndicator.hide();
              }
            },
            child: Text(
              'Submit',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            )),
      ),
    );
  }
}
