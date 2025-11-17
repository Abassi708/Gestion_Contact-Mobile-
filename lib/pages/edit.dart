import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../database/database_helper.dart';
import '../models/contact.dart';


class EditFormPage extends StatefulWidget {
  final Map<String, dynamic> contactData;
  const EditFormPage({super.key, required this.contactData});

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final DatabaseHelper _db = DatabaseHelper();
  
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs
    _firstNameController.text = widget.contactData['firstName'] ?? '';
    _lastNameController.text = widget.contactData['lastName'] ?? '';
    _emailController.text = widget.contactData['email'] ?? '';
    _phoneController.text = widget.contactData['phone'] ?? '';
    _companyController.text = widget.contactData['company'] ?? '';
  }

  void _updateContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final updatedContact = Contact(
        id: widget.contactData['id'],
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        company: _companyController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _db.updateContact(updatedContact);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Contact modifié avec succès !"),
          backgroundColor: Colors.green,
        ),
      );
      
      context.go('/contacts');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le Contact"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: "Prénom"),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Téléphone"),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  return null;
                },
              ),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: "Entreprise"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _updateContact,
                child: _loading 
                    ? const CircularProgressIndicator()
                    : const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}