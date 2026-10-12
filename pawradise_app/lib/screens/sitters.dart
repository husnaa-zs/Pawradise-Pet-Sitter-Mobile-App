import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

class SittersScreen extends StatefulWidget {
  const SittersScreen({super.key});

  @override
  State<SittersScreen> createState() => _SittersScreenState();
}

class _SittersScreenState extends State<SittersScreen> {
  String _query = '';
  String _filter = 'All';

  List<Sitter> get _results => sitters.where((s) {
        final matches = s.name.toLowerCase().contains(_query.toLowerCase());
        final ok = switch (_filter) {
          'Nearby' => s.nearby,
          'Top rated' => s.rating >= 4.8,
          'Available' => s.available,
          _ => true,
        };
        return matches && ok;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      appBar: pawBar('Pet Sitter'),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Search sitters',
              suffixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.line)),
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20), children: [
            for (final f in ['All', 'Nearby', 'Top rated', 'Available'])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f),
                  selected: _filter == f,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _filter = f),
                  selectedColor: AppColors.taupe,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, color: _filter == f ? Colors.white : AppColors.taupe),
                  shape: const StadiumBorder(side: BorderSide(color: AppColors.taupe)),
                ),
              ),
          ]),
        ),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('No sitters match your search'))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _SitterCard(sitter: results[i]),
                ),
        ),
      ]),
    );
  }
}

class _SitterCard extends StatelessWidget {
  final Sitter sitter;
  const _SitterCard({required this.sitter});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.taupe, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const LandscapePhoto(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(sitter.name, style: headStyle(15, Colors.white)),
              Text(sitter.area, style: const TextStyle(color: Color(0xFFD8D0C0), fontSize: 12)),
              const SizedBox(height: 6),
              Text('★ ${sitter.rating} (${sitter.reviews})', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 12)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookSitterScreen(sitter: sitter))),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.charcoal, elevation: 0, shape: const StadiumBorder()),
                child: const Text('Book now', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ]),
          ),
        ]),
      );
}

class BookSitterScreen extends StatefulWidget {
  final Sitter sitter;
  const BookSitterScreen({super.key, required this.sitter});

  @override
  State<BookSitterScreen> createState() => _BookSitterScreenState();
}

class _BookSitterScreenState extends State<BookSitterScreen> {
  final _dates = List.generate(6, (i) => DateTime.now().add(Duration(days: i)));
  int _day = 0;
  int _tab = 0;
  final Set<int> _picked = {};

  int get _total => _picked.fold(0, (sum, i) => sum + kServices[i].price);

  void _book() {
    AppScope.of(context).addBooking(Booking(
      sitter: widget.sitter,
      date: _dates[_day],
      services: [for (final i in _picked) kServices[i]],
    ));
    toast(context, 'Booked ${widget.sitter.name} on ${fmtDate(_dates[_day])}');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final sitter = widget.sitter;
    return Scaffold(
      appBar: pawBar('Book Sitter', back: true),
      body: Column(children: [
        Container(
          color: AppColors.taupe,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
          child: Row(children: [
            for (var i = 0; i < _dates.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _day = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: i == _day ? AppColors.gold : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF6B635B)),
                    ),
                    child: Column(children: [
                      Text('${_dates[i].day}', style: headStyle(17, i == _day ? AppColors.charcoal : Colors.white)),
                      Text(monShort(_dates[i]), style: TextStyle(fontSize: 10, color: i == _day ? AppColors.charcoal : Colors.white70)),
                    ]),
                  ),
                ),
              ),
          ]),
        ),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(20), children: [
            Text(sitter.name, style: headStyle(20)),
            const SizedBox(height: 6),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(6)),
                child: Text('${sitter.rating}', style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              Text('Very Good (${sitter.reviews} reviews)', style: const TextStyle(color: AppColors.brown, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              for (final (i, label) in ['Services', 'Information', 'Review'].indexed)
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _tab = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _tab == i ? AppColors.gold : AppColors.line, width: 3))),
                      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: _tab == i ? FontWeight.w800 : FontWeight.w600)),
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 8),
            if (_tab == 0)
              for (var i = 0; i < kServices.length; i++)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: AppColors.brown,
                  value: _picked.contains(i),
                  onChanged: (v) => setState(() => v! ? _picked.add(i) : _picked.remove(i)),
                  title: Row(children: [
                    Expanded(child: Text(kServices[i].name, style: const TextStyle(fontWeight: FontWeight.w600))),
                    Text('\$${kServices[i].price}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ]),
                )
            else if (_tab == 1)
              Padding(padding: const EdgeInsets.only(top: 12), child: Text('${sitter.bio}\n\nArea: ${sitter.area}'))
            else
              for (final t in sitter.reviewTexts)
                ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.format_quote, color: AppColors.gold), title: Text(t)),
          ]),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: PillButton(_picked.isEmpty ? 'Book Appointment' : 'Book Appointment  -  \$$_total', onPressed: _picked.isEmpty ? null : _book),
          ),
        ),
      ]),
    );
  }
}
