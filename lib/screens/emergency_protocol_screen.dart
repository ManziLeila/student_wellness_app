import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyProtocolScreen extends StatelessWidget {
  EmergencyProtocolScreen({super.key});
  final List<Protocol> _protocols = [
    Protocol(
      title: 'Panic Attack',
      steps: [
        'Find a quiet space',
        'Practice deep breathing',
        'Focus on a single object',
        'Use grounding techniques',
      ],
      emergencyNumber: '911',
    ),
    // Add more protocols
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Protocols')),
      body: ListView.builder(
        itemCount: _protocols.length,
        itemBuilder: (context, index) {
          final protocol = _protocols[index];
          return ExpansionTile(
            title: Text(protocol.title),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...protocol.steps.map((step) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('• $step'),
                    )),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.phone),
                      label: Text('Call ${protocol.emergencyNumber}'),
                      onPressed: () => launchUrl(
                          Uri.parse('tel:${protocol.emergencyNumber}')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Protocol {
  final String title;
  final List<String> steps;
  final String emergencyNumber;

  Protocol({
    required this.title,
    required this.steps,
    required this.emergencyNumber,
  });
}