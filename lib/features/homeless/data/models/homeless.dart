import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/homeless_entity.dart';

enum HomelessStatus {
  red,
  yellow,
  green,
  gray,
}

enum HomelessGender {
  male,
  female,
  unspecified,
}

enum HomelessArea {
  sud,
  est,
  ovest,
}

class Homeless {
  final String id;
  final String age;
  final HomelessArea area;
  final String description;
  final HomelessGender gender;
  final String location;
  final String name;
  final String nationality;
  final String pets;
  final HomelessStatus status;

  Homeless({
    required this.id,
    required this.age,
    required this.area,
    required this.description,
    required this.gender,
    required this.location,
    required this.name,
    required this.nationality,
    required this.pets,
    required this.status,
  });

  // this method converts the data from firestore
  factory Homeless.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Homeless(
      id: data?['id'] as String? ?? '',
      age: data?['age'] as String? ?? '',
      area: _areaFromString(data?['area'] as String? ?? 'SUD'),
      description: data?['description'] as String? ?? '',
      gender: _genderFromString(data?['gender'] as String? ?? 'Unspecified'),
      location: data?['location'] as String? ?? '',
      name: data?['name'] as String? ?? '',
      nationality: data?['nationality'] as String? ?? '',
      pets: data?['pets'] as String? ?? '',
      status: _statusFromString(data?['status'] as String? ?? 'GRAY'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'age': age,
      'area': _areaToString(area),
      'description': description,
      'gender': _genderToString(gender),
      'location': location,
      'name': name,
      'nationality': nationality,
      'pets': pets,
      'status': _statusToString(status),
    };
  }

  HomelessEntity toEntity() {
    return HomelessEntity(
      id: id,
      age: age,
      area: _areaToString(area),
      description: description,
      gender: _genderToString(gender),
      location: location,
      name: name,
      nationality: nationality,
      pets: pets,
      status: _statusToString(status),
    );
  }

  static HomelessStatus _statusFromString(String statusString) {
    switch (statusString) {
      case 'RED':
        return HomelessStatus.red;
      case 'YELLOW':
        return HomelessStatus.yellow;
      case 'GREEN':
        return HomelessStatus.green;
      default:
        return HomelessStatus.gray;
    }
  }

  static String _statusToString(HomelessStatus status) {
    return status.name.toUpperCase();
  }

  static HomelessGender _genderFromString(String genderString) {
    switch (genderString) {
      case 'Male':
        return HomelessGender.male;
      case 'Female':
        return HomelessGender.female;
      default:
        return HomelessGender.unspecified;
    }
  }

  static String _genderToString(HomelessGender gender) {
    return gender.name;
  }

  static HomelessArea _areaFromString(String areaString) {
    switch (areaString) {
      case 'SUD':
        return HomelessArea.sud;
      case 'EST':
        return HomelessArea.est;
      default:
        return HomelessArea.ovest;
    }
  }

  static String _areaToString(HomelessArea area) {
    return area.name.toUpperCase();
  }
}