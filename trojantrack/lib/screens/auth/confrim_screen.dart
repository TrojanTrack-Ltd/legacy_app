import 'package:flutter/material.dart';
import '../../utils/custom_extension.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../widgets/loading_indicator_overlay.dart';

class ConfirmScreen extends StatefulWidget {
  final String email;

  const ConfirmScreen({super.key, required this.email});

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final _controller = TextEditingController();
  bool _isEnabled = false;

  // Loading Status notifier...
  final LoadingIndicatorNotifier _loadingIndicator = LoadingIndicatorNotifier();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  void _verifyCode(BuildContext context, String email, String code) async {
    try {
      _loadingIndicator.show();
      await Provider.of<AuthsProvider>(context, listen: false)
          .verifyCode(email, code, (p0) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    } catch (e) {
      context.showSnackBar(e);
    } finally {
      _loadingIndicator.hide();
    }
  }

  void _resendCode(BuildContext context, String email) async {
    try {
      _loadingIndicator.show();
      await Provider.of<AuthsProvider>(context, listen: false)
          .resendCode(email);

      context.showSnackBar('Confirmation code resent. Check your email');
    } catch (e) {
      context.showSnackBar(e);
    } finally {
      _loadingIndicator.hide();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      loadingStatusNotifier: _loadingIndicator.statusNotifier,
      child: Scaffold(
        body: SingleChildScrollView(
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
                        TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Enter confirmation code',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _isEnabled
                              ? () {
                                  _verifyCode(
                                      context, widget.email, _controller.text);
                                }
                              : null,
                          child: const Text(
                            'VERIFY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            _resendCode(context, widget.email);
                          },
                          child: const Text(
                            'Resend confrimation code',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
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
    );
  }
}
