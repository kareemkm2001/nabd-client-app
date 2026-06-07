class ClinicServicesDataModel {
  final Clinic clinic;
  final List<Service> services;

  ClinicServicesDataModel({
    required this.clinic,
    required this.services,
  });

  factory ClinicServicesDataModel.fromJson(Map<String, dynamic> json) {
    return ClinicServicesDataModel(
      clinic: Clinic.fromJson(json['clinic']),
      services: (json['services'] as List<dynamic>? ?? [])
          .map((e) => Service.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinic': clinic.toJson(),
      'services': services.map((e) => e.toJson()).toList(),
    };
  }
}

class Clinic {
  final int id;
  final String name;
  final String type;
  final String status;

  Clinic({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
    };
  }
}

class Service {
  final int id;
  final String name;
  final double price;
  final int duration;
  final int visitType;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.visitType,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      visitType: json['visit_type'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration': duration,
      'visit_type': visitType,
    };
  }
}