import 'package:flutter/material.dart';
import 'package:apexgarage_sl/features/apex_garage/core/models/app_models.dart';

class GarageAppState extends ChangeNotifier {
  // Navigation & Studio State
  int _currentScreen = 1;
  int get currentScreen => _currentScreen;

  String _viewMode = 'all_10'; // 'all_10' | 'pair_view'
  String get viewMode => _viewMode;

  int _activePairIndex = 2; // Pair 03 Search & Filter default
  int get activePairIndex => _activePairIndex;

  void setCurrentScreen(int screen) {
    _currentScreen = screen;
    _activePairIndex = (screen - 1) ~/ 2;
    notifyListeners();
  }

  void setViewMode(String mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void setActivePairIndex(int idx) {
    _activePairIndex = idx;
    _viewMode = 'pair_view';
    notifyListeners();
  }

  void jumpToScreen(int screen) {
    _currentScreen = screen;
    _activePairIndex = (screen - 1) ~/ 2;
    _viewMode = 'pair_view';
    notifyListeners();
  }

  // --- Screen 01 State ---
  List<String> selectedCultures = ['JDM Cars', 'Superbikes', 'Time Attack'];
  List<String> onboardBrands = ['Nissan', 'Porsche', 'Honda', 'Kawasaki'];

  void toggleCulture(String culture) {
    if (selectedCultures.contains(culture)) {
      selectedCultures.remove(culture);
    } else {
      selectedCultures.add(culture);
    }
    notifyListeners();
  }

  void toggleMarque(String brand) {
    if (onboardBrands.contains(brand)) {
      onboardBrands.remove(brand);
    } else {
      onboardBrands.add(brand);
    }
    notifyListeners();
  }

  // --- Screen 02 State ---
  String authPhone = '077 452 8910';
  String quickVehicleType = 'Car';
  String quickChassis = 'Silvia S15';

  void setAuthPhone(String phone) {
    authPhone = phone;
    notifyListeners();
  }

  void setQuickVehicleType(String type) {
    quickVehicleType = type;
    notifyListeners();
  }

  void setQuickChassis(String chassis) {
    quickChassis = chassis;
    notifyListeners();
  }

  // --- Screen 03 State ---
  String garageFilter = 'All Builds (3)';
  String selectedGarageId = 's15';

  void setGarageFilter(String filter) {
    garageFilter = filter;
    notifyListeners();
  }

  void setSelectedGarageId(String id) {
    selectedGarageId = id;
    notifyListeners();
  }

  // --- Screen 04 State ---
  double modMinCost = 150;
  double modMaxCost = 2400;
  List<String> modCategories = ['Engine & Turbo', 'ECU / Dyno'];
  String newModTitle = '';

  List<BuildLogModel> garageLogs = [
    const BuildLogModel(
      stage: 'Stage 2+',
      title: 'HKS GTIII-RS Turbo & Link G4X Standalone Tune',
      shop: 'Apex Dyno Lab • Nawala',
      gain: '+95 WHP',
      cost: 'LKR 485k',
    ),
    const BuildLogModel(
      stage: 'Stage 2',
      title: 'Ohlins Road & Track DFV Coilovers',
      shop: 'K-Series Works • Rathmalana',
      gain: '-1.8s Lap',
      cost: 'LKR 340k',
    ),
  ];

  void setModCostRange(double min, double max) {
    modMinCost = min;
    modMaxCost = max;
    notifyListeners();
  }

  void toggleModCategory(String category) {
    if (modCategories.contains(category)) {
      modCategories.remove(category);
    } else {
      modCategories.add(category);
    }
    notifyListeners();
  }

  void setNewModTitle(String title) {
    newModTitle = title;
    notifyListeners();
  }

  void publishNewMod() {
    if (newModTitle.trim().isNotEmpty) {
      garageLogs.insert(
        0,
        BuildLogModel(
          stage: 'Stage 3',
          title: newModTitle.trim(),
          shop: 'Apex Dyno Lab • Nawala',
          gain: '+35 WHP',
          cost: 'LKR 210k',
          loggedAt: DateTime.now(),
        ),
      );
      newModTitle = '';
      notifyListeners();
    }
  }

  // --- Screen 05 State ---
  String marketSearch = '';
  List<String> recentSearches = [
    'Broadway / Port City Meet',
    'RB26DETT Ignition Coils',
    'FD2 Brembo Front Calipers',
  ];

  void setMarketSearch(String query) {
    marketSearch = query;
    notifyListeners();
  }

  void removeRecentSearch(String item) {
    recentSearches.remove(item);
    notifyListeners();
  }

  // --- Screen 06 State ---
  List<String> filterBrands = ['Porsche', 'Corvette', 'Ferrari'];
  double minPrice = 200;
  double maxPrice = 2600;
  String rentalType = 'Long-term';
  List<String> filterFeatures = ['Air Conditioner', 'Gas'];

  void toggleFilterBrand(String brand) {
    if (filterBrands.contains(brand)) {
      filterBrands.remove(brand);
    } else {
      filterBrands.add(brand);
    }
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    minPrice = min;
    maxPrice = max;
    notifyListeners();
  }

  void setRentalType(String type) {
    rentalType = type;
    notifyListeners();
  }

  void toggleFilterFeature(String feature) {
    if (filterFeatures.contains(feature)) {
      filterFeatures.remove(feature);
    } else {
      filterFeatures.add(feature);
    }
    notifyListeners();
  }

  void clearFilterAll() {
    filterBrands.clear();
    filterFeatures.clear();
    minPrice = 50;
    maxPrice = 3400;
    notifyListeners();
  }

  // --- Screen 07 State ---
  String shopSpecFilter = 'Dyno Tuning';

  void setShopSpecFilter(String spec) {
    shopSpecFilter = spec;
    notifyListeners();
  }

  // --- Screen 08 State ---
  String selectedCrew = 'Colombo JDM Crew';
  bool rsvpConfirmed = true;

  void setSelectedCrew(String crew) {
    selectedCrew = crew;
    notifyListeners();
  }

  void toggleRsvp() {
    rsvpConfirmed = !rsvpConfirmed;
    notifyListeners();
  }

  // --- Screen 09 State ---
  String feedTopic = 'All Activity';
  bool likedPost = true;

  void setFeedTopic(String topic) {
    feedTopic = topic;
    notifyListeners();
  }

  void toggleLikedPost() {
    likedPost = !likedPost;
    notifyListeners();
  }

  // --- Screen 10 State ---
  String subPlan = 'Monthly PRO • LKR 490';
  String carrierNetwork = 'Dialog 077 / 076';
  String dialogNumber = '077 452 8910';
  bool otpSubscribed = false;

  void setSubPlan(String plan) {
    subPlan = plan;
    notifyListeners();
  }

  void setCarrierNetwork(String net) {
    carrierNetwork = net;
    notifyListeners();
  }

  void setDialogNumber(String num) {
    dialogNumber = num;
    notifyListeners();
  }

  void toggleOtpSubscribed() {
    otpSubscribed = !otpSubscribed;
    notifyListeners();
  }
}
