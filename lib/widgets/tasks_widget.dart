import 'package:flutter/material.dart';

/// Show a snackbar displaying the given message.
/// The boolean value change the snackbar background color
void notification(context, String message, bool error){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: 
    Center(child: Text(message)),
    duration: const Duration(milliseconds: 1500),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    backgroundColor: error ? Colors.red : Colors.blue,
  ));
}