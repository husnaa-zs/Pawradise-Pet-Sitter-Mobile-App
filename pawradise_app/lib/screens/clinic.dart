import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({super.key});

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  final _days = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
  int _day = 0;
  int? _doctor;
  String? _slot;

  void _confirm() {
    AppScope.of(context).addAppointment(Appointment(doctor: doctors[_doctor!], date: _days[_day], time: _slot!));
    toast(context, 'Appointment booked: ${doctors[_doctor!].name}, ${fmtDate(_days[_day])} $_slot');
    setState(() {
      _doctor = null;
      _slot = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pawBar('Cats Clinic'),
      body: Column(children: [
        Expanded(
          child: ListView(padding: const EdgeInsets.all(20), children: [
            Center(child: Text('${monShort(_days[_day])} ${_days[_day].year}', style: headStyle(15))),
            const SizedBox(height: 12),
            Row(children: [
              for (var i = 0; i < _days.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _day = i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: i == _day ? AppColors.gold : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: i == _day ? AppColors.gold : AppColors.line),
                      ),
                      child: Column(children: [
                        Text(dowShort(_days[i]), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        Text('${_days[i].day}', style: headStyle(15)),
                      ]),
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 20),
            Text('Available doctors', style: headStyle(15)),
            const SizedBox(height: 10),
            for (var d = 0; d < doctors.length; d++)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const CircleAvatar(backgroundColor: Color(0xFFF3C9A5), child: Icon(Icons.person, color: AppColors.taupe)),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(doctors[d].name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text('Consultant  ★ ${doctors[d].rating} (${doctors[d].reviews} reviews)', style: const TextStyle(fontSize: 11, color: AppColors.brown)),
                    ]),
                  ]),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final t in doctors[d].slots)
                      Builder(builder: (context) {
                        final taken = doctors[d].booked.contains(t);
                        final selected = _doctor == d && _slot == t;
                        return GestureDetector(
                          onTap: taken ? null : () => setState(() {
                                _doctor = d;
                                _slot = t;
                              }),
                          child: Container(
                            width: 70,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.gold : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: taken ? AppColors.line : AppColors.taupe, width: 1.5),
                            ),
                            child: Text(t,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w700, color: taken ? Colors.black26 : AppColors.charcoal,
                                    decoration: taken ? TextDecoration.lineThrough : null)),
                          ),
                        );
                      }),
                  ]),
                ]),
              ),
          ]),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: PillButton('Confirm Appointment', onPressed: _slot == null ? null : _confirm),
          ),
        ),
      ]),
    );
  }
}
