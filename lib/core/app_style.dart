import 'package:flutter/material.dart';
import 'package:tillkhatam/core/app_color.dart';

final textFieldStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
);

class AppStyle {
  static TextStyle bigtitle(context, {fontWeight, Color? color}) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: 50, fontWeight: fontWeight, color: color);
  }

  static TextStyle title(context, {fontWeight, Color? color}) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: 30, fontWeight: fontWeight, color: color);
  }

  static TextStyle subtitle(context, {fontWeight}) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize: 22, fontWeight: fontWeight);
  }

  static TextStyle text(context, {fontWeight, Color? color}) {
    return Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(fontSize: 15, fontWeight: fontWeight, color: color);
  }

  static TextStyle smalltext(context, {fontWeight}) {
    return Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(fontSize: 12, fontWeight: fontWeight);
  }

  static ButtonStyle button(context, {Color color = AppColor.lightGreen}) {
    return OutlinedButton.styleFrom(
      side: BorderSide(width: 2.0, color: color),
    );
  }

  static InputDecoration textInput(context,
      {hint, TextStyle? hintStyle, Color? color}) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          hintStyle ?? AppStyle.bigtitle(context, color: AppColor.lightGray),
      enabledBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: color ?? Theme.of(context).colorScheme.primary),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: color ?? Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
