import 'package:flutter/material.dart';

class BrandBadge extends StatelessWidget {
  final String brand;
  final double size;

  const BrandBadge({
    super.key,
    required this.brand,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    if (brand.toLowerCase() == 'porsche') {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFCD34D), width: 1),
        ),
        alignment: Alignment.center,
        child: const Text(
          '🛡️',
          style: TextStyle(fontSize: 12, height: 1),
        ),
      );
    }

    if (brand.toLowerCase() == 'nissan') {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
        ),
        alignment: Alignment.center,
        child: Container(
          width: size * 0.72,
          height: size * 0.72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF374151), width: 1.5),
          ),
          alignment: Alignment.center,
          child: const Text(
            'NISSAN',
            style: TextStyle(
              fontSize: 5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
        ),
      );
    }

    final preset = _getPreset(brand);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: preset.bg,
        shape: BoxShape.circle,
        border: Border.all(color: preset.border, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        preset.label,
        style: TextStyle(
          color: preset.text,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.4,
        ),
      ),
    );
  }

  _BadgePreset _getPreset(String brand) {
    switch (brand.toLowerCase()) {
      case 'honda':
        return const _BadgePreset(
          bg: Color(0xFFFEF2F2),
          border: Color(0xFFFCA5A5),
          text: Color(0xFFDC2626),
          label: 'H',
        );
      case 'kawasaki':
        return const _BadgePreset(
          bg: Color(0xFFECFDF5),
          border: Color(0xFF6EE7B7),
          text: Color(0xFF047857),
          label: 'KRT',
        );
      case 'hks':
        return const _BadgePreset(
          bg: Color(0xFFF3F4F6),
          border: Color(0xFFD1D5DB),
          text: Color(0xFF111827),
          label: 'HKS',
        );
      case 'rays':
        return const _BadgePreset(
          bg: Color(0xFFEFF6FF),
          border: Color(0xFF93C5FD),
          text: Color(0xFF1D4ED8),
          label: 'RAYS',
        );
      case 'shop':
        return const _BadgePreset(
          bg: Color(0xFFECFDF5),
          border: Color(0xFF10B981),
          text: Color(0xFF009B65),
          label: 'DYNO',
        );
      case 'meet':
        return const _BadgePreset(
          bg: Color(0xFFF3F4F6),
          border: Color(0xFFD1D5DB),
          text: Color(0xFF111827),
          label: 'MEET',
        );
      case 'motul':
        return const _BadgePreset(
          bg: Color(0xFFFEF2F2),
          border: Color(0xFFFCA5A5),
          text: Color(0xFFDC2626),
          label: '300V',
        );
      default:
        return const _BadgePreset(
          bg: Color(0xFFF3F4F6),
          border: Color(0xFFD1D5DB),
          text: Color(0xFF111827),
          label: 'AUTO',
        );
    }
  }
}

class _BadgePreset {
  final Color bg;
  final Color border;
  final Color text;
  final String label;

  const _BadgePreset({
    required this.bg,
    required this.border,
    required this.text,
    required this.label,
  });
}
