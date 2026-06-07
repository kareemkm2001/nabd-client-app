class ClinicResModel {
  final int id;
  final String name;
  final String doctorName;
  final String label;

  ClinicResModel({
    required this.id,
    required this.name,
    required this.doctorName,
    required this.label,
  });

  factory ClinicResModel.fromJson(Map<String, dynamic> json) {
    return ClinicResModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      label: json['label'] ?? '',
    );
  }
}