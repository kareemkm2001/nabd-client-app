class UserModel {
  final int? id;
  final String? email;
  final String? username;
  final String? mobile;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? gender;
  final String? birthday;
  final int? age;
  final int? nationalityId;
  final String? address;
  final String? profilePhoto;
  final String? status;
  final String? userType;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.email,
    this.username,
    this.mobile,
    this.firstName,
    this.lastName,
    this.fullName,
    this.gender,
    this.birthday,
    this.age,
    this.nationalityId,
    this.address,
    this.profilePhoto,
    this.status,
    this.userType,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      mobile: json['mobile'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      gender: json['gender'],
      birthday: json['birthday'],
      age: json['age'],
      nationalityId: json['nationality_id'],
      address: json['address'],
      profilePhoto: json['profile_photo'],
      status: json['status'],
      userType: json['user_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'mobile': mobile,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'gender': gender,
      'birthday': birthday,
      'age': age,
      'nationality_id': nationalityId,
      'address': address,
      'profile_photo': profilePhoto,
      'status': status,
      'user_type': userType,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}