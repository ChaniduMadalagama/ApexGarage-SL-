class VehicleModel {
  final String id;
  final String brand;
  final String title;
  final String subtitle;
  final String? badge;
  final String watermark;
  final String graphicType;
  final String meta1;
  final String meta2;
  final String meta3;
  final String priceMain;
  final String priceSub;
  final int whp;
  final bool isFeatured;

  const VehicleModel({
    required this.id,
    required this.brand,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.watermark,
    required this.graphicType,
    required this.meta1,
    required this.meta2,
    required this.meta3,
    required this.priceMain,
    required this.priceSub,
    this.whp = 0,
    this.isFeatured = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'title': title,
    'subtitle': subtitle,
    'badge': badge,
    'watermark': watermark,
    'graphicType': graphicType,
    'meta1': meta1,
    'meta2': meta2,
    'meta3': meta3,
    'priceMain': priceMain,
    'priceSub': priceSub,
    'whp': whp,
    'isFeatured': isFeatured,
  };

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    id: json['id'] as String,
    brand: json['brand'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    badge: json['badge'] as String?,
    watermark: json['watermark'] as String,
    graphicType: json['graphicType'] as String,
    meta1: json['meta1'] as String,
    meta2: json['meta2'] as String,
    meta3: json['meta3'] as String,
    priceMain: json['priceMain'] as String,
    priceSub: json['priceSub'] as String,
    whp: (json['whp'] as num?)?.toInt() ?? 0,
    isFeatured: json['isFeatured'] as bool? ?? false,
  );
}
