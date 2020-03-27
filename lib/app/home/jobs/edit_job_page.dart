import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_2/app/home/models/job.dart';
import 'package:time_tracker_2/common_widgets/modal_progress_indicator.dart';
import 'package:time_tracker_2/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_2/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_2/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, this.database, this.job}) : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //assigns initial values if loading an existing job
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    //TODO should be refactored to remove logic from the UI to the data layer
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
        //removes job from the list if it exists so it can be reinserted
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already exists',
            content: 'Please chose another name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          //if job is not null get job id from the job, otherwise set id using current date
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
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
          title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
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
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value.trim(),
        //
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        //if editing adds value to field, if not, ensures null text is not passed
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
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
