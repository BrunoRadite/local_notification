class NotificationModel {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  NotificationModel({
    required this.id,
    required this.body,
    required this.payload,
    required this.title,
  });
}
