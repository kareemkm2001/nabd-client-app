class CreateSubscriptionRequestModel {
  final int userId;
  final int clinicId;
  final int packageId;
  final int? couponId;
  final String termsMetricsSubscriptions;

  CreateSubscriptionRequestModel({
    required this.userId,
    required this.clinicId,
    required this.packageId,
    this.couponId,
    required this.termsMetricsSubscriptions,
  });

  factory CreateSubscriptionRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionRequestModel(
      userId: json['user_id'],
      clinicId: json['clinic_id'],
      packageId: json['package_id'],
      couponId: json['coupon_id'],
      termsMetricsSubscriptions: json['terms_metrics_subscriptions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'clinic_id': clinicId,
      'package_id': packageId,
      'coupon_id': couponId,
      'terms_metrics_subscriptions': termsMetricsSubscriptions,
    };
  }
}