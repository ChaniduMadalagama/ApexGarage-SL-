import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// ============================================================================
// CORE DATA MODELS (DECOUPLED FOR LARAVEL RESTFUL API BACKEND)
// ============================================================================

class SpecItem {
  final IconData icon;
  final String label;

  const SpecItem({required this.icon, required this.label});
}

class BuildLogEntry {

  const BuildLogEntry({
    required this.id,
    required this.date,
    required this.category,
    required this.title,
    required this.brand,
    required this.cost,
    required this.mechanic,
    required this.notes,
    this.photoLabel,
    this.photoUrl,
  });
  final String id;
  final String date;
  final String category;
  final String title;
  final String brand;
  final int cost;
  final String mechanic;
  final String notes;
  final String? photoLabel;
  final String? photoUrl;

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'category': category,
    'title': title,
    'brand': brand,
    'cost': cost,
    'mechanic': mechanic,
    'notes': notes,
    'photoLabel': photoLabel,
  };
}

class ServiceRecord {
  final String id;
  final String title;
  final String date;
  final int odometer;
  final String workshop;
  final List<String> partsChanged;
  final int cost;
  final int nextServiceKm;
  final String nextServiceDate;
  final String notes;
  final String receiptLabel;

  const ServiceRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.odometer,
    required this.workshop,
    required this.partsChanged,
    required this.cost,
    required this.nextServiceKm,
    required this.nextServiceDate,
    required this.notes,
    required this.receiptLabel,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date,
    'odometer': odometer,
    'workshop': workshop,
    'partsChanged': partsChanged,
    'cost': cost,
    'nextServiceKm': nextServiceKm,
    'nextServiceDate': nextServiceDate,
    'notes': notes,
    'receiptLabel': receiptLabel,
  };
}

class CommunityFeedPost {
  final String id;
  final String author;
  final String handle;
  final String avatar;
  final String crew;
  final String timeAgo;
  final String vehicleTitle;
  final String modTitle;
  final String workshop;
  final String illustration;
  final String watermark;
  final String? photoUrl;
  final List<String> tags;
  final int likes;
  final int comments;
  final bool liked;

  const CommunityFeedPost({
    required this.id,
    required this.author,
    required this.handle,
    required this.avatar,
    required this.crew,
    required this.timeAgo,
    required this.vehicleTitle,
    required this.modTitle,
    required this.workshop,
    required this.illustration,
    required this.watermark,
    this.photoUrl,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.liked,
  });

  CommunityFeedPost copyWith({
    int? likes,
    bool? liked,
  }) {
    return CommunityFeedPost(
      id: id,
      author: author,
      handle: handle,
      avatar: avatar,
      crew: crew,
      timeAgo: timeAgo,
      vehicleTitle: vehicleTitle,
      modTitle: modTitle,
      workshop: workshop,
      illustration: illustration,
      watermark: watermark,
      tags: tags,
      likes: likes ?? this.likes,
      comments: comments,
      liked: liked ?? this.liked,
    );
  }
}

class VehicleModel {
  final String id;
  final String category; // 'Car' | 'Bike'
  final String brand;
  final String title;
  final String subtitle;
  final String shortContextLabel;
  final String watermark;
  final String illustration; // 'fd2' | 'zx4rr' | 's15'
  final String? photoUrl;
  final String stageBadge;
  final String status;
  final String statusTone; // 'amber' | 'emerald'
  final String year;
  final String chassis;
  final String engineCode;
  final String engine;
  final int currentMileage;
  final int lastServiceMileage;
  final int serviceInterval;
  final int nextServiceMileage;
  final String nextServiceDate;
  final String powerValue;
  final String powerUnit;
  final String torqueValue;
  final int estimatedValueLkr;
  final List<SpecItem> specs;
  final List<BuildLogEntry> logs;
  final List<ServiceRecord> serviceRecords;

  const VehicleModel({
    required this.id,
    required this.category,
    required this.brand,
    required this.title,
    required this.subtitle,
    this.shortContextLabel = '',
    required this.watermark,
    required this.illustration,
    this.photoUrl,
    this.stageBadge = 'Active Build',
    required this.status,
    this.statusTone = 'emerald',
    this.year = '2008',
    required this.chassis,
    this.engineCode = '',
    required this.engine,
    this.currentMileage = 64350,
    this.lastServiceMileage = 60000,
    this.serviceInterval = 5000,
    this.nextServiceMileage = 65000,
    this.nextServiceDate = '20 Nov 2026',
    required this.powerValue,
    required this.powerUnit,
    this.torqueValue = '218 Nm',
    this.estimatedValueLkr = 14500000,
    required this.specs,
    required this.logs,
    this.serviceRecords = const [],
  });

  int get kmLeftUntilService => (nextServiceMileage - currentMileage).clamp(0, 999999);
  bool get isServiceUrgent => kmLeftUntilService <= 1000;
}

class PartModel {
  final String id;
  final String brand;
  final String title;
  final String subtitle;
  final String watermark;
  final String illustration; // 'turbo' | 'caliper' | 'exhaust' | 'coilover'
  final String? photoUrl;
  final int price;
  final String condition;
  final List<String> trust;
  final String seller;
  final String location;
  final String rating;
  final bool verified;
  final List<SpecItem> specs;
  final String description;

  const PartModel({
    required this.id,
    required this.brand,
    required this.title,
    required this.subtitle,
    required this.watermark,
    required this.illustration,
    this.photoUrl,
    required this.price,
    required this.condition,
    required this.trust,
    required this.seller,
    required this.location,
    required this.rating,
    required this.verified,
    required this.specs,
    required this.description,
  });
}

class FeedComment {
  final String id;
  final String author;
  final String handle;
  final String avatar;
  final String body;
  final String timeAgo;

  const FeedComment({
    required this.id,
    required this.author,
    required this.handle,
    required this.avatar,
    required this.body,
    required this.timeAgo,
  });
}

class SponsoredAdModel {
  final String id;
  final String sponsor;
  final String headline;
  final String placement;

  const SponsoredAdModel({
    required this.id,
    required this.sponsor,
    required this.headline,
    required this.placement,
  });
}

class MechanicModel {
  final String id;
  final String name;
  final String location;
  final String specialty;
  final String rating;
  final int reviews;
  final String basePrice;
  final List<String> tags;
  final String availability;

  const MechanicModel({
    required this.id,
    required this.name,
    required this.location,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.basePrice,
    required this.tags,
    required this.availability,
  });

  List<String> get specialties => tags;
  bool get verified => true;
}

class MeetModel {
  final String id;
  final String pinId;
  final String title;
  final String date;
  final String location;
  final String host;
  final int going;
  final double pinTopRatio;
  final double pinLeftRatio;
  final String pinLabel;
  final double latitude;
  final double longitude;

  const MeetModel({
    required this.id,
    required this.pinId,
    required this.title,
    required this.date,
    required this.location,
    required this.host,
    required this.going,
    required this.pinTopRatio,
    required this.pinLeftRatio,
    required this.pinLabel,
    this.latitude = 6.9271,
    this.longitude = 79.8612,
  });
}

class CrewLiveRider {
  final String userId;
  final String name;
  final String handle;
  final String avatar;
  final String crewName;
  final bool isRiding;
  final bool isMe;
  final String? vehicleId;
  final String vehicleTitle;
  final String vehicleCategory;
  final String vehicleBrand;
  final String stageBadge;
  final double latitude;
  final double longitude;
  final String? statusNote;
  final String lastSeenAgo;

  const CrewLiveRider({
    required this.userId,
    required this.name,
    required this.handle,
    required this.avatar,
    required this.crewName,
    required this.isRiding,
    required this.isMe,
    this.vehicleId,
    required this.vehicleTitle,
    required this.vehicleCategory,
    required this.vehicleBrand,
    required this.stageBadge,
    required this.latitude,
    required this.longitude,
    this.statusNote,
    required this.lastSeenAgo,
  });
}

class CrewModel {
  final String id;
  final String name;
  final int members;
  final String focus;
  final String location;

  const CrewModel({
    required this.id,
    required this.name,
    required this.members,
    required this.focus,
    required this.location,
  });

  String get category => focus;
  String get description => 'Dedicated enthusiast collective focused on $focus in $location. Regular weekend runs and dyno days.';
}

class ChatMessage {
  final String from; // 'seller' | 'me'
  final String text;
  final DateTime time;

  ChatMessage({
    required this.from,
    required this.text,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

// ============================================================================
// INITIAL SEED MOCK DATA
// ============================================================================

final List<VehicleModel> kSeedVehicles = [
  VehicleModel(
    id: 'v1',
    category: 'Car',
    brand: 'Honda',
    shortContextLabel: 'Honda Civic FD2 (K20A)',
    title: 'Honda Civic Type R (FD2)',
    subtitle: '2008 · K20A · WP KQ-2208',
    watermark: 'CIVIC FD2',
    illustration: 'fd2',
    stageBadge: 'Stage 2 N/A',
    status: 'Due Soon',
    statusTone: 'amber',
    year: '2008',
    chassis: 'FD2',
    engineCode: 'K20A',
    engine: 'K20A 2.0L i-VTEC',
    currentMileage: 64350,
    lastServiceMileage: 60000,
    serviceInterval: 5000,
    nextServiceMileage: 65000,
    nextServiceDate: '20 Nov 2026',
    powerValue: '242',
    powerUnit: 'WHP',
    torqueValue: '218 Nm',
    estimatedValueLkr: 14500000,
    specs: const [
      SpecItem(icon: LucideIcons.gauge, label: '64,350 km'),
      SpecItem(icon: LucideIcons.zap, label: '218 Nm'),
      SpecItem(icon: LucideIcons.wrench, label: '3 Mods'),
    ],
    serviceRecords: const [
      ServiceRecord(
        id: 'sr1',
        title: '60,000 km Major Service & Fluid Flush',
        date: '14 Aug 2026',
        odometer: 60000,
        workshop: 'K-Series Works SL · Nawala',
        partsChanged: ['Motul 300V 5W-40', 'HAMP Oil Filter', 'Honda MTF-III Fluid', 'NGK Iridium Plugs'],
        cost: 48500,
        nextServiceKm: 65000,
        nextServiceDate: '20 Nov 2026',
        notes: 'Full fluid flush, valve clearance checked, and throttle body cleaned.',
        receiptLabel: 'INV-2026-0814.webp · 184 KB',
      ),
      ServiceRecord(
        id: 'sr2',
        title: '55,000 km Routine Oil & Filter Service',
        date: '02 Apr 2026',
        odometer: 55000,
        workshop: 'K-Series Works SL · Nawala',
        partsChanged: ['Toyota 10W-30 / Synthetic Blend', 'HAMP Oil Filter', 'Brembo Front Pads'],
        cost: 29500,
        nextServiceKm: 60000,
        nextServiceDate: '15 Aug 2026',
        notes: 'Routine 5,000 km oil change and front brake pad replacement.',
        receiptLabel: 'INV-2026-0402.webp · 152 KB',
      ),
    ],
    logs: const [
      BuildLogEntry(
        id: 'l1',
        date: '14 Oct 2026',
        category: 'Electronics',
        title: 'Hondata FlashPro + Dyno Tune',
        brand: 'Hondata',
        cost: 145000,
        mechanic: 'K-Series Works SL · Nawala',
        notes: 'VTEC crossover lowered to 5,200 RPM, safe 95 octane ignition map.',
        photoLabel: 'Dyno Chart · 242 WHP @ 8,400 RPM',
      ),
      BuildLogEntry(
        id: 'l2',
        date: '22 Aug 2026',
        category: 'Exhaust',
        title: 'Toda Racing 4-2-1 Stainless Header',
        brand: 'Toda Racing',
        cost: 215000,
        mechanic: 'Apex Dyno Lab · Pannipitiya',
        notes: 'Mid-range torque bump +18 Nm with heat-wrapped primaries.',
        photoLabel: 'Engine Bay Header Fitment',
      ),
      BuildLogEntry(
        id: 'l3',
        date: '04 Jun 2026',
        category: 'Suspension',
        title: 'Spoon Rigid Collar & Hardrace Camber Kit',
        brand: 'Spoon Sports',
        cost: 88000,
        mechanic: 'K-Series Works SL · Nawala',
        notes: 'Corner balanced for Katukurunda track surface (-2.2° front camber).',
        photoLabel: 'Alignment Spec Sheet',
      ),
    ],
  ),
  VehicleModel(
    id: 'v2',
    category: 'Bike',
    brand: 'Kawasaki',
    shortContextLabel: 'Kawasaki Ninja ZX-4RR',
    title: 'Kawasaki Ninja ZX-4RR',
    subtitle: '2024 · 399cc I4 · WP BGZ-4040',
    watermark: 'ZX-4RR',
    illustration: 'zx4rr',
    stageBadge: 'Track Spec',
    status: 'Health OK',
    statusTone: 'emerald',
    year: '2024',
    chassis: 'ZX400P',
    engineCode: 'ZX400P',
    engine: '399cc Inline-4 DOHC',
    currentMileage: 4200,
    lastServiceMileage: 3000,
    serviceInterval: 5000,
    nextServiceMileage: 8300,
    nextServiceDate: '12 Jan 2027',
    powerValue: '77',
    powerUnit: 'HP',
    torqueValue: '42 Nm',
    estimatedValueLkr: 4850000,
    specs: const [
      SpecItem(icon: LucideIcons.gauge, label: '4,200 km'),
      SpecItem(icon: LucideIcons.zap, label: '16,000 RPM'),
      SpecItem(icon: LucideIcons.wrench, label: '2 Mods'),
    ],
    serviceRecords: const [
      ServiceRecord(
        id: 'sr3',
        title: '3,000 km Break-In & Chain Service',
        date: '18 Sep 2026',
        odometer: 3000,
        workshop: 'MotoSpec Garage · Dehiwala',
        partsChanged: ['Motul 300V 10W-40 Factory Line', 'OEM Kawasaki Filter', 'Motul Chain Lube C4'],
        cost: 24500,
        nextServiceKm: 8300,
        nextServiceDate: '12 Jan 2027',
        notes: 'Oil & filter change, chain tension adjusted and lubed, brake fluid inspected.',
        receiptLabel: 'MOTOSPEC-3K.webp · 168 KB',
      ),
    ],
    logs: const [
      BuildLogEntry(
        id: 'l4',
        date: '02 Nov 2026',
        category: 'Exhaust',
        title: 'Akrapovic Carbon Slip-On & Woolich Flash',
        brand: 'Akrapovic',
        cost: 240000,
        mechanic: 'MotoSpec Garage · Dehiwala',
        notes: 'Unlocked top-end EU restriction; crisp blipper downshifts.',
        photoLabel: 'Slip-On Titanium Link Fitment',
      ),
      BuildLogEntry(
        id: 'l5',
        date: '11 Sep 2026',
        category: 'Suspension',
        title: 'Showa BFRC Rear Shock Preload Setup',
        brand: 'Showa',
        cost: 35000,
        mechanic: 'MotoSpec Garage · Dehiwala',
        notes: 'Dialed rider sag to 32mm for Southern Expressway dawn runs.',
        photoLabel: 'Suspension Geometry Card',
      ),
    ],
  ),
  VehicleModel(
    id: 'v3',
    category: 'Car',
    brand: 'Nissan',
    shortContextLabel: 'Nissan Silvia S15 (SR20DET)',
    title: 'Nissan Silvia S15 Spec-R',
    subtitle: '2000 · SR20DET · WP JS-1500',
    watermark: 'SILVIA S15',
    illustration: 's15',
    stageBadge: 'Stage 3 Turbo',
    status: 'Due Soon',
    statusTone: 'amber',
    year: '2000',
    chassis: 'S15',
    engineCode: 'SR20DET',
    engine: 'SR20DET 2.0L Turbo',
    currentMileage: 82100,
    lastServiceMileage: 80000,
    serviceInterval: 5000,
    nextServiceMileage: 85000,
    nextServiceDate: '05 Feb 2027',
    powerValue: '380',
    powerUnit: 'WHP',
    torqueValue: '445 Nm',
    estimatedValueLkr: 16200000,
    specs: const [
      SpecItem(icon: LucideIcons.gauge, label: '82,100 km'),
      SpecItem(icon: LucideIcons.zap, label: '1.5 Bar'),
      SpecItem(icon: LucideIcons.wrench, label: '2 Mods'),
    ],
    serviceRecords: const [
      ServiceRecord(
        id: 'sr4',
        title: '80,000 km Turbo Oil, HMMF & Diff Service',
        date: '25 Sep 2026',
        odometer: 80000,
        workshop: 'Apex Dyno Lab · Pannipitiya',
        partsChanged: ['Motul 300V 15W-50', 'Nismo Oil Filter', 'LSD Gear Oil 75W-140'],
        cost: 42000,
        nextServiceKm: 85000,
        nextServiceDate: '05 Feb 2027',
        notes: 'Checked turbo oil feed line and boost leak tested to 1.5 bar.',
        receiptLabel: 'APEX-80K.webp · 210 KB',
      ),
    ],
    logs: const [
      BuildLogEntry(
        id: 'l6',
        date: '19 Sep 2026',
        category: 'Engine/Turbo',
        title: 'HKS GTIII-RS Turbo & Link G4X ECU',
        brand: 'HKS',
        cost: 495000,
        mechanic: 'Apex Dyno Lab · Pannipitiya',
        notes: '380 WHP on 95 octane + water-meth injection safety cut.',
        photoLabel: 'Turbo Manifold Bay Shot',
      ),
      BuildLogEntry(
        id: 'l7',
        date: '10 Jul 2026',
        category: 'Aero',
        title: 'Nismo Aero Bumper & Volk TE37 18x9.5J',
        brand: 'Rays Volk',
        cost: 620000,
        mechanic: 'Colombo Bodycraft · Boralesgamuwa',
        notes: 'Bronze forged TE37s wrapped in Michelin Pilot Sport 4S.',
        photoLabel: 'Wheel Fitment & Stance',
      ),
    ],
  ),
];

final List<CommunityFeedPost> kSeedCommunityFeed = [
  const CommunityFeedPost(
    id: 'cf1',
    author: 'Kasun Perera',
    handle: '@kasun_ct9a',
    avatar: 'KP',
    crew: 'Colombo JDM Syndicate',
    timeAgo: '18m ago',
    vehicleTitle: 'Mitsubishi Lancer Evolution IX RS (4G63T)',
    modTitle: 'Link G4X Plug-In ECU + 412 WHP Dyno Pull',
    workshop: 'Apex Dyno Lab · Pannipitiya',
    illustration: 'turbo',
    watermark: 'EVO IX 412HP',
    tags: ['4G63T', '1.8 Bar Boost', 'E85 Flex'],
    likes: 86,
    comments: 14,
    liked: false,
  ),
  const CommunityFeedPost(
    id: 'cf2',
    author: 'Dilshan Silva',
    handle: '@dilshan_krt',
    avatar: 'DS',
    crew: 'KandyTouge Riders',
    timeAgo: '1h ago',
    vehicleTitle: 'Kawasaki Ninja ZX-25R SE (250cc I4)',
    modTitle: 'Full Titanium Austin Racing Exhaust + Quickshifter',
    workshop: 'MotoSpec Garage · Dehiwala',
    illustration: 'exhaust',
    watermark: 'ZX-25R 18KRPM',
    tags: ['18,500 RPM', 'Titanium Header', 'Woolich Tune'],
    likes: 64,
    comments: 9,
    liked: true,
  ),
];

final List<PartModel> kSeedParts = [
  const PartModel(
    id: 'p1',
    brand: 'HKS',
    title: 'HKS GTIII-RS Bolt-On Turbocharger Kit',
    subtitle: 'SR20DET / S14 / S15 · Up to 450 HP',
    watermark: 'HKS TURBO',
    illustration: 'turbo',
    price: 385000,
    condition: 'Brand New In Box',
    trust: ['Verified Japanese JDM Import', 'Colombo In-Stock', 'Warranty Backed'],
    seller: 'JDM Spares SL',
    location: 'Pannipitiya, Colombo',
    rating: '4.98',
    verified: true,
    specs: [
      SpecItem(icon: LucideIcons.shieldCheck, label: 'Genuine HKS'),
      SpecItem(icon: LucideIcons.mapPin, label: 'Colombo 05'),
      SpecItem(icon: LucideIcons.tag, label: 'BNIB'),
    ],
    description:
        'Authentic HKS GTIII-RS turbo with billet compressor wheel and actuator. Direct bolt-on replacement for Nissan SR20DET with minimal lag and strong top-end boost.',
  ),
  const PartModel(
    id: 'p2',
    brand: 'Spoon',
    title: 'Spoon Monobloc 4-Pot Caliper Set',
    subtitle: 'Honda Civic FD2 / DC5 / FN2 Type R',
    watermark: 'SPOON RACING',
    illustration: 'caliper',
    price: 320000,
    condition: 'Brand New In Box',
    trust: ['Spoon Authorized Distributor', 'Lightweight Forged Aluminium', 'Islandwide Delivery'],
    seller: 'Type R Garage SL',
    location: 'Nawala, Rajagiriya',
    rating: '5.0',
    verified: true,
    specs: [
      SpecItem(icon: LucideIcons.shieldCheck, label: 'Spoon Sports'),
      SpecItem(icon: LucideIcons.mapPin, label: 'Nawala'),
      SpecItem(icon: LucideIcons.tag, label: 'Forged'),
    ],
    description:
        'Iconic Spoon Blue Monobloc calipers engineered for track longevity and high thermal dissipation. Drastically reduces un-sprung weight.',
  ),
  const PartModel(
    id: 'p3',
    brand: 'Akrapovic',
    title: 'Akrapovic Evolution Titanium Exhaust System',
    subtitle: 'Kawasaki Ninja ZX-4RR (2023-2026)',
    watermark: 'AKRAPOVIC TI',
    illustration: 'exhaust',
    price: 445000,
    condition: 'Brand New In Box',
    trust: ['Official EU Import', '4.2 kg Weight Reduction', 'Sound Verified'],
    seller: 'MotoSpec Imports',
    location: 'Dehiwala, Colombo',
    rating: '4.95',
    verified: true,
    specs: [
      SpecItem(icon: LucideIcons.shieldCheck, label: 'Titanium'),
      SpecItem(icon: LucideIcons.mapPin, label: 'Dehiwala'),
      SpecItem(icon: LucideIcons.zap, label: '+4.5 HP'),
    ],
    description:
        'Ultra-lightweight full titanium racing system with carbon fiber end-cap. Provides deep resonant exhaust note and significant power gains throughout the rev range.',
  ),
  const PartModel(
    id: 'p4',
    brand: 'Tein',
    title: 'Tein Flex Z Full Coilover Kit (16-Way Damping)',
    subtitle: 'Honda Civic FD1 / FD2 Type R',
    watermark: 'TEIN FLEX Z',
    illustration: 'coilover',
    price: 265000,
    condition: 'Brand New In Box',
    trust: ['Tein Genuine Seal', '16-Level Damping', 'Height Adjustable'],
    seller: 'Suspension Tech SL',
    location: 'Nugegoda, Colombo',
    rating: '4.9',
    verified: false,
    specs: [
      SpecItem(icon: LucideIcons.shieldCheck, label: 'Tein Japan'),
      SpecItem(icon: LucideIcons.mapPin, label: 'Nugegoda'),
      SpecItem(icon: LucideIcons.tag, label: 'Full Kit'),
    ],
    description:
        'Twin-tube design for comfortable street ride and aggressive track cornering. 16-level linear damping adjustment with full-length ride height adjustability.',
  ),
];

final List<MechanicModel> kSeedMechanics = [
  const MechanicModel(
    id: 'm1',
    name: 'Apex Dyno Lab',
    location: 'Pannipitiya, Colombo',
    specialty: 'Dyno Tuning',
    rating: '4.96',
    reviews: 84,
    basePrice: 'LKR 18,500',
    tags: ['4WD Rolling Road', 'Link / Haltech ECU', 'Boost Leak Test'],
    availability: 'Next Slot: Tomorrow 10:00 AM',
  ),
  const MechanicModel(
    id: 'm2',
    name: 'K-Series Works SL',
    location: 'Nawala, Rajagiriya',
    specialty: 'Engine Builds',
    rating: '4.92',
    reviews: 61,
    basePrice: 'LKR 15,000',
    tags: ['Honda K20 / B18', 'Forged Internals', 'LSD Gearbox'],
    availability: 'Next Slot: Wed 2:30 PM',
  ),
  const MechanicModel(
    id: 'm3',
    name: 'MotoSpec Garage',
    location: 'Dehiwala, Marine Drive',
    specialty: 'Superbike Tech',
    rating: '4.95',
    reviews: 53,
    basePrice: 'LKR 12,000',
    tags: ['Kawasaki / Ducati', 'Woolich ECU Flash', 'Valve Clearance'],
    availability: 'Next Slot: Today 4:00 PM',
  ),
];

final List<MeetModel> kSeedMeets = [
  const MeetModel(
    id: 'mt1',
    pinId: 'portcity',
    title: 'Port City Midnight JDM & Bike Meet',
    date: 'Sat, 14 Nov · 9:30 PM',
    location: 'Port City Marina Promenade, Colombo 01',
    host: 'Colombo JDM Syndicate',
    going: 74,
    pinTopRatio: 0.32,
    pinLeftRatio: 0.28,
    pinLabel: 'Port City',
  ),
  const MeetModel(
    id: 'mt2',
    pinId: 'kottawa',
    title: 'Southern Expressway Dawn Run',
    date: 'Sun, 22 Nov · 5:30 AM',
    location: 'Kottawa Interchange Park, Western Province',
    host: 'Apex Superbike Syndicate',
    going: 46,
    pinTopRatio: 0.58,
    pinLeftRatio: 0.52,
    pinLabel: 'Kottawa E01',
  ),
  const MeetModel(
    id: 'mt3',
    pinId: 'katukurunda',
    title: 'Katukurunda Open Track Day & Paddock Meet',
    date: 'Sun, 29 Nov · 8:00 AM',
    location: 'SLAF Katukurunda Race Track, Kalutara',
    host: 'Track Club Ceylon',
    going: 112,
    pinTopRatio: 0.82,
    pinLeftRatio: 0.36,
    pinLabel: 'Katukurunda',
  ),
];

final List<CrewModel> kSeedCrews = [
  const CrewModel(
    id: 'c1',
    name: 'Colombo JDM Syndicate',
    members: 84,
    focus: 'JDM Cars (Type-R, Evo, Silvia)',
    location: 'Colombo',
  ),
  const CrewModel(
    id: 'c2',
    name: 'VTEC Club Sri Lanka',
    members: 128,
    focus: 'Honda K-Series & B-Series',
    location: 'Islandwide',
  ),
  const CrewModel(
    id: 'c3',
    name: 'Apex Superbike Syndicate',
    members: 56,
    focus: '600cc+ Track & Sportbikes',
    location: 'Western Province',
  ),
];
