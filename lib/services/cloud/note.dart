import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:noteys/services/cloud/constants.dart';

@immutable
class CloudNote {
  final String id;
  final String ownerId;
  final String text;

  const CloudNote({
    required this.id,
    required this.ownerId,
    required this.text,
  });
  CloudNote.fromSnap(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        ownerId = snapshot.data()[ownerIdField] as String,
        text = snapshot.data()[textField] as String;
}
