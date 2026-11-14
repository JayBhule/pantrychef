
/// Handles secure loading of the Groq API key.
///
/// Security design: The API key is NEVER hardcoded in source code.
/// It is loaded at runtime from a local file: assets/config/api_key.txt
/// This file is listed in .gitignore and must NEVER be committed to version control.
///
/// For production apps, consider using:
///   - Android Keystore for key storage
///   - A backend proxy server (BFF pattern) to avoid exposing the key to the client entirely
class ApiConfig {
  ApiConfig._();

  static String? _cachedApiKey;

  /// Loads the Groq API key from the local config file.
  /// Returns null if the file doesn't exist or is empty.
  ///
  /// The developer must create: assets/config/api_key.txt
  /// containing only the Groq API key (no quotes, no extra whitespace).
  static Future<String?> loadApiKey(String assetApiKey) async {
    if (_cachedApiKey != null && _cachedApiKey!.isNotEmpty) {
      return _cachedApiKey;
    }
    // The API key is passed in from Flutter assets at startup
    // See: GroqService which reads it from rootBundle
    if (assetApiKey.isNotEmpty) {
      _cachedApiKey = assetApiKey.trim();
    }
    return _cachedApiKey;
  }

  static void setApiKey(String key) {
    _cachedApiKey = key.trim();
  }

  static String? get apiKey => _cachedApiKey;

  static bool get isConfigured =>
      _cachedApiKey != null && _cachedApiKey!.isNotEmpty;
}
