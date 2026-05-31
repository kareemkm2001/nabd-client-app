class ProfileModel {
  final int id;
  final String? daftaraId;
  final String? parentId;
  final String? relation;
  final String? status;
  final String? smsStatus;
  final String? username;
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? lastName;
  final String? fullName;
  final String? fullNameEn;
  final String? userType;
  final int? hasFile;
  final String? proofNum;
  final int? nationalityId;
  final String? address;
  final int? age;
  final String? birthday;
  final String? gender;
  final String? socialSituation;
  final String? contryCode;
  final String? mobile;
  final String? telephone;
  final String? photo;
  final String? email;
  final String? verifiedAt;
  final String? createdAt;
  final String? updatedAt;

  ProfileModel({
    required this.id,
    this.daftaraId,
    this.parentId,
    this.relation,
    this.status,
    this.smsStatus,
    this.username,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.lastName,
    this.fullName,
    this.fullNameEn,
    this.userType,
    this.hasFile,
    this.proofNum,
    this.nationalityId,
    this.address,
    this.age,
    this.birthday,
    this.gender,
    this.socialSituation,
    this.contryCode,
    this.mobile,
    this.telephone,
    this.photo,
    this.email,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      daftaraId: json['daftara_id'],
      parentId: json['parent_id']?.toString(),
      relation: json['relation'],
      status: json['status'],
      smsStatus: json['sms_status'],
      username: json['username'],
      firstName: json['first_name'],
      secondName: json['second_name'],
      thirdName: json['third_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      fullNameEn: json['full_name_en'],
      userType: json['userType'],
      hasFile: json['hasFile'],
      proofNum: json['proof_num'],
      nationalityId: json['nationality_id'],
      address: json['address'],
      age: json['age'],
      birthday: json['birthday'],
      gender: json['gender'],
      socialSituation: json['social_situation'],
      contryCode: json['contry_code'],
      mobile: json['mobile'],
      telephone: json['telephone'],
      photo: json['photo'],
      email: json['email'],
      verifiedAt: json['verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "daftara_id": daftaraId,
      "parent_id": parentId,
      "relation": relation,
      "status": status,
      "sms_status": smsStatus,
      "username": username,
      "first_name": firstName,
      "second_name": secondName,
      "third_name": thirdName,
      "last_name": lastName,
      "full_name": fullName,
      "full_name_en": fullNameEn,
      "userType": userType,
      "hasFile": hasFile,
      "proof_num": proofNum,
      "nationality_id": nationalityId,
      "address": address,
      "age": age,
      "birthday": birthday,
      "gender": gender,
      "social_situation": socialSituation,
      "contry_code": contryCode,
      "mobile": mobile,
      "telephone": telephone,
      "photo": photo,
      "email": email,
      "verified_at": verifiedAt,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}