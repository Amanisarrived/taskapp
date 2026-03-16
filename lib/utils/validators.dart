class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Enter your email';
    final regex = RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password';
    if (value.length < 6) return 'At least 6 characters required';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? taskTitle(String? value) {
    if (value == null || value.isEmpty) return 'Enter a task title';
    if (value.trim().length < 2) return 'Title is too short';
    return null;
  }
}
