import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//String Extension...
extension StringExtension on String? {
  // Remove Special character from string...
  String? get removeSpecialCharacters =>
      this?.trim().replaceAll(RegExp(r'[^A-Za-z0-9]'), '');

  // Process String...
  List<TextSpan>? processCaption({
    String matcher = "#",
    TextStyle? fancyTextStyle,
    TextStyle? normalTextStyle,
    Function? onTap,
  }) {
    return this
        ?.split(' ')
        .map(
          (text) => TextSpan(
            text:
                '${text.toString().contains(matcher) ? text.replaceAll(matcher, "") : text} ',
            style: text.toString().contains(matcher)
                ? fancyTextStyle
                : normalTextStyle,
            recognizer: text.toString().contains(matcher)
                ? onTap == null
                    ? null
                    : (TapGestureRecognizer()
                      ..onTap = onTap as GestureTapCallback?)
                : null,
          ),
        )
        .toList();
  }

  String get toFirstLetter {
    String temp = "";
    List<String> splittedWords =
        (this?.isEmpty ?? true) ? [] : this?.split(" ") ?? [];

    splittedWords.removeWhere((word) => word.isEmpty);

    if (splittedWords.length == 1) {
      temp = splittedWords[0][0].toUpperCase();
    } else if (splittedWords.length == 2) {
      temp =
          splittedWords[0][0].toUpperCase() + splittedWords[1][0].toUpperCase();
    }

    return temp;
  }

  bool get isNetworkImage => (this?.isEmpty ?? true)
      ? false
      : (this!.toLowerCase().startsWith("http://")) ||
          (this!.toLowerCase().startsWith("https://"));

  //Email validation Regular expression...
  static const String emailRegx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  //Validate Name...
  String? get validateName =>
      (this?.trim().isEmpty ?? true) ? 'Please enter your full name' : null;
  static const String passwordREGX =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  //Validate Email...
  String? get validateEmail => ((this?.trim().isEmpty ?? true) ||
          !RegExp(emailRegx).hasMatch(this!.trim()))
      ? 'Please enter your email'
      : null;

  // Validate Password...
  String? validatePassword({String? confrimPasswordVal}) =>
      (this?.trim().isEmpty ?? true)
          ? 'Please enter your password'
          : !RegExp(passwordREGX).hasMatch(this!.trim())
              ? 'Please enter Minimum eight characters, at least one uppercase letter, one lowercase letter and one number.'
              : confrimPasswordVal == null
                  ? null
                  : this != confrimPasswordVal
                      ? "Password must be same as above"
                      : null;

  //Format Date with Required Format...
  String toDateFormat({
    String incommingDateFormate = "yyyy-MM-dd HH:mm:ss",
    String requiredFormat = "yyyy-MM-dd HH:mm:ss",
  }) {
    if (this?.isEmpty ?? true) return this!;
    DateFormat dateFormat = DateFormat(incommingDateFormate);
    try {
      return DateFormat(requiredFormat)
          .format(dateFormat.parse(this!, true).toLocal());
    } catch (error) {
      print(
          "Please check incomming date format, format should be $incommingDateFormate:- $error");
      return this!;
    }
  }
}

//Convert Date...
extension DateConversion on DateTime {
  // To Server Date...
  DateTime get toUTCTimeZone =>
      DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(this));
}

extension ContextExtension on BuildContext {
  // Show snack bar...
  void showSnackBar(Object msg) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this)
        .showSnackBar(SnackBar(content: Text(msg.toString())));
  }
}

bool isNullorEmpty(dynamic object) =>
    object == null || (object?.isEmpty ?? false);
