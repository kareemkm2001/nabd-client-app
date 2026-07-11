class InvoiceModel {
  final int id;
  final String title;

  final int invoiceId ;

  final String userName;
  final String clinicName;
  final String doctorName;

  final String serviceName;
  final String invoiceType;
  final String invoiceState;

  final String paymentStatus;
  final String status;
  final String paymentMode;

  final double totalAmount;

  final String createdAt;
  final String insurance;

  final String pdfLink ;

  InvoiceModel({
    required this.id,
    required this.invoiceId,
    required this.title,
    required this.userName,
    required this.clinicName,
    required this.doctorName,
    required this.serviceName,
    required this.invoiceState,
    required this.invoiceType,
    required this.paymentStatus,
    required this.status,
    required this.paymentMode,
    required this.totalAmount,
    required this.createdAt,
    required this.insurance,
    required this.pdfLink
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',

      invoiceId: json['profile']?['id'] ?? 0,



      userName: json['profile']?['name'] ?? '',
      clinicName: json['clinic']?['name'] ?? '',
      doctorName: json['clinic']?['doctor']?['name'] ?? '',

      serviceName: json['service_name'] ?? '',
      invoiceType: json['invoice_type'] ?? '',
      invoiceState: json['status'] ?? '',

      paymentStatus: json['payment_status'] ?? '',
      status: json['status'] ?? '',
      paymentMode: json['payment_mode'] ?? '',

      totalAmount: (json['total_amount'] ?? 0).toDouble(),

      createdAt: json['created_at'] ?? '',
      insurance: json['insurance'] ?? '',
      pdfLink: json["pdf_link"] ?? '',
    );
  }
}