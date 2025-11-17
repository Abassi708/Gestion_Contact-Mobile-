
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue.shade900;
    final Color secondaryColor = Colors.blue.shade700;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // AppBar élégant avec dégradé
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Gestion des Contacts",
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
                    colors: [primaryColor, secondaryColor],
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
                  child: const Icon(Icons.logout, size: 20, color: Colors.white),
                ),
                tooltip: "Déconnexion",
                onPressed: () => context.go('/login'),
              ),
            ],
          ),

          // Contenu principal
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Carte de bienvenue
                  _WelcomeCard(),
                  SizedBox(height: 24),

                  // Indicateurs de statistiques
                  _StatsSection(),
                  SizedBox(height: 24),

                  // Section actions principales
                  _QuickActionsSection(),
                  SizedBox(height: 24),

                  // Section contacts récents
                  _RecentContactsSection(),
                ],
              ),
            ),
          ),
        ],
      ),

      // Floating Action Button compact
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: () => context.go('/add'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }
}

// Carte de bienvenue
class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blue.shade800;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 12,
            offset: const Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_alt_rounded,
              size: 32,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Espace Professionnel",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            "Gérez vos contacts avec efficacité",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Section statistiques
class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Contacts", "12", Icons.people_outline),
          _buildStatItem("Groupes", "8", Icons.group_outlined),
          _buildStatItem("Favoris", "24", Icons.star_outline),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: Colors.blue.shade700),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.blueGrey,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Section actions rapides
class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Actions Rapides",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: 16),
        _ActionButton(
          label: "Ajouter un Contact",
          icon: Icons.add_circle_outline,
          color: Colors.blue,
          route: '/add',
        ),
        SizedBox(height: 12),
        _ActionButton(
          label: "Modifier un Contact",
          icon: Icons.edit_note_rounded,
          color: Colors.green,
          route: '/edit',
        ),
        SizedBox(height: 12),
        _ActionButton(
          label: "Supprimer un Contact",
          icon: Icons.delete_outline_rounded,
          color: Colors.red,
          route: '/delete',
        ),
        SizedBox(height: 12),
        _ActionButton(
          label: "Rechercher un Contact",
          icon: Icons.search_rounded,
          color: Colors.teal,
          route: '/search',
        ),
      ],
    );
  }
}

// Bouton d'action
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final MaterialColor color;
  final String route;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      child: ElevatedButton(
        onPressed: () => context.go(route),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color.shade700,
          elevation: 1,
          shadowColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.shade700.withOpacity(0.2), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color.shade700),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.shade700.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: color.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section contacts récents
class _RecentContactsSection extends StatelessWidget {
  const _RecentContactsSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contacts Récents",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: 16),
        _RecentContactItem(name: "Kawther", email: "kawther@gmail.com"),
        _RecentContactItem(name: "Nourhene", email: "nourhene@gmail.com"),
        _RecentContactItem(name: "Aya Zakiat", email: "aya@gmail.com"),
      ],
    );
  }
}

// Item contact récent
class _RecentContactItem extends StatelessWidget {
  final String name;
  final String email;

  const _RecentContactItem({
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: Colors.blue.shade700,
            size: 18,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
        subtitle: Text(
          email,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
            color: Colors.grey.shade600,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () {},
      ),
    );
  }
}




