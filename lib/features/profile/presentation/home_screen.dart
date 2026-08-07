import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../auth/data/auth_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState {
  File? _selectedImage;

  Future _pickImage() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      if (!mounted) return;
      _showSettingsDialog();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kamera icazəsi verilmədi.'),
        ),
      );
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('İcazə tələb olunur'),
        content: const Text(
          'Kamera icazəsi tətbiq tərəfindən bloklanıb. Ayarlara keçib icazə verin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ləğv et'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Ayarlara keç'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Səhifə'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Xoş gəldiniz, ${user?.email ?? 'İstifadəçi'}'),
              const SizedBox(height: 20),
              _selectedImage != null
                  ? CircleAvatar(
                radius: 60,
                backgroundImage: FileImage(_selectedImage!),
              )
                  : const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Profil Şəkli Çək'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}