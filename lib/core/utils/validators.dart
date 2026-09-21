class Validators {
  const Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    if (!value.contains('@')) return 'Enter a valid email address.';
    return null;
  }

  static String? required(String? value, {String fieldName = 'This field'}) {
    return value == null || value.trim().isEmpty
        ? '$fieldName is required.'
        : null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 6) return 'Password must contain at least 6 characters.';
    return null;
  }
}
