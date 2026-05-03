class ResponseOtpModel {
  final bool? success;
  final String? message;

  ResponseOtpModel({
    this.success,
    this.message,
  });

  factory ResponseOtpModel.fromJson(Map<String, dynamic> json) {
    return ResponseOtpModel(
      success: json['success'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}