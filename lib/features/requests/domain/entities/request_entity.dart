import 'package:voci_app/features/requests/data/models/request.dart';

class RequestEntity {
  String id;
  String? creatorId;
  String homelessID;
  String title;
  String description;
  String status;
  int timestamp;
  String iconCategory;
  String area;

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
        status: status.name,
        timestamp: timestamp,
        iconCategory: iconCategory.name,
        area: area.name);
  }
}
extension RequestEntityToModel on RequestEntity {
  Request toModel(){
    return Request(
        id: id,
        creatorId: creatorId,
        homelessID: homelessID,
        title: title,
        description: description,
        status: _parseStatus(status),
        timestamp: timestamp,
        iconCategory: _parseIconCategory(iconCategory),
        area: _parseArea(area)
    );
  }

  RequestStatus _parseStatus(String statusString) {
    return RequestStatus.values.firstWhere(
          (e) => e.name.toUpperCase() == statusString.toUpperCase(),
      orElse: () => RequestStatus.todo, // Default if not found
    );
  }

  RequestIconCategory _parseIconCategory(String categoryString) {
    return RequestIconCategory.values.firstWhere(
          (e) => e.name.toUpperCase() == categoryString.toUpperCase(),
      orElse: () => RequestIconCategory.other, // Default if not found
    );
  }

  RequestArea _parseArea(String areaString) {
    return RequestArea.values.firstWhere(
          (e) => e.name.toUpperCase() == areaString.toUpperCase(),
      orElse: () => RequestArea.ovest, // Default if not found
    );
  }
}