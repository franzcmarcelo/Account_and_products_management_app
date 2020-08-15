import 'package:flutter/material.dart';

bool isNumber( String value ) {

  if (value.isEmpty) return false;

  // Se puede parsear a un numero?
  final n = num.tryParse(value);

  return (n == null) ? false : true;

}

void showAlert( BuildContext context, String message ) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },

  );
}