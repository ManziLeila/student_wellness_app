import 'package:flutter/material.dart';

class MeditationScreen extends StatelessWidget {
  MeditationScreen({super.key});

  final List<MeditationSession> sessions = [
    MeditationSession(
      title: 'Basic Breathing',
      duration: '5 min',
      description: 'Learn basic breathing techniques for stress relief',
      isPremium: false,
    ),
    MeditationSession(
      title: 'Deep Relaxation',
      duration: '15 min',
      description: 'Guided meditation for deep relaxation',
      isPremium: true,
    ),
    // Add more sessions
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meditation Center')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome To,',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'Meditation Centre',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Let's Start →"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // User greeting
              Text(
                'Welcome Back\nkezal',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                'You have been here for\n${DateTime.now().difference(DateTime(2023, 1, 1)).inDays} days!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 16),

              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Calm', 'Sleep', 'Focus', 'Breath'].map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(category),
                        backgroundColor: Colors.blue[100],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Motivation card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to start your first session?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Motivation is calm again!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.grey[300],
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    const Text('20 Minutes'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sessions header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meditations',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View all'),
                  ),
                ],
              ),

              // Sessions list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return MeditationCard(session: session);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeditationCard extends StatelessWidget {
  final MeditationSession session;

  const MeditationCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  session.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (session.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('PREMIUM'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(session.description),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16),
                const SizedBox(width: 4),
                Text(session.duration),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Start meditation session
                  },
                  child: const Text('Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MeditationSession {
  final String title;
  final String duration;
  final String description;
  final bool isPremium;

  MeditationSession({
    required this.title,
    required this.duration,
    required this.description,
    this.isPremium = false,
  });
}