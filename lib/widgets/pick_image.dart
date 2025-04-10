import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PickImage extends StatefulWidget {
  final Function(File) onImagePicked; // Callback to notify parent widget

  const PickImage({required this.onImagePicked, super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    // Show a dialog to let the user choose between gallery and camera
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (source == null) return; // User canceled the dialog

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Notify the parent widget about the selected image
      widget.onImagePicked(_selectedImage!);
    }
  }

  void _previewImage(BuildContext context) {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected to preview.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(_selectedImage!),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _pickImage,
          style: style,
          child: const Text('Pick Image'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => _previewImage(context),
          style: style,
          child: const Text('Preview'),
        ),
      ],
    );
  }
}
