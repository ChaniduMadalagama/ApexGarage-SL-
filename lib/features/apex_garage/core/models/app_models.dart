class BuildLogModel {
  final String stage;
  final String title;
  final String shop;
  final String gain;
  final String cost;
  final DateTime? loggedAt;

  const BuildLogModel({
    required this.stage,
    required this.title,
    required this.shop,
    required this.gain,
    required this.cost,
    this.loggedAt,
  });

  Map<String, dynamic> toJson() => {
    'stage': stage,
    'title': title,
    'shop': shop,
    'gain': gain,
    'cost': cost,
    'loggedAt': loggedAt?.toIso8601String(),
  };

  factory BuildLogModel.fromJson(Map<String, dynamic> json) => BuildLogModel(
    stage: json['stage'] as String,
    title: json['title'] as String,
    shop: json['shop'] as String,
    gain: json['gain'] as String,
    cost: json['cost'] as String,
    loggedAt: json['loggedAt'] != null ? DateTime.parse(json['loggedAt'] as String) : null,
  );
}

class WorkshopModel {
  final String id;
  final String brand;
  final String title;
  final String subtitle;
  final String badge;
  final String watermark;
  final String graphicType;
  final String rating;
  final String specialization;
  final String bayCount;
  final String priceMain;
  final String priceSub;

  const WorkshopModel({
    required this.id,
    required this.brand,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.watermark,
    required this.graphicType,
    required this.rating,
    required this.specialization,
    required this.bayCount,
    required this.priceMain,
    required this.priceSub,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'title': title,
    'subtitle': subtitle,
    'badge': badge,
    'watermark': watermark,
    'graphicType': graphicType,
    'rating': rating,
    'specialization': specialization,
    'bayCount': bayCount,
    'priceMain': priceMain,
    'priceSub': priceSub,
  };

  factory WorkshopModel.fromJson(Map<String, dynamic> json) => WorkshopModel(
    id: json['id'] as String,
    brand: json['brand'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    badge: json['badge'] as String,
    watermark: json['watermark'] as String,
    graphicType: json['graphicType'] as String,
    rating: json['rating'] as String,
    specialization: json['specialization'] as String,
    bayCount: json['bayCount'] as String,
    priceMain: json['priceMain'] as String,
    priceSub: json['priceSub'] as String,
  );
}

class MeetModel {
  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final String watermark;
  final String graphicType;
  final int attendeesCount;
  final String category;
  final String location;
  final String price;

  const MeetModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.watermark,
    required this.graphicType,
    required this.attendeesCount,
    required this.category,
    required this.location,
    required this.price,
  });
}

class FeedPostModel {
  final String id;
  final String author;
  final String action;
  final String timeAgo;
  final String brand;
  final String title;
  final String subtitle;
  final String badge;
  final String watermark;
  final String graphicType;
  final int likes;
  final int comments;
  final String stage;
  final String priceMain;
  final String priceSub;
  final bool isSponsored;

  const FeedPostModel({
    required this.id,
    required this.author,
    required this.action,
    required this.timeAgo,
    required this.brand,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.watermark,
    required this.graphicType,
    required this.likes,
    required this.comments,
    required this.stage,
    required this.priceMain,
    required this.priceSub,
    this.isSponsored = false,
  });
}
