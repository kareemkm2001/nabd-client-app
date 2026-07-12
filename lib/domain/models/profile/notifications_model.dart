class NotificationsModel {
  final String? id;
  final String? type;
  final String? notifiableType;
  final int? notifiableId;
  final NotificationContent? data;
  final String? readAt;
  final String? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationsModel({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      id: json['id'],
      type: json['type'],
      notifiableType: json['notifiable_type'],
      notifiableId: json['notifiable_id'],
      data: json['data'] != null
          ? NotificationContent.fromJson(json['data'])
          : null,
      readAt: json['read_at'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

class NotificationContent {
  final int? subscriptionId;
  final String? type;
  final String? title;
  final String? body;

  NotificationContent({
    this.subscriptionId,
    this.type,
    this.title,
    this.body,
  });

  factory NotificationContent.fromJson(Map<String, dynamic> json) {
    return NotificationContent(
      subscriptionId: json['subscription_id'],
      type: json['type'],
      title: json['title'],
      body: json['data'],
    );
  }
}