import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/utils/app_button.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:easevent/utils/app_snackbar.dart';
import 'package:easevent/utils/app_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  // ignore: non_constant_identifier_names
  String event_type = 'All';
  // ignore: non_constant_identifier_names
  List<String> list_item = ['All', 'Students', 'Faculty', 'Parents'];

  DateTime? date = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);

  // Text Conrollers
  final data = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventStartTimeController = TextEditingController();
  final _eventEndTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeController.text = '${date!.hour}:${date!.minute}:${date!.second}';
    dateController.text = '${date!.day}/${date!.month}/${date!.year}';
  }

  resetControllers() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _eventLocationController.dispose();
    _eventDateController.dispose();
    _eventStartTimeController.dispose();
    _eventEndTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Create Event'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Event Type
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListTile(
                  title: const Text(
                    'Event Type',
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 2, color: AppColors.cPrimary),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: Container(),
                      borderRadius: BorderRadius.circular(8),
                      elevation: 3,
                      items: list_item
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(
                          () {
                            event_type = newValue!;
                          },
                        );
                      },
                      value: event_type,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Event Name
              AppTextField(
                maxLines: 1,
                hintText: 'Event Name',
                isPassword: false,
                textCapitalization: TextCapitalization.words,
                controller: _eventNameController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Event Description
              AppTextField(
                minLines: 3,
                maxLines: 6,
                hintText: 'Event Description',
                isPassword: false,
                textCapitalization: TextCapitalization.sentences,
                controller: _eventDescriptionController,
              ),
              const SizedBox(height: 20),

              // Event Location
              AppTextField(
                maxLines: 1,
                hintText: 'Event Location',
                isPassword: false,
                textCapitalization: TextCapitalization.sentences,
                controller: _eventLocationController,
                suffixIcon: Icon(Icons.location_on, color: AppColors.mPrimary),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),

              // Event Date
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AppTextField(
                  enabled: false,
                  maxLines: 1,
                  hintText: 'Event Date',
                  isPassword: false,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _eventDateController,
                  suffixIcon:
                      Icon(Icons.calendar_month, color: AppColors.mPrimary),
                ),
              ),
              const SizedBox(height: 20),

              // Event Time
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _selectStartTime(context);
                      },
                      child: AppTextField(
                        controller: _eventStartTimeController,
                        enabled: false,
                        hintText: 'Start',
                        suffixIcon:
                            Icon(Icons.access_time, color: AppColors.mPrimary),
                        isPassword: false,
                        textCapitalization: TextCapitalization.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _selectEndTime(context);
                      },
                      child: AppTextField(
                        controller: _eventEndTimeController,
                        enabled: false,
                        hintText: 'End',
                        suffixIcon:
                            Icon(Icons.access_time, color: AppColors.mPrimary),
                        isPassword: false,
                        textCapitalization: TextCapitalization.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppButton(
                  text: 'Create',
                  onPressed: () async {
                    // Show loading circle
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    await _createEvent();

                    // Pop loading circle
                    if (!mounted) return;
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // Select Date function
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date = DateTime(picked.year, picked.month, picked.day, date!.hour,
          date!.minute, date!.second);
      _eventDateController.text = '${date!.day}-${date!.month}-${date!.year}';
    }
    setState(() {});
  }

  // Select Start Time function
  _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime = picked;
      _eventStartTimeController.text =
          '${startTime.hourOfPeriod > 9 ? "" : '0'}${startTime.hour > 12 ? '${startTime.hour - 12}' : startTime.hour}:${startTime.minute > 9 ? startTime.minute : '0${startTime.minute}'} ${startTime.hour > 12 ? 'PM' : 'AM'}';
    }
    // print("start ${_eventStartTimeController.text}");
    setState(() {});
  }

  // Select End Time function
  _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTime = picked;
      _eventEndTimeController.text =
          '${endTime.hourOfPeriod > 9 ? "" : '0'}${endTime.hour > 12 ? '${endTime.hour - 12}' : endTime.hour}:${endTime.minute > 9 ? endTime.minute : '0${endTime.minute}'} ${endTime.hour > 12 ? 'PM' : 'AM'}';
    }
    // print("end ${_eventEndTimeController.text}");
    setState(() {});
  }

  // Create Event Function
  Future _createEvent() async {
    // TODO: Validate all fields

    Map<String, dynamic> eventData = {
      'event': event_type,
      'event_name': _eventNameController.text,
      'location': _eventLocationController.text,
      'date': '${date!.day}-${date!.month}-${date!.year}',
      'start_time': _eventStartTimeController.text,
      'end_time': _eventEndTimeController.text,
      'description': _eventDescriptionController.text,
      'joined': [FirebaseAuth.instance.currentUser!.uid],
      'event_id': '',
      'inviter': [FirebaseAuth.instance.currentUser!.uid],
      'event_link': '',
    };

    try {
      await FirebaseFirestore.instance
          .collection('events')
          .add(eventData)
          .then((result) {
        FirebaseFirestore.instance.collection('events').doc(result.id).update({
          'event_id': result.id,
        });
      });
      if (!mounted) return;
      return AppSnackbar.showSuccessSnackBar(
          context, 'Event Created Successfully!');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return AppSnackbar.showErrorSnackBar(context, 'Error creating event!');
    }
  }
}
