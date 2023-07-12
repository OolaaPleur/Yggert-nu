import 'package:flutter/material.dart';

/// Generate dropdown menu items.
DropdownMenuItem<T> generateDropdownMenuItem<T>(T value, String text) {
  return DropdownMenuItem<T>(
    value: value,
    child: Text(text),
  );
}
