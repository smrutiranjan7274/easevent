import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Get Event Name
class GetEventName extends StatelessWidget {
  final String eventId;

  const GetEventName({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    // Get Collection reference
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventId).get(),
      builder: (context, eventDocument) {
        if (eventDocument.connectionState == ConnectionState.done) {
          Map<String, dynamic> event =
              eventDocument.data!.data() as Map<String, dynamic>;
          return Text(
            event['event_name'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return const Text(
            'Loading...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
}

// Get Event Date and Time
class GetEventDate extends StatelessWidget {
  final String eventId;

  const GetEventDate({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    // Get Collection reference
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventId).get(),
      builder: (context, eventDocument) {
        if (eventDocument.connectionState == ConnectionState.done) {
          Map<String, dynamic> event =
              eventDocument.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Text(
                '${event['date']}',
                style: TextStyle(
                  color: AppColors.mPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '${event['start_time']}-${event['end_time']}',
                style: const TextStyle(fontSize: 10),
              ),
            ],
          );
        } else {
          return Text(
            'Loading...',
            style: TextStyle(
              color: AppColors.mPrimary,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
}

// Get Event Location
class GetEventLocation extends StatelessWidget {
  final String eventId;

  const GetEventLocation({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    // Get Collection reference
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventId).get(),
      builder: (context, eventDocument) {
        if (eventDocument.connectionState == ConnectionState.done) {
          Map<String, dynamic> event =
              eventDocument.data!.data() as Map<String, dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                '${event['location']}',
                style: TextStyle(
                  color: AppColors.mPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          );
        } else {
          return const Text(
            'Loading...',
          );
        }
      },
    );
  }
}

// Get Event Description
class GetEventDescription extends StatelessWidget {
  final String eventId;

  const GetEventDescription({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    // Get Collection reference
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');
    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventId).get(),
      builder: (context, eventDocument) {
        if (eventDocument.connectionState == ConnectionState.done) {
          Map<String, dynamic> event =
              eventDocument.data!.data() as Map<String, dynamic>;

          return Text(
            '${event['description']}',
            textAlign: TextAlign.justify,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.mPrimary,
              // fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return Text(
            'Loading...',
            style: TextStyle(
              color: AppColors.mPrimary,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
}
