import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_profile.dart';
import '../../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  UserProfile? _profile;
  final List<String> _universities = ['Harvard', 'Stanford', 'MIT', 'Other'];
  final List<String> _interestOptions = [
    'Anxiety',
    'Depression',
    'Stress',
    'Sleep',
    'Relationships'
  ];

  @override
  void initState() {
    super.initState();
    _profile = context.read<UserProvider>().profile;
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null && _profile != null) {
      setState(() => _profile!.avatarUrl = image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profile!.avatarUrl != null
                      ? FileImage(File(_profile!.avatarUrl!))
                      : null,
                  child: _profile!.avatarUrl == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              TextFormField(
                initialValue: _profile!.displayName,
                decoration: const InputDecoration(labelText: 'Display Name'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => _profile!.displayName = value!,
              ),
              DropdownButtonFormField<String>(
                value: _profile!.university,
                items: _universities
                    .map((uni) => DropdownMenuItem(
                  value: uni,
                  child: Text(uni),
                ))
                    .toList(),
                onChanged: (value) => _profile!.university = value!,
                decoration: const InputDecoration(labelText: 'University'),
              ),
              Wrap(
                spacing: 8,
                children: _interestOptions.map((interest) {
                  return FilterChip(
                    label: Text(interest),
                    selected: _profile!.interests.contains(interest),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _profile!.interests.add(interest);
                        } else {
                          _profile!.interests.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate() && _profile != null) {
      _formKey.currentState!.save();
      context.read<UserProvider>().updateProfile(_profile!);
      Navigator.pop(context);
    }
  }
}