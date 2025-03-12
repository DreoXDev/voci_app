import 'package:voci_app/features/requests/data/models/request.dart';
class RequestEntity {
  String id;
  String? creatorId;
  String homelessID;
  String title;
  String description;
  RequestStatus status;
  int timestamp;
  IconCategory iconCategory;
  Area area;

  RequestEntity({
    required this.id,
    this.creatorId,
    required this.homelessID,
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
    required this.iconCategory,
    required this.area,
  });
}
extension RequestToEntity on Request {
  RequestEntity toEntity() {
    return RequestEntity(
        id: id,
        creatorId: creatorId,
        homelessID: homelessID,
        title: title,
        description: description,
        status: status,
        timestamp: timestamp,
        iconCategory: iconCategory,
        area: area);
  }
}