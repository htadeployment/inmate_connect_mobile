class Validators {
  static String? validateCNIC(String? v) {
    if (v == null || v.trim().isEmpty) return 'CNIC is required';
    final s = v.replaceAll('-', '').trim();
      if (!RegExp(r'^\d{13}$').hasMatch(s)) return 'CNIC must be 13 digits';
    return null;
  }

  static String? validatePakMobile(String? v) {
    if (v == null || v.trim().isEmpty) return 'Mobile number is required';
    final s = v.trim();
    // Accept 03XXXXXXXXX or +923XXXXXXXXX or 00923XXXXXXXXX
      if (!RegExp(r'^(?:\+92|0092|0)3\d{9}$').hasMatch(s)) {
      return 'Enter valid Pakistan mobile (e.g. 03XXXXXXXXX or +923XXXXXXXXX)';
    }
    return null;
  }
}
