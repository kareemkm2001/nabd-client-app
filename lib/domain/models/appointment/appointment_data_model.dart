class AppointmentDataModel {
  final int id;
  final int userId;
  final String date;
  final String fromTime;
  final String toTime;
  final bool isPackage;
  final dynamic packageOrder;
  final String status;
  final String statusColor;
  final String type;
  final String typeColor;
  final num price;
  final String? notes;
  final String confirmed;
  final String? startAt;
  final String? joinUrl;
  final String createdAt;
  final String updatedAt;

  final List<UserModel> users;
  final Clinic clinic;
  final Service service;

  final int? invoiceId;

  final List<AttachmentModel> attachments;
  final List<TreatmentPlan> treatmentPlans;
  final List reports ;

  AppointmentDataModel({
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
    required this.price,
    this.notes,
    required this.confirmed,
    this.startAt,
    this.joinUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.users,
    required this.clinic,
    required this.service,
    this.invoiceId,
    required this.attachments,
    required this.treatmentPlans,
    required this.reports
  });

  factory AppointmentDataModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDataModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      date: json['date'] ?? '',
      fromTime: json['from_time'] ?? '',
      toTime: json['to_time'] ?? '',
      isPackage: json['is_package'] ?? false,
      packageOrder: json['package_order'],
      status: json['status'] ?? '',
      statusColor: json['status_color'] ?? '',
      type: json['type'] ?? '',
      typeColor: json['type_color'] ?? '',
      price: json['price'] ?? 0,
      notes: json['notes'],
      confirmed: json['confirmed'] ?? '',
      startAt: json['start_at'],
      joinUrl: json['join_url'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      invoiceId: json['invoice_id'],

      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e))
          .toList() ??
          [],

      clinic: Clinic.fromJson(json['clinic'] ?? {}),

      service: Service.fromJson(json['service'] ?? {}),

      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => AttachmentModel.fromJson(e))
          .toList() ??
          [],

      treatmentPlans: (json['treatment_plans'] as List<dynamic>?)
          ?.map((e) => TreatmentPlan.fromJson(e))
          .toList() ??
          [],

      reports: (json['reports'] as List<dynamic>?) ?? []
    );
  }
}
class TreatmentPlan {
  final int id;
  final String name;
  final String? organicDiseases;
  final String? surgeries;
  final String? menstruation;
  final String? currentComplaint;
  final String? recommendations;
  final String? notes;

  TreatmentPlan({
    required this.id,
    required this.name,
    this.organicDiseases,
    this.surgeries,
    this.menstruation,
    this.currentComplaint,
    this.recommendations,
    this.notes,
  });

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      id: json['id'],
      name: json['name'] ?? '',
      organicDiseases: json['organic_diseases'],
      surgeries: json['surgeries'],
      menstruation: json['menstruation'],
      currentComplaint: json['current_complaint'],
      recommendations: json['recommendations'],
      notes: json['notes'],
    );
  }
}

class AttachmentModel {
  final int id;
  final String fileName;
  final String type;
  final String? notes;
  final String fileType;
  final String attachment;
  final String status;

  AttachmentModel({
    required this.id,
    required this.fileName,
    required this.type,
    this.notes,
    required this.fileType,
    required this.attachment,
    required this.status,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'],
      fileName: json['file_name'] ?? '',
      type: json['type'] ?? '',
      notes: json['notes'],
      fileType: json['fileType'] ?? '',
      attachment: json['attachment'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Doctor {
  final int id;
  final String fullName;

  Doctor({
    required this.id,
    required this.fullName,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      fullName: json['full_name'] ?? '',
    );
  }
}

class Service {
  final int id;
  final String name;

  Service({
    required this.id,
    required this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class Clinic {
  final int id;
  final String name;
  final Doctor doctor;

  Clinic({
    required this.id,
    required this.name,
    required this.doctor,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      name: json['name'] ?? '',
      doctor: Doctor.fromJson(json['doctor']),
    );
  }
}

class LastVisit {
  final int id;
  final String date;
  final String status;
  final String type;

  LastVisit({
    required this.id,
    required this.date,
    required this.status,
    required this.type,
  });

  factory LastVisit.fromJson(Map<String, dynamic> json) {
    return LastVisit(
      id: json['id'],
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
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
  final String status;
  final String userType;
  final LastVisit? lastVisit;

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
    required this.status,
    required this.userType,
    this.lastVisit,
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
      status: json['status'] ?? '',
      userType: json['user_type'] ?? '',
      lastVisit: json['last_visit'] != null
          ? LastVisit.fromJson(json['last_visit'])
          : null,
    );
  }
}