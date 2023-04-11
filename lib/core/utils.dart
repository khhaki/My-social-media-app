import 'package:flutter/material.dart';

void showSnakBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

String getNameFromEmail(String email) {
  return email.split('@')[0];
}
