class SubUserModel {
  final int id;
  final String proofNum;
  final String fullName;
  final String fullNameEn;
  final String mobile;
  final String telephone;
  final String email;
  final String gender;
  final String socialSituation;
  final int age;
  final String nationality;
  final String status;
  final String smsStatus;
  final String createdAt;
  final String createdAtFormatted;

  const SubUserModel({
    required this.id,
    required this.proofNum,
    required this.fullName,
    required this.fullNameEn,
    required this.mobile,
    required this.telephone,
    required this.email,
    required this.gender,
    required this.socialSituation,
    required this.age,
    required this.nationality,
    required this.status,
    required this.smsStatus,
    required this.createdAt,
    required this.createdAtFormatted,
  });

  factory SubUserModel.fromJson(Map<String, dynamic> json) {
    return SubUserModel(
      id: json['id'] ?? 0,
      proofNum: json['proof_num'] ?? '',
      fullName: json['full_name'] ?? '',
      fullNameEn: json['full_name_en'] ?? '',
      mobile: json['mobile'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      socialSituation: json['social_situation'] ?? '',
      age: json['age'] ?? 0,
      nationality: json['nationality'] ?? '',
      status: json['status'] ?? '',
      smsStatus: json['sms_status'] ?? '',
      createdAt: json['created_at'] ?? '',
      createdAtFormatted: json['created_at_formatted'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proof_num': proofNum,
      'full_name': fullName,
      'full_name_en': fullNameEn,
      'mobile': mobile,
      'telephone': telephone,
      'email': email,
      'gender': gender,
      'social_situation': socialSituation,
      'age': age,
      'nationality': nationality,
      'status': status,
      'sms_status': smsStatus,
      'created_at': createdAt,
      'created_at_formatted': createdAtFormatted,
    };
  }

  static List<SubUserModel> fromJsonList(List<dynamic> list) {
    return list
        .map((e) => SubUserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}