import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/homeless_entity.dart';

class Homeless {
  final String id;
  final String age;
  final String area;
  final String description;
  final String gender;
  final String location;
  final String name;
  final String nationality;
  final String pets;
  final String status;

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
      area: data?['area'] as String? ?? '',
      description: data?['description'] as String? ?? '',
      gender: data?['gender'] as String? ?? '',
      location: data?['location'] as String? ?? '',
      name: data?['name'] as String? ?? '',
      nationality: data?['nationality'] as String? ?? '',
      pets: data?['pets'] as String? ?? '',
      status: data?['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'age': age,
      'area': area,
      'description': description,
      'gender': gender,
      'location': location,
      'name': name,
      'nationality': nationality,
      'pets': pets,
      'status': status,
    };
  }

  HomelessEntity toEntity() {
    return HomelessEntity(
      id: id,
      age: age,
      area: area,
      description: description,
      gender: gender,
      location: location,
      name: name,
      nationality: nationality,
      pets: pets,
      status: status,
    );
  }
}