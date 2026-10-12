import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'shell.dart';

void _enterApp(BuildContext context) => Navigator.of(context)
    .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const Shell()), (route) => false);

/// Step 1: choose a role (cat owner or sitter).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _choose(BuildContext context, Role role) {
    AppScope.of(context).setRole(role);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          flex: 5,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('FUR REAL CONNECTIONS,', style: headStyle(14, AppColors.brown)),
                Text('FUR REAL CARE.', style: headStyle(26)),
                Expanded(
                  child: Center(
                    child: Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.end, spacing: 2, runSpacing: 2, children: [
                      PixelCat(breed: CatBreed.tabby, pose: 'stand', width: 120),
                      PixelCat(breed: CatBreed.siamese, pose: 'sit', width: 100),
                      PixelCat(breed: CatBreed.british, pose: 'loaf', width: 110),
                      PixelCat(breed: CatBreed.calico, pose: 'sleep', width: 110),
                      PixelCat(breed: CatBreed.tuxedo, pose: 'lie', width: 120),
                      PixelCat(breed: CatBreed.persian, pose: 'sit', width: 100),
                      PixelCat(breed: CatBreed.black, pose: 'stand', width: 110),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
            decoration: const BoxDecoration(color: AppColors.taupe, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: Column(children: [
              Text('FIND SITTERS OR\nBECOME ONE', textAlign: TextAlign.center, style: headStyle(26, Colors.white)),
              const SizedBox(height: 10),
              const Text('Offer cat care or connect with trusted sitters nearby.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFD8D0C0))),
              const Spacer(),
              PillButton('Continue as Sitter', color: const Color(0xFF6B5A44), borderColor: Colors.white24, onPressed: () => _choose(context, Role.sitter)),
              const SizedBox(height: 12),
              PillButton('Continue as Owner', color: Colors.white, textColor: AppColors.charcoal, onPressed: () => _choose(context, Role.owner)),
            ]),
          ),
        ),
      ]),
    );
  }
}

/// Login: pixel-art background (assets/login_bg_pixel.png) with pixel-style inputs and buttons.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _login() {
    if (_email.text.trim().isEmpty || _pass.text.isEmpty) {
      toast(context, 'Please enter your email/phone and password');
      return;
    }
    AppScope.of(context).login(_email.text.trim());
    _enterApp(context);
  }

  TextStyle _px(double size, [Color color = AppColors.charcoal]) => GoogleFonts.pressStart2p(fontSize: size, color: color);

  Widget _pixelField(TextEditingController c, String hint, IconData icon, {bool obscure = false}) => Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(190),
          border: Border.all(color: AppColors.charcoal, width: 3),
          boxShadow: const [BoxShadow(color: AppColors.charcoal, offset: Offset(4, 4))],
        ),
        child: TextField(
          controller: c,
          obscureText: obscure,
          style: _px(10),
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hint,
            hintStyle: _px(9, const Color(0xFF8A867A)),
            prefixIcon: Icon(icon, size: 18, color: AppColors.charcoal),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      );

  Widget _pixelButton(String label, VoidCallback onTap, {required bool dark}) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: dark ? AppColors.charcoal : Colors.white,
              border: Border.all(color: AppColors.charcoal, width: 3),
              boxShadow: const [BoxShadow(color: Color(0xFF55524B), offset: Offset(4, 4))],
            ),
            child: Text(label, style: _px(11, dark ? Colors.white : AppColors.charcoal)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF1C1C1C),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: LayoutBuilder(builder: (context, c) {
            final h = c.maxHeight;
            return ClipRect(
              child: Stack(children: [
                Positioned.fill(
                  child: Image.asset('assets/login_bg_pixel.png', fit: BoxFit.cover, alignment: Alignment.bottomCenter, filterQuality: FilterQuality.none),
                ),
                Positioned.fill(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(36, h * .08, 36, 24),
                      child: Column(children: [
                        Text('PAWRADISE', style: _px(24).copyWith(shadows: const [Shadow(color: Colors.white70, offset: Offset(3, 3))])),
                        const SizedBox(height: 10),
                        Text('A CAT APP', style: _px(10, const Color(0xFF3B3A36)).copyWith(letterSpacing: 2)),
                        const SizedBox(height: 34),
                        _pixelField(_email, 'Email or Phone', Icons.person),
                        const SizedBox(height: 18),
                        _pixelField(_pass, 'Password', Icons.lock, obscure: true),
                        const SizedBox(height: 16),
                        Text('Forgot Password?', style: _px(8, const Color(0xFF3B3A36))),
                        const SizedBox(height: 18),
                        _pixelButton('LOGIN', _login, dark: true),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('or', style: _px(9, const Color(0xFF3B3A36)))),
                        _pixelButton('CREATE AN ACCOUNT', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen())), dark: false),
                      ]),
                    ),
                  ),
                ),
                Positioned(top: 0, left: 0, child: SafeArea(child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()))),
              ]),
            );
          }),
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  void _submit() {
    if (!_form.currentState!.validate()) return;
    AppScope.of(context).login(_email.text.trim(), displayName: _name.text.trim());
    _enterApp(context);
  }

  @override
  Widget build(BuildContext context) {
    final role = AppScope.of(context).role;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const CircleAvatar(radius: 30, backgroundColor: AppColors.gold, child: Icon(Icons.pets, color: Colors.white, size: 30)),
            const SizedBox(height: 20),
            Text("Hi, Let's Get\nStarted!", style: headStyle(28)),
            const SizedBox(height: 6),
            Text('Signing up as ${role == Role.owner ? 'a cat owner' : 'a sitter'}', style: const TextStyle(color: AppColors.brown)),
            const SizedBox(height: 22),
            PillField(_name, 'Name', validator: _required),
            const SizedBox(height: 14),
            PillField(_email, 'Email', validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null),
            const SizedBox(height: 14),
            PillField(_pass, 'Password', obscure: true, validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null),
            const SizedBox(height: 24),
            PillButton('Sign up', onPressed: _submit),
            const SizedBox(height: 20),
            const Center(child: CatFace(size: 110, breed: CatBreed.calico)),
          ]),
        ),
      ),
    );
  }
}
