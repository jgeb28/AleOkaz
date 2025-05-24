class Validator {
  Validator();

  String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return "Nazwa użytkownika jest wymagana";
    }

    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Adres e-mail jest wymagany";
    }

    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(email)) {
      return "Niepoprawny adres e-mail";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Hasło jest wyamgane";
    }

    RegExp passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$');

    if (!passwordRegex.hasMatch(password)) {
      return "Niepoprawny format hasła";
    }

    return null;
  }

  String? validateRepeatedPassword(String password, String? repeatedPassword) {
    if (repeatedPassword == null || repeatedPassword.isEmpty) {
      return "Powtórz hasło jest wymagane";
    }

    if (repeatedPassword != password) {
      return "Hasła nie są takie same";
    }

    return null;
  }
}
