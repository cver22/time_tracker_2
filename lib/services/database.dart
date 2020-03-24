import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:time_tracker_2/app/models/job.dart';
import 'package:time_tracker_2/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
  void readJobs();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) async => await _setData(
        path: APIPath.job(uid: uid, jobId: 'job_bcd'),
        data: job.toMap(),
      );

  void readJobs(){
    final path = APIPath.jobs(uid: uid);
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    //test code the prints the data
    snapshots.listen((snapshots){
      snapshots.documents.forEach((snapshots) => print(snapshots.data));
    });
}

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    //print('$path: $data');
    await reference.setData(data);
  }
}
