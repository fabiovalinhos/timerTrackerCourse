import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker_flutter_course/app/home/models/job.dart';
import 'package:timer_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:timer_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:timer_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context,
      {Database database, Job job}) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditJobPage(
            database: database,
            job: job,
          ),
          fullscreenDialog: true,
        ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formkey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }

        if (allNames.contains(_name)) {
          ShowAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'Ok',
          );
        } else {
          final id =
              widget.job?.id ?? FirestoreDatabase.documentIdFromCurrentDate();
          final job = Job(
            id: id,
            name: _name,
            ratePerHour: _ratePerHour,
          );
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      // scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _BuildFormChildren(),
      ),
    );
  }

  List<Widget> _BuildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Job name',
        ),
        initialValue: _name,
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Rate per hour',
        ),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
