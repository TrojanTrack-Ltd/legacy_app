import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/custom_extension.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    Key? key,
   required this.title,
    this.normalTextStyle,
    this.fancyTextStyle,
    this.onTap,
  }) : super(key: key);
  final String title;
  final Function? onTap;
  final TextStyle? fancyTextStyle;
  final TextStyle? normalTextStyle;

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return RichText(
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      text: TextSpan(
        style: theme.bodyText2,
        children: title.processCaption(
          matcher: "#",
          normalTextStyle: normalTextStyle ?? theme.bodyText1,
          fancyTextStyle: fancyTextStyle ??
              theme.bodyText1!.copyWith(
                color: Theme.of(context).buttonColor,
              ),
          onTap: onTap,
        ),
      ),
    );
  }
}
