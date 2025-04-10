import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/models/vet_owner.dart';
import 'package:vet/providers/vet_owner_provider.dart';
import 'package:vet/services/auth/register_service.dart';
import 'package:vet/services/auth/service_provider.dart';
import 'package:vet/services/api/image_api_helper.dart';
import 'package:vet/services/api/update_info_service.dart';
import 'package:vet/utils/validators.dart';
import 'package:vet/widgets/custom_input_field.dart';
import 'package:vet/widgets/pick_image.dart';
import 'dart:io';

class Register extends StatefulWidget {
  const Register({super.key, this.vetOwner});
  final VetOwner? vetOwner;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.vetOwner != null) {
      _firstNameController.text = widget.vetOwner!.firstName;
      _lastNameController.text = widget.vetOwner!.lastName;
      _emailController.text = widget.vetOwner!.email;
      _addressController.text = widget.vetOwner!.address ?? '';
      _phoneNumberController.text = widget.vetOwner!.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    try {
      final imageUrl = await ImageApiHelper.uploadImage(_selectedImage!, "pfp");
      return imageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    String? profilePicUrl;
    if (widget.vetOwner == null && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a profile picture')),
      );
      return;
    }
    if (_selectedImage != null) {
      profilePicUrl = await _uploadImage();
      if (profilePicUrl == null) return;
    }

    if (widget.vetOwner != null) {
      final updateProfileRequest = UpdateProfileRequest(
        id: widget.vetOwner!.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        address: _addressController.text,
        profilePicUrl: profilePicUrl ?? widget.vetOwner!.profilePicUrl,
        phoneNumber: _phoneNumberController.text,
      );
      final res = await ServiceProvider.updateInfoService
          .updateProfile(updateProfileRequest);

      debugPrint(res.message);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
      );

      if (res.status) {
        Provider.of<VetOwnerProvider>(context, listen: false).setVetOwner(
            VetOwner(
                id: updateProfileRequest.id,
                firstName: updateProfileRequest.firstName,
                lastName: updateProfileRequest.lastName,
                email: updateProfileRequest.email,
                address: updateProfileRequest.address,
                profilePicUrl: updateProfileRequest.profilePicUrl,
                phoneNumber: updateProfileRequest.phoneNumber));
        Navigator.of(context).pop();
      }
    } else {
      final res = await ServiceProvider.registerService.register(
        RegisterRequest(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          address: _addressController.text,
          profilePicUrl: profilePicUrl,
          phoneNumber: _phoneNumberController.text,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
      );

      if (res.status) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vetOwner == null ? 'Register' : 'Update Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      labelText: 'First Name',
                      icon: Icons.person,
                      controller: _firstNameController,
                      validator: Validators.emptyText,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomInputField(
                      labelText: 'Last Name',
                      icon: Icons.person,
                      controller: _lastNameController,
                      validator: Validators.emptyText,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              CustomInputField(
                labelText: 'Email',
                icon: Icons.email,
                controller: _emailController,
                validator: Validators.emailValidator,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              if (widget.vetOwner == null)
                CustomInputField(
                  labelText: 'Password',
                  icon: Icons.lock,
                  controller: _passwordController,
                  validator: Validators.passwordValidator,
                  keyboardType: TextInputType.visiblePassword,
                ),
              SizedBox(height: 16),
              CustomInputField(
                labelText: 'Address',
                icon: Icons.home,
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
              ),
              SizedBox(height: 16),
              CustomInputField(
                labelText: 'Phone Number',
                icon: Icons.phone,
                controller: _phoneNumberController,
                validator: Validators.phoneNumberValidator,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              PickImage(
                onImagePicked: (File image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  fixedSize: Size(size.width, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(widget.vetOwner == null ? 'Register' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
