import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readap/login.dart';

import 'home.dart';

class Utils {
  static void showCustomDialog(
    BuildContext context,
    String title,
    String content,
    String buttonText,
    Function()? onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: onPressed != null
                  ? onPressed
                  : () {
                      Navigator.of(context).pop();
                    },
            ),
          ],
        );
      },
    );
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  static void navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  static void handleAuthError(BuildContext context, Object e) {
    String errorMessage = 'Error. Por favor, inténtalo de nuevo.';
    String title = 'Error';

    if (e is FirebaseAuthException) {
      title = 'Error de autenticación';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Usuario no encontrado.';
          break;
        case 'wrong-password':
          errorMessage = 'Contraseña incorrecta.';
          break;
        case 'email-already-in-use':
          errorMessage = 'El correo electrónico ya está en uso.';
          break;
        case 'weak-password':
          errorMessage = 'La contraseña es demasiado débil.';
          break;
        case 'network-request-failed':
          errorMessage = 'Error de red. Por favor, comprueba tu conexión a internet.';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }
    }

    showCustomDialog(
      context,
      title,
      errorMessage,
      'OK',
      () {
        Navigator.of(context).pop();
      },
    );
  }
}
