extension Validator on String {
  static final regexEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final regexPassword =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  bool isValidEmail() {
    return regexEmail.hasMatch(this);
  }

  bool isValidPassword() {
    return regexPassword.hasMatch(this);
  }
}
