import 'package:flutter/material.dart';
import 'styles/styles.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar clave',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/forgot.png',
                  height: 230,
                ),
                SizedBox(height: 20),
                Text(
                  'Ingresa el correo con el que te registraste',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Correo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: AppStyles.elevatedButtonStyle,
                    onPressed: () {},
                    child: Text('Enviar correo'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
