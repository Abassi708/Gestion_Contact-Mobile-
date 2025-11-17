import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteContactPage extends StatefulWidget {
  const DeleteContactPage({super.key});

  @override
  State<DeleteContactPage> createState() => _DeleteContactPageState();
}

class _DeleteContactPageState extends State<DeleteContactPage> {
  final Color primaryColor = Colors.red.shade700;
  final Color backgroundColor = Colors.grey.shade50;

  // Données simulées
  final List<Map<String, String>> _contacts = [
    {'name': 'Kawther Ben Ahmed', 'email': 'kawther@gmail.com', 'phone': '+216 12 345 678'},
    {'name': 'Nourhene Mansour', 'email': 'nourhene@gmail.com', 'phone': '+216 98 765 432'},
    {'name': 'Aya Zakiat', 'email': 'aya@gmail.com', 'phone': '+216 55 123 456'},
  ];

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Confirmer la suppression",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red.shade800,
              ),
            ),
          ],
        ),
        content: Text(
          "Êtes-vous sûr de vouloir supprimer le contact ${_contacts[index]['name']} ? Cette action est irréversible.",
          style: TextStyle(color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Annuler",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteContact(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  void _deleteContact(int index) {
    // TODO: Implémenter la logique de suppression
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.delete_forever_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text("Contact supprimé avec succès"),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, Colors.red.shade600],
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
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
                          onPressed: () => context.go('/home'),
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Supprimer Contact",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 24,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Supprimer un contact",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Sélectionnez le contact à supprimer",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
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

            // Liste des contacts
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contacts Disponibles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Appuyez sur un contact pour le supprimer",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _contacts.length,
                        itemBuilder: (context, index) {
                          final contact = _contacts[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.red.shade100,
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor, Colors.red.shade500],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                contact['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey.shade800,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contact['email']!),
                                  Text(
                                    contact['phone']!,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.delete_forever_rounded,
                                  size: 18,
                                  color: primaryColor,
                                ),
                              ),
                              onTap: () => _showDeleteDialog(index),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
