import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mood.dart';
import '../providers/mood_provider.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? selectedMood;
  int intensity = 3;
  final TextEditingController _notesController = TextEditingController();

  final List<String> moodTypes = [
    'Happy', 'Sad', 'Angry', 'Anxious', 'Tired', 'Excited', 'Peaceful'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Your Mood')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('How are you feeling today?',
                style: Theme.of(context).textTheme.headlineSmall),

            Wrap(
              spacing: 8.0,
              children: moodTypes.map((mood) => ChoiceChip(
                label: Text(mood),
                selected: selectedMood == mood,
                onSelected: (selected) => setState(() => selectedMood = mood),
              )).toList(),
            ),

            const SizedBox(height: 20),
            Text('Intensity: $intensity'),
            Slider(
              value: intensity.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) => setState(() => intensity = value.toInt()),
            ),

            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Any notes about your mood?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedMood != null) {
                  // Save mood to provider/database
                  final mood = Mood(
                    id: DateTime.now().toString(),
                    userId: 'current_user_id', // Replace with actual user ID
                    date: DateTime.now(),
                    moodType: selectedMood!,
                    intensity: intensity,
                    notes: _notesController.text,
                  );

                  Provider.of<MoodProvider>(context, listen: false).addMood(mood);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Mood'),
            ),
          ],
        ),
      ),
    );
  }
}