import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _name, _bio, _phone, _email, _city;

  @override
  void initState() {
    super.initState();
    final s = context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
    _name = TextEditingController(text: s.name);
    _bio = TextEditingController(text: s.bio);
    _phone = TextEditingController(text: s.phone);
    _email = TextEditingController(text: s.email);
    _city = TextEditingController(text: s.city);
  }

  @override
  void dispose() {
    for (final c in [_name, _bio, _phone, _email, _city]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _field(String label, TextEditingController c, {int lines = 1}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: headStyle(12)),
          const SizedBox(height: 6),
          TextField(
            controller: c,
            maxLines: lines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.taupe,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      appBar: pawBar('Personal Information'),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Center(child: CircleAvatar(radius: 44, backgroundColor: AppColors.taupe, child: Icon(Icons.person, size: 48, color: Colors.white))),
        const SizedBox(height: 18),
        _field('Full Name', _name),
        _field('Biography', _bio, lines: 3),
        _field('Phone Number', _phone),
        _field('Email', _email),
        _field('City and Area', _city),
        PillButton('Save changes', color: AppColors.gold, textColor: AppColors.charcoal, onPressed: () {
          s.updateProfile(name: _name.text.trim(), bio: _bio.text.trim(), phone: _phone.text.trim(), email: _email.text.trim(), city: _city.text.trim());
          toast(context, 'Profile saved');
        }),
        const SizedBox(height: 24),
        Text('My activity', style: headStyle(16)),
        const SizedBox(height: 8),
        if (s.bookings.isEmpty && s.appointments.isEmpty && s.adoptionRequests.isEmpty)
          const Text('Nothing yet. Book a sitter, a clinic slot or adopt a cat!'),
        for (final b in s.bookings)
          ListTile(
            leading: const Icon(Icons.pets, color: AppColors.brown),
            title: Text('Sitter: ${b.sitter.name}'),
            subtitle: Text('${fmtDate(b.date)}  |  ${b.services.length} service(s)  |  \$${b.total}'),
          ),
        for (final a in s.appointments)
          ListTile(
            leading: const Icon(Icons.local_hospital, color: AppColors.brown),
            title: Text('Clinic: ${a.doctor.name}'),
            subtitle: Text('${fmtDate(a.date)}  |  ${a.time}'),
          ),
        for (final r in s.adoptionRequests)
          ListTile(
            leading: const Icon(Icons.favorite, color: AppColors.brown),
            title: Text('Adoption request: ${r.cat.name}'),
            subtitle: Text(fmtDate(r.date)),
          ),
        ListTile(leading: const Icon(Icons.favorite_border, color: AppColors.brown), title: Text('${s.favorites.length} favourite cat(s)')),
        const SizedBox(height: 16),
        PillButton('Log out', color: Colors.white, textColor: AppColors.charcoal, borderColor: AppColors.charcoal, onPressed: () {
          s.logout();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const WelcomeScreen()), (r) => false);
        }),
      ]),
    );
  }
}
