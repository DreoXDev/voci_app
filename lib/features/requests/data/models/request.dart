import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestStatus {
  TODO,
  DONE,
}

enum IconCategory {
  OTHER,
  // You can add more categories here
}

enum Area {
  OVEST,
  // Add more area types here if needed.
}

class Request {
  String id;
  String? creatorId;
  String homelessID;
  String title;
  String description;
  RequestStatus status;
  int timestamp;
  IconCategory iconCategory;
  Area area;

  Request({
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

  factory Request.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Request(
      id: data?['id'],
      creatorId: data?['creatorId'],
      homelessID: data?['homelessID'],
      title: data?['title'],
      description: data?['description'],
      status: _parseStatus(data?['status']),
      timestamp: data?['timestamp'],
      iconCategory: _parseIconCategory(data?['iconCategory']),
      area: _parseArea(data?['area']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'homelessID': homelessID,
      'title': title,
      'description': description,
      'status': status.name,
      'timestamp': timestamp,
      'iconCategory': iconCategory.name,
      'area': area.name,
    };
  }
  static RequestStatus _parseStatus(String? statusString) {
    if (statusString == null) return RequestStatus.TODO; // Default value
    return RequestStatus.values.firstWhere(
          (e) => e.name == statusString,
      orElse: () => RequestStatus.TODO, // Default if not found
    );
  }
  static IconCategory _parseIconCategory(String? statusString) {
    if (statusString == null) return IconCategory.OTHER; // Default value
    return IconCategory.values.firstWhere(
          (e) => e.name == statusString,
      orElse: () => IconCategory.OTHER, // Default if not found
    );
  }
  static Area _parseArea(String? statusString) {
    if (statusString == null) return Area.OVEST; // Default value
    return Area.values.firstWhere(
          (e) => e.name == statusString,
      orElse: () => Area.OVEST, // Default if not found
    );
  }
}