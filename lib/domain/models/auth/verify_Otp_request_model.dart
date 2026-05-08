class VerifyOtpRequestModel {
  final String mobile;
  final String otp;

  const VerifyOtpRequestModel({
    required this.mobile,
    required this.otp,
  });

  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequestModel(
      mobile: json['mobile'],
      otp: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'otp': otp,
    };
  }
}