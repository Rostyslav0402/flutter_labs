import 'dart:convert'; // Для конвертації списку в JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _labCountController = TextEditingController();
  final List<Map<String, dynamic>> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSubjects();
  }

  // Завантажуємо електронну пошту з SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String email = prefs.getString('email') ?? '';
    _emailController.text = email;
  }

  // Зберігаємо електронну пошту в SharedPreferences
  Future<void> _saveEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text);
    if (!mounted) return;
    Navigator.pop(context);
  }

  // Завантажуємо предмети з SharedPreferences
  Future<void> _loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? subjectsJson = prefs.getString('subjects');
    if (subjectsJson != null) {
      // ignore: lines_longer_than_80_chars
      final List<dynamic> subjectsList = json.decode(subjectsJson) as List<dynamic>;
      setState(() {
        _subjects.addAll(subjectsList.map((e) => e as Map<String, dynamic>));
      });
    }
  }

  // Зберігаємо предмети в SharedPreferences
  Future<void> _saveSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String subjectsJson = json.encode(_subjects);
    await prefs.setString('subjects', subjectsJson);
  }

  // Додаємо предмет до списку
  void _addSubject() {
    final String subject = _subjectController.text;
    final String labCountText = _labCountController.text;

    if (subject.isNotEmpty && labCountText.isNotEmpty) {
      final int? labCount = int.tryParse(labCountText);
      if (labCount != null && labCount >= 0) {
        setState(() {
          _subjects.add({'subject': subject, 'labs': labCount});
        });
        _saveSubjects();
        _subjectController.clear();
        _labCountController.clear();
      } else {
        _showError('Please enter a valid number for lab works.');
      }
    } else {
      _showError('Please fill in all fields.');
    }
  }

  // Показуємо діалогове вікно з помилкою
  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Info:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Nickname/Name'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveEmail,
                child: const Text('Save Info'),
              ),
              const Divider(height: 32),
              const Text(
                'Add Subject and Lab Works:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _labCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Number of Labs'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addSubject,
                child: const Text('Add Subject'),
              ),
              const Divider(height: 32),
              const Text(
                'Subjects:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (_subjects.isEmpty) 
                const Text('No subjects added yet.') 
              else ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _subjects.length,
                      itemBuilder: (context, index) {
                        final subject = _subjects[index];
                        return ListTile(
                          title: Text(subject['subject'] as String),
                          // ignore: lines_longer_than_80_chars
                          subtitle: Text('Labs: ${(subject['labs'] as int).toString()}'),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
