import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  EmergencyScreen({super.key});
  final List<EmergencyContact> contacts = [
    EmergencyContact(
      name: 'University Counseling',
      phone: '078-121-8195',
      description: '24/7 mental health support',
    ),
    EmergencyContact(
      name: 'Crisis Hotline',
      phone: '988',
      description: 'National suicide prevention lifeline',
    ),
    // Add more contacts
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.emergency, color: Colors.red),
              title: Text(contact.name),
              subtitle: Text(contact.description),
              trailing: IconButton(
                icon: const Icon(Icons.phone),
                color: Colors.green,
                onPressed: () => _callNumber(contact.phone),
              ),
            ),
          );
        },
      ),
    );
  }

  void _callNumber(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String description;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.description,
  });
}