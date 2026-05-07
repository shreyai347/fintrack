class Validators {
  Validators._();

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a valid amount';
    }
    final normalized = value.trim().replaceAll(',', '');
    final n = double.tryParse(normalized);
    if (n == null || n <= 0) return 'Enter a valid amount';
    return null;
  }

  static String? validateNote(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > 200) return 'Note too long';
    return null;
  }
}
