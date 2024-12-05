import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:ale_okaz/widgets/line_divider.dart';

import 'package:ale_okaz/main.dart';
import 'package:ale_okaz/screens/register/register.dart';



class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passowrdController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xfff3eeea),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const TitleSection(
                  name: 'AleOkaz',
                ),
                LabelInput(
                  labelName: 'Nazwa użytkownika',
                  isObscured: false,
                  controller: _usernameController, 

                ),
                LabelInput(
                  labelName: 'Hasło',
                  isObscured: true,
                  controller: _passowrdController, 
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () { },
                        child: const Text('Zapomniałeś hasło?',
                          style: TextStyle(
                            color: Color(0xFF0C4010), 
                            fontWeight: FontWeight.bold, 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xff6fc27f),
                      side: BorderSide.none,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyApp(username: _usernameController.text,)));
                      }
                    },
                    child: const Text('Zaloguj się',
                      style: TextStyle(
                        color: Color(0xfff3eeea), 
                        fontWeight: FontWeight.bold, 
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                     },
                    child: const Text('Stwórz nowe konto',
                    style: TextStyle(
                      color: Color(0xFF0C4010), // Set link color
                      fontWeight: FontWeight.bold, // Underline text like a link
                    ),
                    ),
                  ),
                ),
                const LineDivider(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: 250,
                    height: 50,
                    child: SignInButton(
                            Buttons.google,
                            text: "Sign up with Google",
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Make it rounded
                            ),
                            onPressed: () { },
                          ),
                    ),
                  ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

