class SubscriptionModel{
  final int id;
  final int packageId;
  final int userId;
  final int clinicId;
  final int serviceId;

  final String status;
  final String statusColor;

  final String invoiceStatus;
  final String invoiceStatusColor;

  final double price;

  final int numberOfSessions;
  final int completedSessions;
  final int remainingSessions;

  final String startDate;
  final String endDate;
  final String? notes;
  final String createdAt;

  // profile
  final String userName;
  final String clinicName;
  final String doctorName;
  final String packageName;
  final String serviceName;

  SubscriptionModel({
    required this.id,
    required this.packageId,
    required this.userId,
    required this.clinicId,
    required this.serviceId,
    required this.status,
    required this.statusColor,
    required this.invoiceStatus,
    required this.invoiceStatusColor,
    required this.price,
    required this.numberOfSessions,
    required this.completedSessions,
    required this.remainingSessions,
    required this.startDate,
    required this.endDate,
    required this.notes,
    required this.createdAt,
    required this.userName,
    required this.clinicName,
    required this.doctorName,
    required this.packageName,
    required this.serviceName,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      packageId: json['package_id'],
      userId: json['user_id'],
      clinicId: json['clinic_id'],
      serviceId: json['service_id'],

      status: json['status'] ?? '',
      statusColor: json['status_color'] ?? '',

      invoiceStatus: json['invoice_status'] ?? '',
      invoiceStatusColor: json['invoice_status_color'] ?? '',

      price: (json['price'] ?? 0).toDouble(),

      numberOfSessions: json['number_of_sessions'] ?? 0,
      completedSessions: json['completed_sessions'] ?? 0,
      remainingSessions: json['remaining_sessions'] ?? 0,

      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      notes: json['notes'],
      createdAt: json['created_at'] ?? '',

      /// nested flattening 👇
      userName: json['profile']?['full_name'] ?? '',
      clinicName: json['clinic']?['name'] ?? '',
      doctorName: json['clinic']?['doctor']?['full_name'] ?? '',
      packageName: json['package']?['name'] ?? '',
      serviceName: json['service']?['name'] ?? '',
    );
  }
}