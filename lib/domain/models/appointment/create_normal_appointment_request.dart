class CreateNormalAppointmentRequest {
  final int userId;
  final int clinicId;
  final int serviceId;
  final String date;
  final int availableTime;
  final int availableSlot;
  final List<String> fromTime;
  final List<String> toTime;
  final int appointmentType;
  final int type;
  final int? couponId;
  final int? orderId;
  final int paymentMethod;

  CreateNormalAppointmentRequest({
    required this.userId,
    required this.clinicId,
    required this.serviceId,
    required this.date,
    required this.availableTime,
    required this.availableSlot,
    required this.fromTime,
    required this.toTime,
    required this.appointmentType,
    required this.type,
    this.couponId,
    this.orderId,
    required this.paymentMethod,
  });

  factory CreateNormalAppointmentRequest.fromJson(Map<String, dynamic> json) {
    return CreateNormalAppointmentRequest(
      userId: json["user_id"],
      clinicId: json["clinic_id"],
      serviceId: json["service_id"],
      date: json["date"],
      availableTime: json["available_time"],
      availableSlot: json["available_slot"],
      fromTime: List<String>.from(json["from_time"] ?? []),
      toTime: List<String>.from(json["to_time"] ?? []),
      appointmentType: json["appointment_type"],
      type: json["type"],
      couponId: json["coupon_id"],
      orderId: json["order_id"],
      paymentMethod: json["payment_method"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "clinic_id": clinicId,
      "service_id": serviceId,
      "date": date,
      "available_time": availableTime,
      "available_slot": availableSlot,
      "from_time": fromTime,
      "to_time": toTime,
      "appointment_type": appointmentType,
      "type": type,
      "coupon_id": couponId,
      "order_id": orderId,
      "payment_method": paymentMethod,
    };
  }
}