import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:time_tracker_2/app/home/models/job.dart';
import 'package:time_tracker_2/services/api_path.dart';
import 'package:time_tracker_2/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Future<void> deleteJob(Job job);

  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid: uid, jobId: job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async => await _service.deleteData(
        path: APIPath.job(uid: uid, jobId: job.id),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid: uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

//test code the prints the data
/*snapshots.listen((snapshots){
      snapshots.documents.forEach((snapshots) => print(snapshots.data));
    });*/

}
