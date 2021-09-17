import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker_flutter_course/app/home/models/job.dart';
import 'package:timer_tracker_flutter_course/services/database.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key key, @required this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    // Ele pegou pelo context o Provider do jobs_page
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddJobPage(
            database: database,
          ),
          fullscreenDialog: true,
        ));
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formkey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

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
      final job = Job(
        name: _name,
        ratePerHour: _ratePerHour,
      );
      await widget.database.createJob(job);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('New Job'),
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
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Rate per hour',
        ),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.parse(value) ?? 0,
      ),
    ];
  }
}
