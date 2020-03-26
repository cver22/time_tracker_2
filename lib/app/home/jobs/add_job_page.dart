import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_2/app/home/models/job.dart';
import 'package:time_tracker_2/common_widgets/modal_progress_indicator.dart';
import 'package:time_tracker_2/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_2/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_2/services/database.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key key, this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddJobPage(
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;
  bool _isLoading = false;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    //await Future.delayed(const Duration(seconds: 5));
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        //first gives a subscription to the stream and disposes it as soon
        //as a value is available
        final allNames = jobs.map((job) => job.name).toList();
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already exists',
            content: 'Please chose another name',
            defaultActionText: 'OK',
          ).show(context);
        }else {
          final job = Job(name: _name, ratePerHour: _ratePerHour);
          await widget.database.createJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
        //DONE show error to user

      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressIndicator(
      child: Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          title: Text('New Job'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              onPressed: _isLoading ? null : _submit,
            )
          ],
        ),
        body: _buildContents(),
        backgroundColor: Colors.grey[200],
      ),
      isLoading: _isLoading,
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
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
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value.trim(),
        //
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        // defaults to zero if null
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        //enabled: !_isLoading,
      ),
    ];
  }
}
