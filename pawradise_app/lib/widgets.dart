import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'data.dart';
import 'theme.dart';

AppBar pawBar(String title, {bool back = false}) => AppBar(
      backgroundColor: AppColors.taupe,
      foregroundColor: Colors.white,
      centerTitle: true,
      automaticallyImplyLeading: back,
      title: Text(title.toUpperCase(), style: headStyle(15, Colors.white)),
    );

void toast(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));

enum CatMood { normal, grumpy }

class _Look {
  final Color coat, eye;
  final Color? earL, earR;
  final bool dark;
  const _Look(this.coat, this.eye, {this.earL, this.earR, this.dark = false});
}

const _looks = {
  CatBreed.tabby: _Look(Color(0xFFE8893A), Color(0xFF7BC043)),
  CatBreed.calico: _Look(Color(0xFFFFFFFF), Color(0xFFE5A823), earL: Color(0xFFE8893A), earR: Color(0xFF2B2B2B)),
  CatBreed.black: _Look(Color(0xFF2E2E2E), Color(0xFFF2C230), dark: true),
  CatBreed.british: _Look(Color(0xFF8C95A3), Color(0xFFF0A020), dark: true),
  CatBreed.siamese: _Look(Color(0xFFF3E6D0), Color(0xFF4FA3E0), earL: Color(0xFF6B4F3A), earR: Color(0xFF6B4F3A)),
  CatBreed.persian: _Look(Color(0xFFF7F3EA), Color(0xFFD9822B)),
  CatBreed.tuxedo: _Look(Color(0xFF2E2E2E), Color(0xFF7BC043), dark: true),
};

/// Cat illustration drawn in code. Each breed has its own coat, markings and eyes.
class CatFace extends StatelessWidget {
  final double size;
  final CatBreed breed;
  final CatMood mood;
  const CatFace({super.key, this.size = 80, this.breed = CatBreed.tabby, this.mood = CatMood.normal});

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size, child: CustomPaint(painter: _CatPainter(breed, mood)));
}

class _CatPainter extends CustomPainter {
  final CatBreed breed;
  final CatMood mood;
  _CatPainter(this.breed, this.mood);

  @override
  void paint(Canvas canvas, Size size) {
    final look = _looks[breed]!;
    final s = size.width / 2.5;
    final cx = size.width / 2;
    final cy = size.height * 0.58;
    final wide = breed == CatBreed.british;
    final flat = breed == CatBreed.persian;
    final hw = (wide ? 2.3 : (flat ? 2.15 : 2.0)) * s / 2;
    final hh = (wide ? 1.85 : (flat ? 1.75 : 1.7)) * s;
    final earK = (wide || flat) ? .75 : 1.0;
    final coat = Paint()..color = look.coat;
    final hsl = HSLColor.fromColor(look.coat);
    final darker = hsl.withLightness((hsl.lightness * .7).clamp(0.0, 1.0).toDouble()).toColor();
    final head = Rect.fromCenter(center: Offset(cx, cy), width: hw * 2, height: hh);

    // ears
    for (final g in [-1.0, 1.0]) {
      final ec = (g < 0 ? look.earL : look.earR) ?? look.coat;
      canvas.drawPath(
          Path()
            ..moveTo(cx + g * .88 * hw, cy - .25 * s)
            ..lineTo(cx + g * .62 * hw, cy - (.5 + .68 * earK) * s)
            ..lineTo(cx + g * .12 * hw, cy - .72 * s)
            ..close(),
          Paint()..color = ec);
      canvas.drawPath(
          Path()
            ..moveTo(cx + g * .7 * hw, cy - .45 * s)
            ..lineTo(cx + g * .6 * hw, cy - (.5 + .42 * earK) * s)
            ..lineTo(cx + g * .3 * hw, cy - .66 * s)
            ..close(),
          Paint()..color = const Color(0xFFF4B6A8));
    }

    // head (+ fluffy cheeks for Persian)
    canvas.drawOval(head, coat);
    if (flat) {
      for (final g in [-1.0, 1.0]) {
        canvas.drawOval(Rect.fromCenter(center: Offset(cx + g * .75 * s, cy + .28 * s), width: .9 * s, height: .8 * s), coat);
      }
    }

    // breed markings, clipped to the head
    canvas.save();
    canvas.clipPath(Path()..addOval(head));
    switch (breed) {
      case CatBreed.tabby:
        final stripe = Paint()
          ..color = darker
          ..strokeWidth = math.max(2.0, .09 * s)
          ..strokeCap = StrokeCap.round;
        for (final d in [-.28, 0.0, .28]) {
          canvas.drawLine(Offset(cx + d * s, cy - .85 * s), Offset(cx + d * s, cy - .5 * s), stripe);
        }
        for (final g in [-1.0, 1.0]) {
          canvas.drawLine(Offset(cx + g * hw, cy + .05 * s), Offset(cx + g * .65 * s, cy + .12 * s), stripe);
          canvas.drawLine(Offset(cx + g * hw, cy + .3 * s), Offset(cx + g * .7 * s, cy + .3 * s), stripe);
        }
      case CatBreed.calico:
        canvas.drawCircle(Offset(cx - .6 * s, cy - .35 * s), .55 * s, Paint()..color = const Color(0xFFE8893A));
        canvas.drawCircle(Offset(cx + .7 * s, cy - .2 * s), .5 * s, Paint()..color = const Color(0xFF2B2B2B));
      case CatBreed.siamese:
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + .28 * s), width: 1.5 * s, height: 1.1 * s),
            Paint()
              ..color = const Color(0xFF6B4F3A).withAlpha(200)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * .18));
      case CatBreed.tuxedo:
        final white = Paint()..color = Colors.white;
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + .42 * s), width: 1.0 * s, height: .75 * s), white);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - .25 * s), width: .22 * s, height: .9 * s), white);
      case CatBreed.black:
      case CatBreed.british:
      case CatBreed.persian:
        break;
    }
    canvas.restore();

    // eyes
    final ex = (wide ? .46 : .4) * s;
    final ey = cy - (flat ? 0.0 : .05 * s);
    for (final g in [-1.0, 1.0]) {
      final c = Offset(cx + g * ex, ey);
      canvas.drawCircle(c, .19 * s, Paint()..color = look.eye);
      canvas.drawOval(Rect.fromCenter(center: c, width: .09 * s, height: .22 * s), Paint()..color = AppColors.charcoal);
      canvas.drawCircle(c.translate(.05 * s, -.06 * s), .04 * s, Paint()..color = Colors.white);
      if (mood == CatMood.grumpy) {
        canvas.drawRect(Rect.fromLTRB(c.dx - .21 * s, c.dy - .22 * s, c.dx + .21 * s, c.dy - .02 * s), coat);
        canvas.drawLine(Offset(c.dx - .2 * s, c.dy - .02 * s), Offset(c.dx + .2 * s, c.dy - .02 * s),
            Paint()..color = AppColors.charcoal..strokeWidth = 2);
      }
    }

    // nose, mouth, whiskers
    final ny = cy + (flat ? .1 : .18) * s;
    final mouthColor = (breed == CatBreed.black || breed == CatBreed.british) ? Colors.white70 : AppColors.charcoal;
    final mouth = Paint()
      ..color = mouthColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final whisker = Paint()
      ..color = look.dark ? Colors.white.withAlpha(170) : AppColors.charcoal.withAlpha(110)
      ..strokeWidth = 1;
    for (final g in [-1.0, 1.0]) {
      canvas.drawPath(
          Path()
            ..moveTo(cx, ny + .12 * s)
            ..quadraticBezierTo(cx + g * .1 * s, ny + .27 * s, cx + g * .22 * s, ny + .18 * s),
          mouth);
      canvas.drawLine(Offset(cx + g * .55 * s, ny + .04 * s), Offset(cx + g * 1.1 * s, ny - .04 * s), whisker);
      canvas.drawLine(Offset(cx + g * .55 * s, ny + .12 * s), Offset(cx + g * 1.1 * s, ny + .18 * s), whisker);
    }
    canvas.drawPath(
        Path()
          ..moveTo(cx - .09 * s, ny)
          ..lineTo(cx + .09 * s, ny)
          ..lineTo(cx, ny + .12 * s)
          ..close(),
        Paint()..color = const Color(0xFFE88B94));
  }

  @override
  bool shouldRepaint(covariant _CatPainter old) => old.breed != breed || old.mood != mood;
}

/// Sticker-style paw print with a white outline (used on the login screen).
class PawSticker extends StatelessWidget {
  final double size, angle;
  final Color fill;
  const PawSticker({super.key, this.size = 48, this.fill = AppColors.charcoal, this.angle = 0});

  @override
  Widget build(BuildContext context) =>
      Transform.rotate(angle: angle, child: SizedBox(width: size, height: size, child: CustomPaint(painter: _PawPainter(fill))));
}

class _PawPainter extends CustomPainter {
  final Color fill;
  _PawPainter(this.fill);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 1.5;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final shapes = <Rect>[
      Rect.fromCenter(center: Offset(cx, cy + .25 * s), width: .9 * s, height: .76 * s),
      for (final d in [(-.55, -.12), (-.2, -.5), (.2, -.5), (.55, -.12)])
        Rect.fromCenter(center: Offset(cx + d.$1 * s, cy + d.$2 * s), width: .34 * s, height: .44 * s),
    ];
    for (final r in shapes) {
      canvas.drawOval(r.shift(const Offset(0, 3)), Paint()..color = Colors.black38..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    }
    for (final r in shapes) {
      canvas.drawOval(r.inflate(s * .07), Paint()..color = Colors.white);
    }
    for (final r in shapes) {
      canvas.drawOval(r, Paint()..color = fill);
    }
  }

  @override
  bool shouldRepaint(covariant _PawPainter old) => old.fill != fill;
}

/// Sky + hills placeholder used on sitter cards.
class LandscapePhoto extends StatelessWidget {
  final double width, height;
  const LandscapePhoto({super.key, this.width = 118, this.height = 106});

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: width, height: height, child: CustomPaint(painter: _LandPainter())));
}

class _LandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFBFE3F2));
    canvas.drawCircle(Offset(s.width * .78, s.height * .25), s.height * .1, Paint()..color = const Color(0xFFFFF3B0));
    canvas.drawOval(Rect.fromCenter(center: Offset(s.width * .3, s.height * 1.02), width: s.width * 1.6, height: s.height * .9),
        Paint()..color = const Color(0xFF8DB04B));
    canvas.drawOval(Rect.fromCenter(center: Offset(s.width * .85, s.height * 1.1), width: s.width * 1.4, height: s.height * .8),
        Paint()..color = const Color(0xFF6E9A3A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color, textColor;
  final Color? borderColor;
  const PillButton(this.label, {super.key, this.onPressed, this.color = AppColors.charcoal, this.textColor = Colors.white, this.borderColor});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            disabledBackgroundColor: color.withAlpha(90),
            elevation: 0,
            shape: StadiumBorder(side: borderColor == null ? BorderSide.none : BorderSide(color: borderColor!, width: 2)),
          ),
          child: Text(label, style: headStyle(14, textColor)),
        ),
      );
}

class PillField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final IconData? icon;
  final String? Function(String?)? validator;
  const PillField(this.controller, this.hint, {super.key, this.obscure = false, this.icon, this.validator});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon == null ? null : Icon(icon, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.line)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.line)),
        ),
      );
}

class CatCard extends StatelessWidget {
  final Cat cat;
  final bool favorite;
  final VoidCallback onTap, onFavorite;
  const CatCard({super.key, required this.cat, required this.favorite, required this.onTap, required this.onFavorite});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Stack(children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: CatFace(size: 90, breed: cat.breed),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.white,
                      child: Icon(favorite ? Icons.favorite : Icons.favorite_border, size: 16, color: favorite ? Colors.redAccent : AppColors.charcoal),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 6),
            Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            Text(cat.breed.label, style: const TextStyle(fontSize: 11, color: AppColors.brown)),
          ]),
        ),
      );
}

/// Full-body pixel cat sprite. pose: loaf, sit, sleep, lie or stand.
class PixelCat extends StatelessWidget {
  final CatBreed breed;
  final String pose;
  final double width;
  const PixelCat({super.key, required this.breed, this.pose = 'sit', this.width = 100});

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/cats/poses/${breed.name}_$pose.png',
        width: width,
        filterQuality: FilterQuality.none,
      );
}
