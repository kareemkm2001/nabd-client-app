class UpdateProfileRequest {
  final int? id;
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? lastName;
  final String? fullNameEn;
  final String? username;
  final String? proofNum;
  final String? email;
  final int? mobile;
  final int? telephone;
  final int? contryCode;
  final String? birthday;
  final int? gender;
  final int? socialSituation;
  final String? notes;
  final String? address;
  final int? nationalityId;

  UpdateProfileRequest({
    this.id,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.lastName,
    this.fullNameEn,
    this.username,
    this.proofNum,
    this.email,
    this.mobile,
    this.telephone,
    this.contryCode,
    this.birthday,
    this.gender,
    this.socialSituation,
    this.notes,
    this.address,
    this.nationalityId,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      id: json['id'],
      firstName: json['first_name'],
      secondName: json['second_name'],
      thirdName: json['third_name'],
      lastName: json['last_name'],
      fullNameEn: json['full_name_en'],
      username: json['username'],
      proofNum: json['proof_num'],
      email: json['email'],
      mobile: json['mobile'],
      telephone: json['telephone'],
      contryCode: json['contry_code'],
      birthday: json['birthday'],
      gender: json['gender'],
      socialSituation: json['social_situation'],
      notes: json['notes'],
      address: json['address'],
      nationalityId: json['nationality_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'second_name': secondName,
      'third_name': thirdName,
      'last_name': lastName,
      'full_name_en': fullNameEn,
      'username': username,
      'proof_num': proofNum,
      'email': email,
      'mobile': mobile,
      'telephone': telephone,
      'contry_code': contryCode,
      'birthday': birthday,
      'gender': gender,
      'social_situation': socialSituation,
      'notes': notes,
      'address': address,
      'nationality_id': nationalityId,
    };
  }
}