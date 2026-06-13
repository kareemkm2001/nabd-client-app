class ClinicTimesResponse {
  final int id;
  final int clinicId;
  final String day;
  final String fromTime;
  final String toTime;
  final String period;

  ClinicTimesResponse({
    required this.id,
    required this.clinicId,
    required this.day,
    required this.fromTime,
    required this.toTime,
    required this.period,
  });

  factory ClinicTimesResponse.fromJson(Map<String, dynamic> json) {
    return ClinicTimesResponse(
      id: json['id'],
      clinicId: json['clinic_id'],
      day: json['day'],
      fromTime: json['from_time'],
      toTime: json['to_time'],
      period: json['period'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinic_id': clinicId,
      'day': day,
      'from_time': fromTime,
      'to_time': toTime,
      'period': period,
    };
  }
}