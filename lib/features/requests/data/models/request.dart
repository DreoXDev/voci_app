import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestStatus {
  todo,
  done,
}

enum RequestIconCategory {
  shoes("Scarpe"),
  pants("Pantaloni"),
  shirt("Maglietta"),
  cap("Cappello"),
  underwear("Intimo"),
  other("Altro");

  final String displayName;
  const RequestIconCategory(this.displayName);
}

enum RequestArea {
  ovest,
  est,
  sud,
}

class Request {
  String id;
  String? creatorId;
  String homelessID;
  String title;
  String description;
  RequestStatus status;
  int timestamp;
  RequestIconCategory iconCategory;
  RequestArea area;

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
      'status': status.name.toUpperCase(),
      'timestamp': timestamp,
      'iconCategory': iconCategory.name.toUpperCase(),
      'area': area.name.toUpperCase(),
    };
  }

  static RequestStatus _parseStatus(String? statusString) {
    if (statusString == null) return RequestStatus.todo; // Default value
    return RequestStatus.values.firstWhere(
          (e) => e.name.toUpperCase() == statusString,
      orElse: () => RequestStatus.todo, // Default if not found
    );
  }

  static RequestIconCategory _parseIconCategory(String? categoryString) {
    if (categoryString == null) return RequestIconCategory.other; // Default value
    return RequestIconCategory.values.firstWhere(
          (e) => e.name.toUpperCase() == categoryString,
      orElse: () => RequestIconCategory.other, // Default if not found
    );
  }

  static RequestArea _parseArea(String? areaString) {
    if (areaString == null) return RequestArea.ovest; // Default value
    return RequestArea.values.firstWhere(
          (e) => e.name.toUpperCase() == areaString,
      orElse: () => RequestArea.ovest, // Default if not found
    );
  }
}