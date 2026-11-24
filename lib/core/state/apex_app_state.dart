import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:apexgarage_sl/core/models/app_models.dart';
import 'package:apexgarage_sl/core/services/api_repository.dart';

class ApexAppState extends ChangeNotifier {
  ApexAppState({ApiRepository? apiRepository})
      : _api = apiRepository ?? ApiRepository() {
    _restoreFuture = restoreSession();
  }

  final ApiRepository _api;

  // Backend Session & Loading State
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isSeller = false;
  bool get isSeller => _isSeller;

  String _sellerTab = 'dashboard';
  String get sellerTab => _sellerTab;

  ApiSellerDashboard? _sellerDashboard;
  ApiSellerDashboard? get sellerDashboard => _sellerDashboard;

  bool _isSellerLoading = false;
  bool get isSellerLoading => _isSellerLoading;

  String? _sellerError;
  String? get sellerError => _sellerError;

  bool _needsOnboarding = false;
  Future<void>? _restoreFuture;

  bool _isAuthLoading = false;
  bool get isAuthLoading => _isAuthLoading;

  String? _authError;
  String? get authError => _authError;

  ApiPromotion? activePromotion;
  List<SponsoredAdModel> sponsoredAds = [];
  List<CrewLiveRider> liveCrewRiders = [];
  bool isRidingLive = false;

  // Navigation Stages
  String _stage = 'splash'; // 'splash' | 'auth' | 'onboarding' | 'app'
  String get stage => _stage;

  int _onboardingStep = 0;
  int get onboardingStep => _onboardingStep;

  // Auth State
  String _authMode = 'signin';
  String get authMode => _authMode;

  String authIdentifier = '';
  String authPassword = '';
  String authName = '';
  List<String> selectedCultures = ['JDM Cars', 'Superbikes'];

  // Bottom Nav Bar Tab
  String _activeTab =
      'home'; // 'home' | 'garage' | 'market' | 'meets' | 'profile'
  String get activeTab => _activeTab;

  // Active Vehicle Context (Drives Home Tab)
  String _activeContextVehicleId = 'v1';
  String get activeContextVehicleId => _activeContextVehicleId;

  VehicleModel get activeContextVehicle {
    try {
      return _vehicles.firstWhere((v) => v.id == _activeContextVehicleId);
    } catch (_) {
      return _vehicles.isNotEmpty ? _vehicles.first : kSeedVehicles.first;
    }
  }

  // Garage Fleet & Detail
  List<VehicleModel> _vehicles = List.from(kSeedVehicles);
  List<VehicleModel> get vehicles => _vehicles;

  String _garageFilter = 'All'; // 'All' | 'Cars' | 'Bikes'
  String get garageFilter => _garageFilter;

  String? _selectedVehicleId;
  String? get selectedVehicleId => _selectedVehicleId;

  VehicleModel? get selectedVehicle {
    if (_selectedVehicleId == null) return null;
    try {
      return _vehicles.firstWhere((v) => v.id == _selectedVehicleId);
    } catch (_) {
      return null;
    }
  }

  String _vehicleDetailTab =
      'Build Showcase'; // 'Build Showcase' | 'Service Glovebox'
  String get vehicleDetailTab => _vehicleDetailTab;

  int get totalBuildLogsCount =>
      _vehicles.fold(0, (sum, v) => sum + v.logs.length);
  int get totalServiceRecordsCount =>
      _vehicles.fold(0, (sum, v) => sum + v.serviceRecords.length);

  // Community Feed
  List<CommunityFeedPost> communityFeed = List.from(kSeedCommunityFeed);

  // Marketplace
  String _marketSubTab = 'Parts'; // 'Parts' | 'Mechanics'
  String get marketSubTab => _marketSubTab;

  List<PartModel> _parts = List.from(kSeedParts);
  List<PartModel> get parts => _parts;

  String? _selectedPartId;
  String? get selectedPartId => _selectedPartId;

  PartModel? get selectedPart {
    if (_selectedPartId == null) return null;
    try {
      return _parts.firstWhere((p) => p.id == _selectedPartId);
    } catch (_) {
      return null;
    }
  }

  Set<String> savedPartIds = {'p1'};
  String searchQuery = '';
  List<String> recentSearches = [
    'FD2 Brembo Calipers',
    'SR20DET Garrett Turbo',
    'ZX-4RR Akrapovic',
  ];

  // Marketplace Histogram Filter
  List<String> filterBrands = [];
  double minPrice = 15000;
  double maxPrice = 450000;
  String filterCondition = '';
  List<String> filterTrust = [];

  // Seller Chat
  List<ChatMessage> chatMessages = [
    ChatMessage(
      from: 'seller',
      text:
          'Ayubowan! Item is in stock in Colombo 05. Let me know your chassis code.',
    ),
  ];

  // Mechanics
  List<MechanicModel> mechanics = List.from(kSeedMechanics);
  String mechanicFilter = 'All';
  MechanicModel? bookingMechanic;
  bool bookingConfirmed = false;

  // Meets & Map
  String _meetsSubTab = 'Upcoming Meets'; // 'Upcoming Meets' | 'Crews'
  String get meetsSubTab => _meetsSubTab;

  List<MeetModel> _meets = List.from(kSeedMeets);
  List<MeetModel> get meets => _meets;

  String _activePinId = 'portcity';
  String get activePinId => _activePinId;

  Set<String> rsvpMeetIds = {'mt1'};
  Set<String> joinedCrewIds = {'c1'};
  List<CrewModel> crews = List.from(kSeedCrews);

  // Profile & IdeaBiz PRO
  bool _isPro = false;
  bool get isPro => _isPro;

  String billingPlan = 'monthly'; // 'weekly' | 'monthly'
  String dialogNumber = '077 458 2910';
  String otpCode = '8492';
  int billingStep = 1;

  // ==========================================================================
  // ACTIONS & MUTATIONS
  // ==========================================================================

  void setStage(String s) {
    _stage = s;
    notifyListeners();
  }

  void setOnboardingStep(int step) {
    _onboardingStep = step;
    notifyListeners();
  }

  void setAuthMode(String mode) {
    _authMode = mode;
    notifyListeners();
  }

  void toggleCulture(String c) {
    if (selectedCultures.contains(c)) {
      selectedCultures.remove(c);
    } else {
      selectedCultures.add(c);
    }
    notifyListeners();
  }

  void setActiveTab(String tab) {
    _activeTab = tab;
    _selectedVehicleId = null;
    _selectedPartId = null;
    notifyListeners();
  }

  void setActiveContextVehicleId(String id) {
    _activeContextVehicleId = id;
    notifyListeners();
    final parsedId = int.tryParse(id);
    if (_isAuthenticated && parsedId != null) {
      unawaited(_api.setActiveVehicle(parsedId).catchError((_) {}));
    }
  }

  void setGarageFilter(String filter) {
    _garageFilter = filter;
    notifyListeners();
  }

  void selectVehicle(String? id) {
    _selectedVehicleId = id;
    notifyListeners();
  }

  void setVehicleDetailTab(String tab) {
    _vehicleDetailTab = tab;
    notifyListeners();
  }

  void toggleFeedLike(String id) {
    final idx = communityFeed.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final post = communityFeed[idx];
      final newLiked = !post.liked;
      communityFeed[idx] = post.copyWith(
        liked: newLiked,
        likes: newLiked ? post.likes + 1 : post.likes - 1,
      );
      notifyListeners();
      if (_isAuthenticated && int.tryParse(id) != null) {
        unawaited(_api.setPostLike(id, newLiked).then((serverLikes) {
          final currentIdx = communityFeed.indexWhere((p) => p.id == id);
          if (currentIdx != -1) {
            communityFeed[currentIdx] =
                communityFeed[currentIdx].copyWith(likes: serverLikes);
            notifyListeners();
          }
        }).catchError((_) {}));
      }
    }
  }

  Future<void> addVehicle({
    required String type,
    required String make,
    required String model,
    required String chassis,
    required String power,
    String? year,
    String? mileage,
    File? photoFile,
  }) async {
    String? uploadedUrl;
    if (_isAuthenticated && photoFile != null) {
      try {
        uploadedUrl = await _api.uploadMedia(photoFile, folder: 'vehicles');
      } catch (_) {}
    }

    final isBike = type == 'Bike';
    final currentKm =
        int.tryParse((mileage ?? '50000').replaceAll(',', '')) ?? 50000;
    final newV = VehicleModel(
      id: 'v_${DateTime.now().millisecondsSinceEpoch}',
      category: type,
      brand: make,
      shortContextLabel: '$make $model',
      title: '$make $model',
      subtitle:
          '${year ?? "2015"} · $chassis · WP CBO-${1000 + _vehicles.length}',
      watermark: model.toUpperCase(),
      illustration: isBike ? 'zx4rr' : 'fd2',
      photoUrl: uploadedUrl,
      stageBadge: 'Active Build',
      status: 'Health OK',
      statusTone: 'emerald',
      year: year ?? '2015',
      chassis: chassis,
      engineCode: chassis,
      engine: isBike ? 'Inline Engine' : 'Performance Engine',
      currentMileage: currentKm,
      lastServiceMileage: currentKm,
      serviceInterval: 5000,
      nextServiceMileage: currentKm + 5000,
      nextServiceDate: 'Next Year',
      powerValue: power,
      powerUnit: isBike ? 'HP' : 'WHP',
      torqueValue: isBike ? '42 Nm' : '220 Nm',
      estimatedValueLkr: 8500000,
      specs: [
        SpecItem(icon: LucideIcons.gauge, label: '$currentKm km'),
        const SpecItem(icon: LucideIcons.zap, label: 'Tuned'),
        const SpecItem(icon: LucideIcons.wrench, label: '0 Mods'),
      ],
      logs: [],
      serviceRecords: [],
    );
    _vehicles.insert(0, newV);
    _activeContextVehicleId = newV.id;
    notifyListeners();

    if (_isAuthenticated) {
      unawaited(_api.createVehicle({
        'category': type == 'Bike' ? 'Bike' : 'Car',
        'brand': make,
        'title': '$make $model',
        'subtitle': '$chassis · ${year ?? '2020'}',
        'watermark': chassis.toUpperCase(),
        'illustration': isBike ? 'zx4rr' : 'fd2',
        if (uploadedUrl != null) 'photo_url': uploadedUrl,
        'stage_badge': 'Active Build',
        'status': 'Good',
        'status_tone': 'emerald',
        'year': year ?? '2020',
        'chassis': chassis.toUpperCase(),
        'engine_code': chassis.toUpperCase(),
        'engine': isBike ? '399cc Inline-4' : '2.0L DOHC',
        'current_mileage': currentKm,
        'next_service_mileage': currentKm + 5000,
        'power_value': power,
        'power_unit': 'WHP',
        'torque_value': isBike ? '39 Nm' : '220 Nm',
        'estimated_value_lkr': 12000000,
      }).then((created) {
        final idx = _vehicles.indexWhere((v) => v.id == newV.id);
        if (idx != -1) {
          _vehicles[idx] = created;
          if (_activeContextVehicleId == newV.id) {
            _activeContextVehicleId = created.id;
          }
          notifyListeners();
        }
      }).catchError((_) {}));
    }
  }

  Future<void> addBuildLog({
    required String vehicleId,
    required String category,
    required String title,
    required String brand,
    required int cost,
    required String mechanic,
    required String notes,
    File? photoFile,
    bool shareToFeed = true,
  }) async {
    String? uploadedUrl;
    if (_isAuthenticated && photoFile != null) {
      try {
        uploadedUrl = await _api.uploadMedia(photoFile, folder: 'builds');
      } catch (_) {}
    }

    var entry = BuildLogEntry(
      id: 'l_${DateTime.now().millisecondsSinceEpoch}',
      date: 'Today, Nov 2026',
      category: category,
      title: title,
      brand: brand,
      cost: cost,
      mechanic: mechanic,
      notes: notes,
      photoLabel: uploadedUrl != null ? 'Build Photo Uploaded' : 'Receipt & Fitment Verified',
      photoUrl: uploadedUrl,
    );

    if (_isAuthenticated && int.tryParse(vehicleId) != null) {
      try {
        entry = await _api.addBuildLog(vehicleId, {
          'category': category,
          'title': title,
          'brand': brand,
          'cost_lkr': cost,
          'mechanic': mechanic,
          'notes': notes,
          'photo_label': uploadedUrl != null ? 'Build Photo Uploaded' : 'Receipt & Fitment Verified',
          if (uploadedUrl != null) 'photo_url': uploadedUrl,
          'share_to_feed': shareToFeed,
        });
        if (shareToFeed) {
          final feedRes = await _api.fetchFeed();
          communityFeed = feedRes.posts;
        }
      } catch (_) {}
    }

    final idx = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (idx != -1) {
      final v = _vehicles[idx];
      final updatedLogs = [entry, ...v.logs];
      _vehicles[idx] = VehicleModel(
        id: v.id,
        category: v.category,
        brand: v.brand,
        shortContextLabel: v.shortContextLabel,
        title: v.title,
        subtitle: v.subtitle,
        watermark: v.watermark,
        illustration: v.illustration,
        stageBadge: v.stageBadge,
        status: v.status,
        statusTone: v.statusTone,
        year: v.year,
        chassis: v.chassis,
        engineCode: v.engineCode,
        engine: v.engine,
        currentMileage: v.currentMileage,
        lastServiceMileage: v.lastServiceMileage,
        serviceInterval: v.serviceInterval,
        nextServiceMileage: v.nextServiceMileage,
        nextServiceDate: v.nextServiceDate,
        powerValue: v.powerValue,
        powerUnit: v.powerUnit,
        torqueValue: v.torqueValue,
        estimatedValueLkr: v.estimatedValueLkr,
        specs: [
          v.specs[0],
          if (v.specs.length > 1)
            v.specs[1]
          else
            SpecItem(icon: LucideIcons.zap, label: v.torqueValue),
          SpecItem(
              icon: LucideIcons.wrench, label: '${updatedLogs.length} Mods'),
        ],
        logs: updatedLogs,
        serviceRecords: v.serviceRecords,
      );
      notifyListeners();
    }
  }

  void addServiceRecord({
    required String vehicleId,
    required String title,
    required String details,
    required int odometer,
    required int nextServiceKm,
    required String nextDate,
    required int cost,
    required List<String> partsChanged,
    required String workshop,
  }) {
    final rec = ServiceRecord(
      id: 'sr_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      date: 'Today, Nov 2026',
      odometer: odometer,
      workshop: workshop,
      partsChanged: partsChanged,
      cost: cost,
      nextServiceKm: nextServiceKm,
      nextServiceDate: nextDate,
      notes: details,
      receiptLabel:
          'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}.webp · 184 KB',
    );

    final idx = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (idx != -1) {
      final v = _vehicles[idx];
      final updatedRecords = [rec, ...v.serviceRecords];
      final kmLeft = nextServiceKm - odometer;
      final isUrgent = kmLeft <= 1000;

      _vehicles[idx] = VehicleModel(
        id: v.id,
        category: v.category,
        brand: v.brand,
        shortContextLabel: v.shortContextLabel,
        title: v.title,
        subtitle: v.subtitle,
        watermark: v.watermark,
        illustration: v.illustration,
        stageBadge: v.stageBadge,
        status: isUrgent ? 'Due Soon' : 'Health OK',
        statusTone: isUrgent ? 'amber' : 'emerald',
        year: v.year,
        chassis: v.chassis,
        engineCode: v.engineCode,
        engine: v.engine,
        currentMileage: odometer,
        lastServiceMileage: odometer,
        serviceInterval: v.serviceInterval,
        nextServiceMileage: nextServiceKm,
        nextServiceDate: nextDate,
        powerValue: v.powerValue,
        powerUnit: v.powerUnit,
        torqueValue: v.torqueValue,
        estimatedValueLkr: v.estimatedValueLkr,
        specs: [
          SpecItem(
            icon: LucideIcons.gauge,
            label:
                '${odometer.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")} km',
          ),
          v.specs.length > 1
              ? v.specs[1]
              : SpecItem(icon: LucideIcons.zap, label: v.torqueValue),
          SpecItem(icon: LucideIcons.wrench, label: '${v.logs.length} Mods'),
        ],
        logs: v.logs,
        serviceRecords: updatedRecords,
      );
      notifyListeners();
    }
  }

  // Marketplace Actions
  void setMarketSubTab(String subTab) {
    _marketSubTab = subTab;
    notifyListeners();
  }

  void selectPart(String? id) {
    _selectedPartId = id;
    notifyListeners();
  }

  void toggleSavePart(String id) {
    final willSave = !savedPartIds.contains(id);
    if (willSave) {
      savedPartIds.add(id);
    } else {
      savedPartIds.remove(id);
    }
    notifyListeners();
    if (_isAuthenticated && int.tryParse(id) != null) {
      unawaited(_api.setPartSaved(id, willSave).catchError((_) => willSave));
    }
  }

  void setSearchQuery(String q) {
    searchQuery = q;
    notifyListeners();
  }

  void removeRecentSearch(String item) {
    recentSearches.remove(item);
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    minPrice = min;
    maxPrice = max;
    notifyListeners();
  }

  void toggleFilterBrand(String brand) {
    if (filterBrands.contains(brand)) {
      filterBrands.remove(brand);
    } else {
      filterBrands.add(brand);
    }
    notifyListeners();
  }

  void resetFilter() {
    filterBrands.clear();
    minPrice = 15000;
    maxPrice = 450000;
    filterCondition = '';
    filterTrust.clear();
    notifyListeners();
  }

  void addChatMessage(String msg) {
    chatMessages.add(ChatMessage(from: 'me', text: msg));
    notifyListeners();

    final partId = _selectedPartId;
    if (_isAuthenticated && partId != null && int.tryParse(partId) != null) {
      unawaited(_api
          .sendPartChat(partId, msg)
          .catchError((_) => ChatMessage(from: 'me', text: msg)));
      return;
    }

    // Offline / guest simulated seller reply
    Future.delayed(const Duration(milliseconds: 600), () {
      chatMessages.add(ChatMessage(
        from: 'seller',
        text: 'Sounds good! We can arrange pickup today or courier islandwide.',
      ));
      notifyListeners();
    });
  }

  Future<void> addPart({
    required String title,
    required String brand,
    required String fitment,
    required int price,
    required String condition,
    File? photoFile,
  }) async {
    String? uploadedUrl;
    if (_isAuthenticated && photoFile != null) {
      try {
        uploadedUrl = await _api.uploadMedia(photoFile, folder: 'parts');
      } catch (_) {}
    }

    final newP = PartModel(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      brand: brand,
      title: title,
      subtitle: '$fitment · Fresh Listing',
      watermark: brand.toUpperCase(),
      illustration: 'turbo',
      photoUrl: uploadedUrl,
      price: price,
      condition: condition,
      trust: const ['Verified Seller', 'Islandwide Delivery'],
      seller: authName.isNotEmpty ? authName : 'Member Seller',
      location: 'Colombo',
      rating: '5.0',
      verified: isPro,
      specs: [
        SpecItem(
            icon: LucideIcons.shieldCheck,
            label: isPro ? 'Verified' : 'Member'),
        const SpecItem(icon: LucideIcons.mapPin, label: 'Colombo'),
        SpecItem(
            icon: LucideIcons.tag,
            label: condition == 'Brand New' ? 'New' : 'Used'),
      ],
      description:
          'Listed directly by ${authName.isNotEmpty ? authName : 'Member'} for $fitment. Available for inspection in Colombo.',
    );
    _parts.insert(0, newP);
    notifyListeners();

    if (_isAuthenticated) {
      try {
        final created = await _api.createPart({
          'brand': brand,
          'title': title,
          'subtitle': fitment,
          'fitment': fitment,
          'watermark': brand
              .toUpperCase()
              .substring(0, brand.length >= 4 ? 4 : brand.length),
          'illustration': 'turbo',
          if (uploadedUrl != null) 'photo_url': uploadedUrl,
          'price_lkr': price,
          'condition': condition,
          'location': 'Colombo',
          'description':
              'Listed directly by ${authName.isNotEmpty ? authName : 'Member'} for $fitment.',
        });
        final idx = _parts.indexWhere((p) => p.id == newP.id);
        if (idx != -1) {
          _parts[idx] = created;
          notifyListeners();
        }
      } catch (_) {}
    }
  }

  // Mechanics Actions
  void setMechanicFilter(String f) {
    mechanicFilter = f;
    notifyListeners();
  }

  void bookMechanic(MechanicModel m) {
    bookingMechanic = m;
    bookingConfirmed = false;
    notifyListeners();
  }

  void confirmBooking() {
    bookingConfirmed = true;
    notifyListeners();
    final workshop = bookingMechanic;
    if (_isAuthenticated &&
        workshop != null &&
        int.tryParse(workshop.id) != null) {
      unawaited(_api
          .bookWorkshop(
            workshopId: workshop.id,
            serviceKey: 'dyno',
            slot: 'Tomorrow · 10:00 AM',
            vehicleId: _activeContextVehicleId,
          )
          .catchError((_) {}));
    }
  }

  // Meets Actions
  void setMeetsSubTab(String subTab) {
    _meetsSubTab = subTab;
    notifyListeners();
  }

  void setActivePinId(String pinId) {
    _activePinId = pinId;
    notifyListeners();
  }

  void toggleMeetRsvp(String meetId) {
    final already = rsvpMeetIds.contains(meetId);
    if (already) {
      rsvpMeetIds.remove(meetId);
    } else {
      rsvpMeetIds.add(meetId);
    }

    _meets = _meets.map((m) {
      if (m.id == meetId) {
        return MeetModel(
          id: m.id,
          pinId: m.pinId,
          title: m.title,
          date: m.date,
          location: m.location,
          host: m.host,
          going: already ? m.going - 1 : m.going + 1,
          pinTopRatio: m.pinTopRatio,
          pinLeftRatio: m.pinLeftRatio,
          pinLabel: m.pinLabel,
        );
      }
      return m;
    }).toList();

    notifyListeners();
    if (_isAuthenticated && int.tryParse(meetId) != null) {
      unawaited(_api.setMeetRsvp(meetId, !already).catchError((_) => 0));
    }
  }

  void toggleJoinCrew(String crewId) {
    final willJoin = !joinedCrewIds.contains(crewId);
    if (willJoin) {
      joinedCrewIds.add(crewId);
    } else {
      joinedCrewIds.remove(crewId);
    }
    notifyListeners();
    if (_isAuthenticated && int.tryParse(crewId) != null) {
      unawaited(_api.setCrewMembership(crewId, willJoin).catchError((_) => 0));
    }
  }

  void createCrew({
    required String name,
    required String focus,
    required String location,
  }) {
    final newC = CrewModel(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      members: 1,
      focus: focus,
      location: location,
    );
    crews.insert(0, newC);
    joinedCrewIds.add(newC.id);
    notifyListeners();

    if (_isAuthenticated) {
      unawaited(_api
          .createCrew(
        name: name,
        focus: focus,
        location: location,
      )
          .then((created) {
        final idx = crews.indexWhere((c) => c.id == newC.id);
        if (idx != -1) {
          crews[idx] = created;
          joinedCrewIds.remove(newC.id);
          joinedCrewIds.add(created.id);
          notifyListeners();
        }
      }).catchError((_) {}));
    }
  }

  void createMeet({
    required String title,
    required String location,
    String? date,
    String? description,
    double? latitude,
    double? longitude,
  }) {
    final resolvedLat = latitude ?? 6.9271;
    final resolvedLng = longitude ?? 79.8612;
    final resolvedDate = (date != null && date.trim().isNotEmpty)
        ? date.trim()
        : 'Fri, 20 Nov · 8:30 PM';

    final newM = MeetModel(
      id: 'mt_${DateTime.now().millisecondsSinceEpoch}',
      pinId: 'portcity',
      title: title,
      date: resolvedDate,
      location: location.isEmpty ? 'Colombo' : location,
      host: authName,
      going: 1,
      pinTopRatio: 0.38,
      pinLeftRatio: 0.34,
      pinLabel: 'New Meet',
      latitude: resolvedLat,
      longitude: resolvedLng,
    );
    _meets.insert(0, newM);
    rsvpMeetIds.add(newM.id);
    notifyListeners();
    if (_isAuthenticated) {
      unawaited(_api
          .hostMeet(
        title: title,
        location: location.isEmpty ? 'Colombo' : location,
        eventDate: resolvedDate,
        description: description,
        latitude: resolvedLat,
        longitude: resolvedLng,
      )
          .then((created) {
        final idx = _meets.indexWhere((m) => m.id == newM.id);
        if (idx != -1) {
          _meets[idx] = created;
          rsvpMeetIds.remove(newM.id);
          rsvpMeetIds.add(created.id);
          notifyListeners();
        }
      }).catchError((_) {}));
    }
  }

  Future<void> refreshLiveCrewRiders() async {
    if (!_isAuthenticated) return;
    try {
      final riders = await _api.fetchLiveCrewRiders();
      liveCrewRiders = riders;
      isRidingLive = riders.any((r) => r.isMe && r.isRiding);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> toggleLiveRiding({
    required bool isRiding,
    String? vehicleId,
    double latitude = 6.9271,
    double longitude = 79.8612,
    String? statusNote,
  }) async {
    if (!_isAuthenticated) return false;
    try {
      await _api.updateLiveCrewPresence(
        isRiding: isRiding,
        latitude: latitude,
        longitude: longitude,
        vehicleId: vehicleId ?? _activeContextVehicleId,
        statusNote: statusNote,
      );
      isRidingLive = isRiding;
      await refreshLiveCrewRiders();
      return true;
    } catch (_) {
      return false;
    }
  }

  // IdeaBiz PRO Subscription
  void setBillingStep(int step) {
    billingStep = step;
    notifyListeners();
  }

  void setBillingPlan(String plan) {
    billingPlan = plan;
    notifyListeners();
  }

  void applyMarketplaceFilters({
    required double minPrice,
    required double maxPrice,
    required List<String> brands,
    required String condition,
  }) {
    this.minPrice = minPrice;
    this.maxPrice = maxPrice;
    filterBrands = List<String>.from(brands);
    filterCondition = condition;
    notifyListeners();
  }

  void subscribePro() {
    _isPro = true;
    billingStep = 3;
    notifyListeners();
  }

  void togglePro() {
    _isPro = !_isPro;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Backend API Synchronization & Auth Flows
  // ---------------------------------------------------------------------------

  Future<void> proceedFromSplash() async {
    if (_stage != 'splash') return;
    if (_restoreFuture != null) {
      await _restoreFuture;
    }
    if (_stage != 'splash') return;
    if (_isAuthenticated) {
      _stage = _needsOnboarding ? 'onboarding' : 'app';
    } else {
      _stage = 'auth';
    }
    notifyListeners();
  }

  Future<void> restoreSession() async {
    try {
      if (_api.hasToken) {
        final user = await _api.me();
        _applyUser(user);
        await refreshAll();
      } else {
        await refreshPublicData();
      }
    } catch (_) {
      _isAuthenticated = false;
      await refreshPublicData();
    }
  }

  Future<bool> signIn() async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final user = await _api.login(
        identifier: authIdentifier.trim(),
        password: authPassword,
      );
      _applyUser(user);
      await refreshAll();
      _isAuthLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _authError = e.message;
      _isAuthLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _authError = 'Unable to sign in right now. Please try again.';
      _isAuthLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp() async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final user = await _api.register(
        name: authName.trim(),
        identifier: authIdentifier.trim(),
        password: authPassword,
        cultures: selectedCultures,
      );
      _applyUser(user);
      await refreshAll();
      _isAuthLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _authError = e.message;
      _isAuthLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _authError = 'Unable to create account right now. Please try again.';
      _isAuthLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _api.logout();
    _isAuthenticated = false;
    _isSeller = false;
    _sellerDashboard = null;
    _sellerTab = 'dashboard';
    _sellerError = null;
    authName = '';
    authIdentifier = '';
    authPassword = '';
    _authError = null;
    _stage = 'auth';
    notifyListeners();
  }

  Future<void> saveOnboarding() async {
    if (!_isAuthenticated) return;
    try {
      await _api.updateOnboarding(
        cultures: selectedCultures,
        completed: true,
      );
    } catch (_) {}
  }

  Future<void> refreshAll() async {
    if (_isSeller) {
      await loadSellerDashboard();
      return;
    }
    try {
      final results = await Future.wait<dynamic>([
        _api.fetchHomeDashboard(),
        _api.fetchVehicles(),
        _api.fetchParts(),
        _api.fetchMechanics(),
        _api.fetchMeets(),
        _api.fetchCrews(),
      ]);

      final home = results[0] as ApiHomeDashboard;
      final fetchedVehicles = results[1] as List<VehicleModel>;
      final partsRes =
          results[2] as ({List<PartModel> parts, Set<String> savedIds});
      final fetchedMechanics = results[3] as List<MechanicModel>;
      final meetsRes =
          results[4] as ({List<MeetModel> meets, Set<String> rsvpedIds});
      final crewsRes =
          results[5] as ({List<CrewModel> crews, Set<String> joinedIds});

      _vehicles = fetchedVehicles;
      if (home.activeVehicle != null) {
        _activeContextVehicleId = home.activeVehicle!.id;
      } else if (_vehicles.isNotEmpty &&
          !_vehicles.any((v) => v.id == _activeContextVehicleId)) {
        _activeContextVehicleId = _vehicles.first.id;
      }
      _parts = partsRes.parts;
      savedPartIds = {...partsRes.savedIds, ...home.savedPartIds};
      mechanics = fetchedMechanics;
      _meets = meetsRes.meets;
      rsvpMeetIds = {...meetsRes.rsvpedIds, ...home.rsvpedMeetIds};
      crews = crewsRes.crews;
      joinedCrewIds = crewsRes.joinedIds;
      communityFeed = home.feedPosts;
      activePromotion = home.activePromotion;
      sponsoredAds = home.sponsoredAds;
      notifyListeners();
      unawaited(refreshLiveCrewRiders());
    } catch (_) {
      // Preserve existing/seed data if offline.
    }
  }

  Future<void> refreshPublicData() async {
    try {
      final results = await Future.wait<dynamic>([
        _api.fetchParts(),
        _api.fetchMechanics(),
        _api.fetchMeets(),
        _api.fetchCrews(),
        _api.fetchFeed(),
      ]);

      final partsRes =
          results[0] as ({List<PartModel> parts, Set<String> savedIds});
      final fetchedMechanics = results[1] as List<MechanicModel>;
      final meetsRes =
          results[2] as ({List<MeetModel> meets, Set<String> rsvpedIds});
      final crewsRes =
          results[3] as ({List<CrewModel> crews, Set<String> joinedIds});
      final feedRes =
          results[4] as ({List<CommunityFeedPost> posts, Set<String> likedIds});

      _parts = partsRes.parts;
      mechanics = fetchedMechanics;
      _meets = meetsRes.meets;
      crews = crewsRes.crews;
      communityFeed = feedRes.posts;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadPartChat(String partId) async {
    if (!_isAuthenticated || int.tryParse(partId) == null) return;
    try {
      final messages = await _api.fetchPartChat(partId);
      if (messages.isNotEmpty) {
        chatMessages = messages;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<bool> reserveSelectedPart({String? message}) async {
    final partId = _selectedPartId;
    if (!_isAuthenticated || partId == null || int.tryParse(partId) == null) {
      return false;
    }
    try {
      await _api.reservePart(partId, message: message);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _applyUser(ApiUser user) {
    _isAuthenticated = true;
    _isSeller = user.isSeller;
    _needsOnboarding = user.isSeller ? false : !user.onboardingCompleted;
    authName = user.name;
    authIdentifier = user.mobileNumber ?? user.email;
    if (user.cultures.isNotEmpty) {
      selectedCultures = List<String>.from(user.cultures);
    }
    if (user.activeVehicleId != null) {
      _activeContextVehicleId = user.activeVehicleId.toString();
    }
  }

  // ---------------------------------------------------------------------------
  // Shop Owner / Seller Mode Actions
  // ---------------------------------------------------------------------------

  void setSellerTab(String tab) {
    _sellerTab = tab;
    notifyListeners();
  }

  Future<void> loadSellerDashboard() async {
    if (!_isAuthenticated || !_isSeller) return;
    _isSellerLoading = true;
    _sellerError = null;
    notifyListeners();

    try {
      _sellerDashboard = await _api.fetchSellerDashboard();
    } on ApiException catch (e) {
      _sellerError = e.message;
    } catch (_) {
      _sellerError = 'Unable to load shop dashboard right now.';
    } finally {
      _isSellerLoading = false;
      notifyListeners();
    }
  }

  Future<List<FeedComment>> fetchFeedComments(String postId) async {
    if (int.tryParse(postId) == null) return const [];
    try {
      return await _api.fetchFeedComments(postId);
    } catch (_) {
      return const [];
    }
  }

  Future<FeedComment?> addFeedComment(String postId, String body) async {
    if (!_isAuthenticated || int.tryParse(postId) == null) return null;
    try {
      final res = await _api.postFeedComment(postId, body);
      final idx = communityFeed.indexWhere((p) => p.id == postId);
      if (idx != -1) {
        final p = communityFeed[idx];
        communityFeed[idx] = CommunityFeedPost(
          id: p.id,
          author: p.author,
          handle: p.handle,
          avatar: p.avatar,
          crew: p.crew,
          timeAgo: p.timeAgo,
          vehicleTitle: p.vehicleTitle,
          modTitle: p.modTitle,
          workshop: p.workshop,
          illustration: p.illustration,
          watermark: p.watermark,
          photoUrl: p.photoUrl,
          tags: p.tags,
          likes: p.likes,
          comments: res.commentsCount,
          liked: p.liked,
        );
        notifyListeners();
      }
      return res.comment;
    } catch (_) {
      return null;
    }
  }

  Future<bool> createSellerPart({
    required String title,
    required String brand,
    required String fitment,
    required int priceLkr,
    required int stock,
    required String condition,
    String illustration = 'turbo',
    String? description,
    File? photoFile,
  }) async {
    if (!_isAuthenticated || !_isSeller) return false;
    try {
      String? uploadedUrl;
      if (photoFile != null) {
        try {
          uploadedUrl = await _api.uploadMedia(photoFile, folder: 'parts');
        } catch (_) {}
      }
      final shopLocation = _sellerDashboard?.shop.location ?? 'Colombo';
      await _api.createPart({
        'brand': brand,
        'title': title,
        'subtitle': fitment,
        'fitment': fitment,
        'watermark': brand
            .toUpperCase()
            .substring(0, brand.length >= 4 ? 4 : brand.length),
        'illustration': illustration,
        if (uploadedUrl != null) 'photo_url': uploadedUrl,
        'price_lkr': priceLkr,
        'stock': stock,
        'condition': condition,
        'location': shopLocation,
        'description': (description == null || description.trim().isEmpty)
            ? '$title listed directly from shop mobile app.'
            : description.trim(),
      });
      await loadSellerDashboard();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateSellerPart({
    required String partId,
    required int priceLkr,
    required int stock,
    String? title,
    String? fitment,
  }) async {
    if (!_isAuthenticated || !_isSeller) return false;
    try {
      await _api.updateSellerPart(
        partId: partId,
        priceLkr: priceLkr,
        stock: stock,
        title: title,
        fitment: fitment,
      );
      await loadSellerDashboard();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> replySellerInquiry({
    required int inquiryId,
    required String message,
    String status = 'Replied',
  }) async {
    if (!_isAuthenticated || !_isSeller) return false;
    try {
      await _api.replySellerInquiry(
        inquiryId: inquiryId,
        message: message,
        status: status,
      );
      await loadSellerDashboard();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateSellerBooking({
    required int bookingId,
    required String status,
  }) async {
    if (!_isAuthenticated || !_isSeller) return false;
    try {
      await _api.updateSellerBooking(bookingId: bookingId, status: status);
      await loadSellerDashboard();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateSellerProfile({
    required String businessName,
    required String location,
    required String phone,
    required String specialty,
  }) async {
    if (!_isAuthenticated || !_isSeller) return false;
    try {
      await _api.updateSellerProfile(
        businessName: businessName,
        location: location,
        phone: phone,
        specialty: specialty,
      );
      await loadSellerDashboard();
      return true;
    } catch (_) {
      return false;
    }
  }
}
