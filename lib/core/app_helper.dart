import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHelper {
  static String pref1 = "theme";
  static String pref2 = "ADSMODE_KEY";
  static String pref3 = "firstTime";

  static formatDate(DateTime date) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    return format.format(date);
  }

  static snackbar(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
