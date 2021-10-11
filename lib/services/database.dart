import 'package:flutter/foundation.dart';
import 'package:timer_tracker_flutter_course/app/home/models/job.dart';
import 'package:timer_tracker_flutter_course/services/api_path.dart';
import 'package:timer_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final _service = FirestoreService.instance;

  static String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
}
