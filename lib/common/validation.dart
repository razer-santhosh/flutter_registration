class Validation {
  validateEmail(email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  validateUserName(name) {
    if (RegExp('[a-zA-Z]').hasMatch(name)) {
      return true;
    } else {
      return false;
    }
  }
}
