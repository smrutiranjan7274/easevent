import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:flutter/material.dart';

import 'get_event_details.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Event Ids
  List<String> eventIds = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore all the events!',
            style: TextStyle(
              color: AppColors.mPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getEventIDs(),
              builder: (context, snapshot) {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: eventIds.length,
                  separatorBuilder: ((context, index) => const Divider()),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: AppColors.cPrimaryAccent.withAlpha(80),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: GetEventName(eventId: eventIds[index]),
                                subtitle:
                                    GetEventLocation(eventId: eventIds[index]),
                                trailing:
                                    GetEventDate(eventId: eventIds[index]),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Description:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GetEventDescription(
                                        eventId: eventIds[index]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Get Event IDs
  Future getEventIDs() async {
    await FirebaseFirestore.instance
        .collection('events')
        .orderBy("date", descending: false)
        .get()
        .then(
          (eventsSnapshot) => eventsSnapshot.docs.forEach(
            (event) {
              print(event.reference.id);
              eventIds.add(event.reference.id);
            },
          ),
        );
  }
}
