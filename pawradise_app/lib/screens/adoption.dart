import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

class AdoptionScreen extends StatefulWidget {
  const AdoptionScreen({super.key});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  String _query = '';
  CatBreed? _breed; // null = all breeds

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final list = cats.where((c) => c.name.toLowerCase().contains(_query.toLowerCase()) && (_breed == null || c.breed == _breed)).toList();
    return Scaffold(
      appBar: pawBar('Cat Adoption'),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Search for pets',
            suffixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.line)),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            Expanded(child: Text('Pet Adoption\nMade Easy', style: headStyle(17))),
            const PixelCat( breed: CatBreed.calico,pose: 'sit', width: 110),
          ]),
        ),
        const SizedBox(height: 14),
        Text('Breeds', style: headStyle(14)),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (final b in [null, ...CatBreed.values])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(b == null ? 'All' : b.label),
                  selected: _breed == b,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _breed = b),
                  selectedColor: AppColors.gold,
                  backgroundColor: Colors.white,
                  shape: const StadiumBorder(side: BorderSide(color: AppColors.taupe)),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('No cats found')))
        else
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: .95,
            children: [
              for (final c in list)
                CatCard(
                  cat: c,
                  favorite: s.favorites.contains(c.id),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CatDetailScreen(cat: c))),
                  onFavorite: () => s.toggleFavorite(c.id),
                ),
            ],
          ),
      ]),
    );
  }
}

class CatDetailScreen extends StatelessWidget {
  final Cat cat;
  const CatDetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final requested = s.hasRequested(cat);
    final fav = s.favorites.contains(cat.id);
    return Scaffold(
      appBar: pawBar(cat.name, back: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(18)),
            child: Stack(children: [
              Center(child: CatFace(size: 190, breed: cat.breed)),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () => s.toggleFavorite(cat.id),
                  icon: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Colors.redAccent : AppColors.charcoal),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          Text(cat.name, style: headStyle(24)),
          Text('${cat.breed.label}  |  ${cat.info}', style: const TextStyle(color: AppColors.brown, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text(cat.story, style: const TextStyle(fontSize: 15, height: 1.4)),
          const Spacer(),
          SafeArea(
            child: PillButton(
              requested ? 'Adoption requested' : 'Adopt ${cat.name}',
              color: AppColors.gold,
              textColor: AppColors.charcoal,
              onPressed: requested
                  ? null
                  : () {
                      s.requestAdoption(cat);
                      toast(context, 'Request sent for ${cat.name}');
                      Navigator.of(context).pop();
                    },
            ),
          ),
        ]),
      ),
    );
  }
}
