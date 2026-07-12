class OrdersModel {
  final int id;
  final int userId;
  final String isPackage;
  final int? packageId;
  final int clinicId;
  final int serviceId;
  final String? notes;
  final String status;
  final String statusColor;
  final String createdAt;

  final UserModel user;
  final ClinicModel clinic;
  final ServiceModel service;
  final PackageModel package;
  final AppointmentModel appointment;
  final MeasureClinicModel measureClinic;
  final MeasureServiceModel measureService;

  OrdersModel({
    required this.id,
    required this.userId,
    required this.isPackage,
    required this.packageId,
    required this.clinicId,
    required this.serviceId,
    required this.notes,
    required this.status,
    required this.statusColor,
    required this.createdAt,
    required this.user,
    required this.clinic,
    required this.service,
    required this.package,
    required this.appointment,
    required this.measureClinic,
    required this.measureService,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      isPackage: json['is_package'] ?? '',
      packageId: json['package_id'],
      clinicId: json['clinic_id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      notes: json['notes'],
      status: json['status'] ?? '',
      statusColor: json['status_color'] ?? '',
      createdAt: json['created_at'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      clinic: ClinicModel.fromJson(json['clinic'] ?? {}),
      service: ServiceModel.fromJson(json['service'] ?? {}),
      package: PackageModel.fromJson(json['package'] ?? {}),
      appointment: AppointmentModel.fromJson(json['appointment'] ?? {}),
      measureClinic:
      MeasureClinicModel.fromJson(json['measure_clinic'] ?? {}),
      measureService:
      MeasureServiceModel.fromJson(json['measure_service'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'is_package': isPackage,
    'package_id': packageId,
    'clinic_id': clinicId,
    'service_id': serviceId,
    'notes': notes,
    'status': status,
    'status_color': statusColor,
    'created_at': createdAt,
    'user': user.toJson(),
    'clinic': clinic.toJson(),
    'service': service.toJson(),
    'package': package.toJson(),
    'appointment': appointment.toJson(),
    'measure_clinic': measureClinic.toJson(),
    'measure_service': measureService.toJson(),
  };
}

class UserModel {
  final int id;
  final String? email;
  final String? username;
  final String? mobile;
  final String firstName;
  final String lastName;
  final String fullName;
  final String gender;
  final String? birthday;
  final int age;
  final int? nationalityId;
  final String? address;
  final String? profilePhoto;
  final String status;
  final String? userType;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    this.email,
    this.username,
    this.mobile,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.gender,
    this.birthday,
    required this.age,
    this.nationalityId,
    this.address,
    this.profilePhoto,
    required this.status,
    this.userType,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? 0,
    email: json['email'],
    username: json['username'],
    mobile: json['mobile'],
    firstName: json['first_name'] ?? '',
    lastName: json['last_name'] ?? '',
    fullName: json['full_name'] ?? '',
    gender: json['gender'] ?? '',
    birthday: json['birthday'],
    age: json['age'] ?? 0,
    nationalityId: json['nationality_id'],
    address: json['address'],
    profilePhoto: json['profile_photo'],
    status: json['status'] ?? '',
    userType: json['user_type'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
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

class ClinicModel {
  final int id;
  final String name;
  final DoctorModel doctor;

  ClinicModel({
    required this.id,
    required this.name,
    required this.doctor,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) => ClinicModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    doctor: DoctorModel.fromJson(json['doctor'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'doctor': doctor.toJson(),
  };
}

class DoctorModel {
  final int id;
  final String firstName;
  final String lastName;
  final String fullName;

  DoctorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
    id: json['id'] ?? 0,
    firstName: json['first_name'] ?? '',
    lastName: json['last_name'] ?? '',
    fullName: json['full_name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'full_name': fullName,
  };
}

class ServiceModel {
  final int id;
  final String name;

  ServiceModel({
    required this.id,
    required this.name,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class PackageModel {
  final int? id;
  final String? name;

  PackageModel({
    this.id,
    this.name,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class AppointmentModel {
  final int? id;
  final String? date;
  final String status;

  AppointmentModel({
    this.id,
    this.date,
    required this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        id: json['id'],
        date: json['date'],
        status: json['status'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'status': status,
  };
}

class MeasureClinicModel {
  final int id;
  final String name;

  MeasureClinicModel({
    required this.id,
    required this.name,
  });

  factory MeasureClinicModel.fromJson(Map<String, dynamic> json) =>
      MeasureClinicModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class MeasureServiceModel {
  final int id;
  final String name;

  MeasureServiceModel({
    required this.id,
    required this.name,
  });

  factory MeasureServiceModel.fromJson(Map<String, dynamic> json) =>
      MeasureServiceModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}