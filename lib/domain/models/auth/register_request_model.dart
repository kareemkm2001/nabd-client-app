class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String mobile;
  final String contryCode;
  final String termsConditions;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.contryCode,
    required this.termsConditions,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobile: json['mobile'] ?? '',
      contryCode: json['contry_code'] ?? '',
      termsConditions: json['terms_conditions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'mobile': mobile,
      'contry_code': contryCode,
      'terms_conditions': termsConditions,
    };
  }
}