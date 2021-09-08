import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker_flutter_course/app/home/jobs/add_job_page.dart';
import 'package:timer_tracker_flutter_course/app/home/models/job.dart';
import 'package:timer_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:timer_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:timer_tracker_flutter_course/services/auth.dart';
import 'package:timer_tracker_flutter_course/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await ShowAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure that you want to logout?',
        defaultActionText: 'Logout',
        cancelActionText: 'Cancel');

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(
        name: 'Blogging',
        ratePerHour: 15,
      ));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          )
        ],
      ),
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddJobPage.show(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs
              .map(
                (job) => Text(job.name),
              )
              .toList();
          return ListView(
            children: children,
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Some error occurred'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
