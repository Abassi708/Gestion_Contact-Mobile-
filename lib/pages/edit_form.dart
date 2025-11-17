import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../database/database_helper.dart';
import '../models/contact.dart';

class EditFormPage extends StatefulWidget {
  final Contact contact;
  const EditFormPage({super.key, required this.contact});

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
  final Color primaryColor = Colors.green.shade700;
  final Color backgroundColor = Colors.grey.shade50;

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs avec les données du contact
    _firstNameController.text = widget.contact.firstName;
    _lastNameController.text = widget.contact.lastName;
    _emailController.text = widget.contact.email;
    _phoneController.text = widget.contact.phone;
    _companyController.text = widget.contact.company;
  }

  void _updateContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final updatedContact = Contact(
        id: widget.contact.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        company: _companyController.text.trim(),
        createdAt: widget.contact.createdAt,
      );

      await _db.updateContact(updatedContact);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text("Contact modifié avec succès !"),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      
      if (mounted) {
        context.go('/contacts');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Text("Erreur: ${e.toString()}"),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header élégant avec dégradé vert
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, Colors.green.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                          onPressed: () => context.go('/contacts'),
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Modifier Contact",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit_note_rounded,
                            size: 28,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Modifier le contact",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Mettez à jour les informations",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Formulaire
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Carte du formulaire
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(0, 6),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.shade100,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Prénom et Nom
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _firstNameController,
                                    label: "Prénom",
                                    prefixIcon: Icons.person_outline_rounded,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Le prénom est requis';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _lastNameController,
                                    label: "Nom",
                                    prefixIcon: Icons.person_outline_rounded,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Le nom est requis';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Email
                            _buildTextField(
                              controller: _emailController,
                              label: "Adresse email",
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'L\'email est requis';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Email invalide';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Téléphone
                            _buildTextField(
                              controller: _phoneController,
                              label: "Numéro de téléphone",
                              prefixIcon: Icons.phone_rounded,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Le téléphone est requis';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Entreprise
                            _buildTextField(
                              controller: _companyController,
                              label: "Entreprise (optionnel)",
                              prefixIcon: Icons.business_rounded,
                            ),

                            const SizedBox(height: 32),

                            // Boutons d'action
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.shade300,
                                          Colors.grey.shade200,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () => context.go('/contacts'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.grey.shade800,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: const Text(
                                        "Annuler",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor,
                                          Colors.green.shade600,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _loading ? null : _updateContact,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: _loading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.save_rounded, size: 20),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Enregistrer",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.only(right: 12, left: 16),
                child: Icon(
                  prefixIcon, 
                  color: primaryColor.withOpacity(0.8),
                  size: 22,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: primaryColor.withOpacity(0.6),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}