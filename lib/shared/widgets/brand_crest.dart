import 'package:flutter/material.dart';

class BrandCrest extends StatelessWidget {
  final String brand;
  final double size;

  const BrandCrest({
    super.key,
    required this.brand,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    final style = _getBrandStyle(brand);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: style.bg,
        shape: BoxShape.circle,
        border: Border.all(color: style.border, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        style.label,
        style: TextStyle(
          color: style.text,
          fontSize: size * 0.3,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.4,
        ),
      ),
    );
  }

  _BrandStyle _getBrandStyle(String b) {
    switch (b.toLowerCase()) {
      case 'honda':
        return const _BrandStyle(
          bg: Color(0xFFFEF2F2),
          border: Color(0xFFFECACA),
          text: Color(0xFFDC2626),
          label: 'H',
        );
      case 'kawasaki':
        return const _BrandStyle(
          bg: Color(0xFFECFDF5),
          border: Color(0xFFA7F3D0),
          text: Color(0xFF009B65),
          label: 'KRT',
        );
      case 'nissan':
        return const _BrandStyle(
          bg: Color(0xFFF3F4F6),
          border: Color(0xFFD1D5DB),
          text: Color(0xFF111827),
          label: 'NIS',
        );
      case 'hks':
        return const _BrandStyle(
          bg: Color(0xFFF5F3FF),
          border: Color(0xFFDDD6FE),
          text: Color(0xFF6D28D9),
          label: 'HKS',
        );
      case 'spoon':
        return const _BrandStyle(
          bg: Color(0xFFEFF6FF),
          border: Color(0xFFBFDBFE),
          text: Color(0xFF2563EB),
          label: 'SPN',
        );
      case 'akrapovic':
        return const _BrandStyle(
          bg: Color(0xFFFEF2F2),
          border: Color(0xFFFECACA),
          text: Color(0xFFB91C1C),
          label: 'AKR',
        );
      case 'tein':
        return const _BrandStyle(
          bg: Color(0xFFECFDF5),
          border: Color(0xFFA7F3D0),
          text: Color(0xFF047857),
          label: 'TEIN',
        );
      default:
        final lbl = b.length >= 3 ? b.substring(0, 3).toUpperCase() : b.toUpperCase();
        return _BrandStyle(
          bg: const Color(0xFFF3F4F6),
          border: const Color(0xFFE5E7EB),
          text: const Color(0xFF1F2937),
          label: lbl,
        );
    }
  }
}

class _BrandStyle {
  final Color bg;
  final Color border;
  final Color text;
  final String label;

  const _BrandStyle({
    required this.bg,
    required this.border,
    required this.text,
    required this.label,
  });
}
