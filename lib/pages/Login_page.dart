import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  final DatabaseHelper _db = DatabaseHelper();

  // Couleurs sophistiquées pour un design élégant
  final Color primaryColor = Color(0xFF6366F1); // Indigo élégant
  final Color secondaryColor = Color(0xFFEC4899); // Rose pour les accents
  final Color backgroundColor = Color(0xFFFAFBFF);
  final Color surfaceColor = Colors.white;
  final Color textPrimary = Color(0xFF1F2937);
  final Color textSecondary = Color(0xFF6B7280);

  // Dégradés premium
  final LinearGradient _primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient _secondaryGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFF0F4FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final user = await _db.loginUser(_emailController.text, _passwordController.text);
    setState(() => _loading = false);

    if (user != null) {
      _showElegantSnackBar(
        "Connexion réussie ! Bienvenue ${user.firstName}",
        Icons.check_circle_outline_rounded,
        Colors.green.shade500,
      );
      await Future.delayed(Duration(milliseconds: 800));
      context.go('/home');
    } else {
      _showElegantSnackBar(
        "Email ou mot de passe incorrect",
        Icons.error_outline_rounded,
        Colors.orange.shade500,
      );
    }
  }

  void _showElegantSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                // Header élégant
                _buildHeader(),
                SizedBox(height: 48),
                
                // Illustration sophistiquée
                _buildIllustration(),
                SizedBox(height: 32),
                
                // Titres
                _buildTitles(),
                SizedBox(height: 40),
                
                // Formulaire élégant
                Expanded(
                  child: _buildForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: _primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, size: 18),
            onPressed: () => context.go('/'),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        Spacer(),
        Text(
          "Connexion",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        Spacer(),
        SizedBox(width: 48),
      ],
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 120,
      height: 120,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 25,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.fingerprint_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTitles() {
    return Column(
      children: [
        Text(
          "Content de vous revoir",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            height: 1.1,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          "Connectez-vous pour accéder à votre espace personnel",
          style: TextStyle(
            fontSize: 16,
            color: textSecondary,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: _secondaryGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email field
            _buildTextField(
              controller: _emailController,
              label: "Adresse email",
              prefixIcon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Format d\'email invalide';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            
            // Password field
            _buildPasswordField(
              controller: _passwordController,
              label: "Mot de passe",
              obscureText: _obscurePassword,
              onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            
            // Mot de passe oublié
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implémenter mot de passe oublié
                },
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                child: Text(
                  "Mot de passe oublié ?",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Spacer(),
            
            // Bouton de connexion
            _buildLoginButton(),
            SizedBox(height: 16),
            
            // Bouton d'inscription
            _buildRegisterButton(),
            SizedBox(height: 16),
            
            // Bouton Debug stylisé
            _buildDebugButton(),
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
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 16, left: 20),
          child: Icon(prefixIcon, color: primaryColor.withOpacity(0.8)),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24),
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 16, left: 20),
          child: Icon(Icons.lock_rounded, color: primaryColor.withOpacity(0.8)),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24),
        suffixIcon: Container(
          margin: EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              color: textSecondary.withOpacity(0.6),
              size: 20,
            ),
            onPressed: onToggle,
          ),
        ),
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _loading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child: _loading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Se connecter",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () => context.go('/register'),
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor.withOpacity(0.3), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: surfaceColor.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_rounded, size: 20),
            SizedBox(width: 10),
            Text(
              "Créer un compte",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugButton() {
    return TextButton(
      onPressed: () => context.go('/debug'),
      style: TextButton.styleFrom(
        foregroundColor: textSecondary.withOpacity(0.6),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.terminal_rounded, size: 14),
          SizedBox(width: 6),
          Text(
            "Mode Développeur",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}








