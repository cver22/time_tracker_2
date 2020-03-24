import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:time_tracker_2/app/models/job.dart';

abstract class Database{
  Future<void> createJob(Job job);

}

class FirestoreDatabase implements Database{
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) async{
    //uid writes user specific data to the database
    final path = '/users/$uid/jobs/job_abc';
    // firestore.instance give access to all firestore methods
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(job.toMap());
  }
}