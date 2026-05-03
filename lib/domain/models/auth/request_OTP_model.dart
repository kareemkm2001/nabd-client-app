
class RequestOtpModel {
  final String mobile;

  RequestOtpModel({
    required this.mobile
  });

  Map<String, dynamic> toJson() {
    return {
      "mobile": mobile,
    };
  }

  factory RequestOtpModel.fromJson(Map<String, dynamic> json) {
    return RequestOtpModel(
      mobile: json["mobile"] ?? "",
    );
  }
}