import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../database/database_helper.dart';
import '../models/contact.dart';


class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Contact> _contacts = [];
  bool _loading = true;
  final Color primaryColor = Colors.blue.shade800;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() async {
    setState(() => _loading = true);
    final contacts = await _db.getContacts();
    setState(() {
      _contacts = contacts;
      _loading = false;
    });
  }

  void _deleteContact(int id, String name) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade700,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Confirmer la suppression",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.red.shade800,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          "Êtes-vous sûr de vouloir supprimer le contact \"$name\" ? Cette action est irréversible.",
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
            ),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performDelete(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  void _performDelete(int id) async {
    await _db.deleteContact(id);
    _loadContacts();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text("Contact supprimé avec succès"),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _editContact(Contact contact) {
    context.go('/edit_form', extra: contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // AppBar élégant
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Mes Contacts",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.contacts_rounded,
                      size: 50,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 20, color: Colors.white),
                ),
                tooltip: "Ajouter",
                onPressed: () => context.go('/add'),
              ),
            ],
          ),

          // Contenu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carte statistiques
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100,
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(_contacts.length.toString(), "Contacts", Icons.people_alt_rounded),
                        _buildStatItem((_contacts.length * 2).toString(), "Interactions", Icons.trending_up_rounded),
                        _buildStatItem("${(_contacts.length * 15).toString()}%", "Engagement", Icons.insights_rounded),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Titre section
                  Row(
                    children: [
                      Text(
                        "Liste des Contacts",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey.shade800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${_contacts.length} contact${_contacts.length > 1 ? 's' : ''}",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Liste des contacts
          _loading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : _contacts.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.people_outline_rounded,
                                size: 40,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Aucun contact",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Commencez par ajouter votre premier contact",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => context.go('/add'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Ajouter un contact"),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final contact = _contacts[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.grey.shade50,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade100,
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor,
                                          Colors.blue.shade600,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        contact.firstName[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    contact.fullName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueGrey.shade800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        contact.email,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        contact.phone,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      if (contact.company.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          contact.company,
                                          style: TextStyle(
                                            color: Colors.blue.shade600,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Bouton Modifier
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit_rounded,
                                            size: 18,
                                            color: Colors.green.shade700,
                                          ),
                                          onPressed: () => _editContact(contact),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      // Bouton Supprimer
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete_outline_rounded,
                                            size: 18,
                                            color: Colors.red.shade700,
                                          ),
                                          onPressed: () => _deleteContact(contact.id!, contact.fullName),
                                        ),
                                      ),
                                    ],
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: _contacts.length,
                      ),
                    ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: () => context.go('/add'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.blueGrey.shade800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}