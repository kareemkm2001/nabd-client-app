class AppointmentModel {
  final int id;
  final int userId;
  final String date;
  final String fromTime;
  final String toTime;
  final bool isPackage;
  final int? packageOrder;
  final String status;
  final String statusColor;
  final String type;
  final String typeColor;
  final dynamic price;
  final String? notes;
  final String confirmed;
  final String? startAt;
  final String? joinUrl;
  final List<UserModel> users;
  final ClinicModel clinic;
  final ServiceModel service;
  final PackageModel? package;
  final int? invoiceId;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.fromTime,
    required this.toTime,
    required this.isPackage,
    this.packageOrder,
    required this.status,
    required this.statusColor,
    required this.type,
    required this.typeColor,
    this.price,
    this.notes,
    required this.confirmed,
    this.startAt,
    this.joinUrl,
    required this.users,
    required this.clinic,
    required this.service,
    this.package,
    this.invoiceId,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      userId: json['user_id'],
      date: json['date'] ?? '',
      fromTime: json['from_time'] ?? '',
      toTime: json['to_time'] ?? '',
      isPackage: json['is_package'] ?? false,
      packageOrder: json['package_order'],
      status: json['status'] ?? '',
      statusColor: json['status_color'] ?? '',
      type: json['type'] ?? '',
      typeColor: json['type_color'] ?? '',
      price: json['price'],
      notes: json['notes'],
      confirmed: json['confirmed'] ?? '',
      startAt: json['start_at'],
      joinUrl: json['join_url'],
      users: (json['users'] as List?)
          ?.map((e) => UserModel.fromJson(e))
          .toList() ??
          [],
      clinic: ClinicModel.fromJson(json['clinic'] ?? {}),
      service: ServiceModel.fromJson(json['service'] ?? {}),
      package: json['package'] != null
          ? PackageModel.fromJson(json['package'])
          : null,
      invoiceId: json['invoice_id'],
    );
  }
}

class UserModel {
  final int id;
  final String? email;
  final String username;
  final String mobile;
  final String firstName;
  final String lastName;
  final String fullName;
  final String gender;
  final String birthday;
  final int age;
  final int nationalityId;
  final String? address;
  final String? profilePhoto;
  final String status;
  final String userType;

  UserModel({
    required this.id,
    this.email,
    required this.username,
    required this.mobile,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.gender,
    required this.birthday,
    required this.age,
    required this.nationalityId,
    this.address,
    this.profilePhoto,
    required this.status,
    required this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'] ?? '',
      mobile: json['mobile'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? '',
      age: json['age'] ?? 0,
      nationalityId: json['nationality_id'] ?? 0,
      address: json['address'],
      profilePhoto: json['profile_photo'],
      status: json['status'] ?? '',
      userType: json['user_type'] ?? '',
    );
  }
}

class ClinicModel {
  final int id;
  final String name;
  final DoctorModel doctor;

  ClinicModel({
    required this.id,
    required this.name,
    required this.doctor,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      doctor: DoctorModel.fromJson(json['doctor'] ?? {}),
    );
  }
}

class DoctorModel {
  final int id;
  final String? firstName;
  final String? lastName;
  final String fullName;

  DoctorModel({
    required this.id,
    this.firstName,
    this.lastName,
    required this.fullName,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'] ?? '',
    );
  }
}

class ServiceModel {
  final int id;
  final String name;

  ServiceModel({
    required this.id,
    required this.name,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class PackageModel {
  final int subscriptionId;
  final String name;
  final int sessionNumber;
  final int? invoiceId;

  PackageModel({
    required this.subscriptionId,
    required this.name,
    required this.sessionNumber,
    this.invoiceId,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      subscriptionId: json['subscription_id'] ?? 0,
      name: json['name'] ?? '',
      sessionNumber: json['session_number'] ?? 0,
      invoiceId: json['invoice_id'],
    );
  }
}