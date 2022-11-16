import 'package:easevent/utils/app_button.dart';
import 'package:easevent/utils/app_color.dart';
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
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  color: AppColors.mPrimary.withAlpha(50),
                  child: const Text(
                    'Create or Join an Event',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: AppColors.mPrimaryAccent.withAlpha(50),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Icon(Icons.add_circle_outline_rounded, size: 100),
                      const SizedBox(height: 10),
                      AppButton(text: 'Create', onPressed: () {}),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: AppColors.mPrimaryAccent.withAlpha(50),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Icon(Icons.add_circle_outline_rounded, size: 100),
                      const SizedBox(height: 10),
                      AppButton(text: 'Join', onPressed: () {}),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
