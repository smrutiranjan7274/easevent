import 'package:easevent/pages/events/create_event_page.dart';
import 'package:easevent/pages/events/join_event_page.dart';
import 'package:easevent/utils/app_button.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Create / Edit / Join an Event',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            AppButton(
              text: "Create",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateEventPage(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'Edit Event',
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'Join',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JoinEventPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
