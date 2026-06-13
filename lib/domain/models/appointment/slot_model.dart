class SlotModel {
  final int id;
  final String fromTime;
  final String toTime;
  final bool appointment;

  SlotModel({
    required this.id,
    required this.fromTime,
    required this.toTime,
    required this.appointment,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['id'],
      fromTime: json['from_time'],
      toTime: json['to_time'],
      appointment: json['appointment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_time': fromTime,
      'to_time': toTime,
      'appointment': appointment,
    };
  }
}