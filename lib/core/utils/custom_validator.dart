class CustomValidator {

  static String? validateAge(String? value, {String? emptyMessage, String? invalidMessage}) {
    emptyMessage ??= "Please enter your age.";
    invalidMessage ??= "Age must be between 1 and 20.";

    if (value == null || value.isEmpty) {
      return emptyMessage;
    }

    final parsedValue = int.tryParse(value.trim());
    if (parsedValue == null || parsedValue > 20 || parsedValue <= 0) {
      return invalidMessage;
    }

    return null;
  }
}
