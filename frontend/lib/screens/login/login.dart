import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:ale_okaz/widgets/label_input.dart';
import 'package:ale_okaz/widgets/title_section.dart';
import 'package:ale_okaz/widgets/line_divider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  

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
                const LabelInput(
                  labelName: 'Nazwa użytkownika',
                  isObscured: false,

                ),
                const LabelInput(
                  labelName: 'Hasło',
                  isObscured: true,
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
                        //tu się odezwie do logowania puki co nic nie mam
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
                    onPressed: () { },
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
