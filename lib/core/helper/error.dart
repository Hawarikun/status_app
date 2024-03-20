class ErrorHandle {
  ErrorHandle({
    required this.error,
    required this.message,
  });

  final bool error;
  final String message;

  factory ErrorHandle.fromMap(Map<String, dynamic> map) => ErrorHandle(
        error: map["error"]!,
        message: map["message"]!,
      );
}
