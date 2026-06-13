class PackageForClinicModel {
  final int id;
  final String name;
  final int clinicId;
  final int serviceId;
  final int numberOfSessions;
  final num price;
  final num sessionPrice;
  final String status;
  final int show;
  final String? notes;

  PackageForClinicModel({
    required this.id,
    required this.name,
    required this.clinicId,
    required this.serviceId,
    required this.numberOfSessions,
    required this.price,
    required this.sessionPrice,
    required this.status,
    required this.show,
    this.notes,
  });

  factory PackageForClinicModel.fromJson(Map<String, dynamic> json) {
    return PackageForClinicModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      clinicId: json['clinic_id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      numberOfSessions: json['number_of_sessions'] ?? 0,
      price: json['price'] ?? 0,
      sessionPrice: json['session_price'] ?? 0,
      status: json['status'] ?? '',
      show: json['show'] ?? 0,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'clinic_id': clinicId,
      'service_id': serviceId,
      'number_of_sessions': numberOfSessions,
      'price': price,
      'session_price': sessionPrice,
      'status': status,
      'show': show,
      'notes': notes,
    };
  }
}