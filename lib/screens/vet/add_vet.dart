import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/models/vet.dart';
import 'package:vet/providers/vet_provider.dart';
import 'package:vet/routes.dart';
import 'package:vet/widgets/custom_input_field.dart';
import 'package:vet/utils/validators.dart';
import 'package:vet/widgets/pick_image.dart';
import 'package:vet/services/api/image_api_helper.dart';
import 'package:vet/widgets/future_button.dart';
import 'dart:io';

class AddVet extends StatefulWidget {
  const AddVet({this.vet, super.key});
  final Vet? vet;

  @override
  State<AddVet> createState() => _AddVetState();
}

class _AddVetState extends State<AddVet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _speciesController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.vet != null) {
      _nameController.text = widget.vet!.name;
      _genderController.text = widget.vet!.gender;
      _speciesController.text = widget.vet!.species;
      _dateOfBirthController.text =
          widget.vet!.dateOfBirth?.toIso8601String().split('T').first ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _speciesController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    try {
      final imageUrl = await ImageApiHelper.uploadImage(_selectedImage!, "vet");
      return imageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null && widget.vet == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }
      String? imageUrl;
      imageUrl = await _uploadImage();
      if (widget.vet == null && imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      final newVet = Vet(
        id: widget.vet?.id ?? 0,
        name: _nameController.text,
        gender: _genderController.text,
        species: _speciesController.text,
        dateOfBirth: DateTime.tryParse(_dateOfBirthController.text),
        picUrl: imageUrl,
        ownerId: widget.vet?.ownerId,
      );

      if (widget.vet == null) {
        Provider.of<VetProvider>(context, listen: false).addVet(newVet);
      } else {
        Provider.of<VetProvider>(context, listen: false).updateVet(newVet);
      }
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, AppRoutes.vetScreen, arguments: newVet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vet == null ? 'Add Vet' : 'Update Vet'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputField(
                labelText: 'Name',
                icon: Icons.person,
                controller: _nameController,
                validator: Validators.emptyText,
              ),
              const SizedBox(height: 10),
              CustomInputField(
                labelText: 'Gender',
                icon: Icons.person_outline,
                controller: _genderController,
                validator: Validators.emptyText,
              ),
              const SizedBox(height: 10),
              CustomInputField(
                labelText: 'Species',
                icon: Icons.pets,
                controller: _speciesController,
                validator: Validators.emptyText,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateOfBirthController.text =
                          pickedDate.toIso8601String().split('T').first;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: CustomInputField(
                    labelText: 'Date of Birth',
                    icon: Icons.calendar_today,
                    controller: _dateOfBirthController,
                    validator: Validators.validateDate,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PickImage(
                onImagePicked: (File image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
              const SizedBox(height: 20),
              FutureButton(
                onTap: _submitForm,
                title: widget.vet == null ? 'Add Vet' : 'Update Vet',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
