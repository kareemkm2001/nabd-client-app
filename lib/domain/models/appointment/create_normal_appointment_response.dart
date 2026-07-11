class CreateNormalAppointmentResponse {
  final int? orderId;
  final int? couponId;
  final int userId;
  final int clinicId;
  final int serviceId;
  final String date;
  final int availableTime;
  final int appointmentType;
  final String type;
  final int createdByUser;
  final int paymentMethod;
  final String fromTime;
  final String toTime;
  final double totalAmount;
  final int couponValue;
  final int amount;
  final String tax;
  final String title;
  final String firstName;
  final String lastName;
  final String? email;
  final String countryCode;
  final String mobile;
  final String currency;
  final String status;
  final String paymentId;
  final String transactionUrl;
  final String updatedAt;
  final String createdAt;
  final int id;

  CreateNormalAppointmentResponse({
    this.orderId,
    this.couponId,
    required this.userId,
    required this.clinicId,
    required this.serviceId,
    required this.date,
    required this.availableTime,
    required this.appointmentType,
    required this.type,
    required this.createdByUser,
    required this.paymentMethod,
    required this.fromTime,
    required this.toTime,
    required this.totalAmount,
    required this.couponValue,
    required this.amount,
    required this.tax,
    required this.title,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.countryCode,
    required this.mobile,
    required this.currency,
    required this.status,
    required this.paymentId,
    required this.transactionUrl,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory CreateNormalAppointmentResponse.fromJson(Map<String, dynamic> json) {
    return CreateNormalAppointmentResponse(
      orderId: json["order_id"],
      couponId: json["coupon_id"],
      userId: json["user_id"],
      clinicId: json["clinic_id"],
      serviceId: json["service_id"],
      date: json["date"],
      availableTime: json["available_time"],
      appointmentType: json["appointment_type"],
      type: json["type"],
      createdByUser: json["created_by_user"],
      paymentMethod: json["payment_method"],
      fromTime: json["from_time"],
      toTime: json["to_time"],
      totalAmount: (json["total_amount"] as num).toDouble(),
      couponValue: json["coupon_value"],
      amount: json["amount"],
      tax: json["tax"].toString(),
      title: json["title"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      countryCode: json["country_code"],
      mobile: json["mobile"],
      currency: json["currency"],
      status: json["status"],
      paymentId: json["payment_id"],
      transactionUrl: json["transaction_url"],
      updatedAt: json["updated_at"],
      createdAt: json["created_at"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "order_id": orderId,
      "coupon_id": couponId,
      "user_id": userId,
      "clinic_id": clinicId,
      "service_id": serviceId,
      "date": date,
      "available_time": availableTime,
      "appointment_type": appointmentType,
      "type": type,
      "created_by_user": createdByUser,
      "payment_method": paymentMethod,
      "from_time": fromTime,
      "to_time": toTime,
      "total_amount": totalAmount,
      "coupon_value": couponValue,
      "amount": amount,
      "tax": tax,
      "title": title,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "country_code": countryCode,
      "mobile": mobile,
      "currency": currency,
      "status": status,
      "payment_id": paymentId,
      "transaction_url": transactionUrl,
      "updated_at": updatedAt,
      "created_at": createdAt,
      "id": id,
    };
  }
}