import 'package:go_router/go_router.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/debug_page.dart';
import 'pages/add.dart';
import 'pages/delete.dart';
import 'pages/contacts_list.dart';
import 'pages/edit_form.dart';
import 'pages/search_page.dart';
import '../models/contact.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/debug',
        builder: (context, state) => const DebugPage(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const AddContactPage(),
      ),
      // Route corrigée pour l'édition
      GoRoute(
        path: '/edit_form',
        builder: (context, state) {
          // Vérification robuste de state.extra
          if (state.extra == null) {
            // Rediriger vers la liste des contacts si extra est null
            return const ContactsListPage();
          }
          
          try {
            final contact = state.extra as Contact;
            return EditFormPage(contact: contact);
          } catch (e) {
            // En cas d'erreur, retourner à la liste
            return const ContactsListPage();
          }
        },
      ),
      GoRoute(
        path: '/delete',
        builder: (context, state) => const DeleteContactPage(),
      ),
      GoRoute(
        path: '/contacts',
        builder: (context, state) => const ContactsListPage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),
    ],
  );
}






