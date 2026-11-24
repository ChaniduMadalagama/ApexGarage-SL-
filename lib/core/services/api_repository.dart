import 'dart:io';

import 'package:apexgarage_sl/core/models/app_models.dart';
import 'package:apexgarage_sl/core/services/token_storage.dart';
import 'package:apexgarage_sl/utils/network/client.dart';
import 'package:dio/dio.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiUser {
  final int id;
  final String name;
  final String email;
  final String? mobileNumber;
  final bool onboardingCompleted;
  final List<String> cultures;
  final int? activeVehicleId;
  final List<String> roles;
  final bool isSeller;
  final bool isAdmin;

  const ApiUser({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.onboardingCompleted,
    required this.cultures,
    required this.activeVehicleId,
    this.roles = const [],
    this.isSeller = false,
    this.isAdmin = false,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    final roles = (json['roles'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    return ApiUser(
      id: _asInt(json['id']),
      name: _asString(json['name'], 'Enthusiast'),
      email: _asString(json['email']),
      mobileNumber: json['mobile_number'] as String?,
      onboardingCompleted: json['onboarding_completed'] == true,
      cultures: (json['cultures'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      activeVehicleId: json['active_vehicle_id'] != null
          ? _asInt(json['active_vehicle_id'])
          : null,
      roles: roles,
      isSeller: json['is_seller'] == true || roles.contains('workshop-partner'),
      isAdmin: json['is_admin'] == true || roles.contains('super-admin'),
    );
  }
}

class ApiPromotion {
  final String partner;
  final String code;
  final String title;
  final String description;
  final List<String> participatingWorkshops;

  const ApiPromotion({
    required this.partner,
    required this.code,
    required this.title,
    required this.description,
    required this.participatingWorkshops,
  });

  factory ApiPromotion.fromJson(Map<String, dynamic> json) {
    return ApiPromotion(
      partner: _asString(json['partner']),
      code: _asString(json['code']),
      title: _asString(json['title']),
      description: _asString(json['description']),
      participatingWorkshops:
          (json['participating_workshops'] as List<dynamic>? ?? const [])
              .map((e) => e.toString())
              .toList(),
    );
  }
}

class ApiHomeDashboard {
  final VehicleModel? activeVehicle;
  final MeetModel? nextMeet;
  final List<PartModel> recommendedParts;
  final ApiPromotion? activePromotion;
  final List<SponsoredAdModel> sponsoredAds;
  final List<CommunityFeedPost> feedPosts;
  final Set<String> likedPostIds;
  final Set<String> savedPartIds;
  final Set<String> rsvpedMeetIds;

  const ApiHomeDashboard({
    required this.activeVehicle,
    required this.nextMeet,
    required this.recommendedParts,
    required this.activePromotion,
    this.sponsoredAds = const [],
    required this.feedPosts,
    required this.likedPostIds,
    required this.savedPartIds,
    required this.rsvpedMeetIds,
  });
}

class ApiSellerShop {
  final String businessName;
  final String ownerName;
  final String type;
  final String brNumber;
  final String location;
  final String phone;
  final String status;
  final String specialty;
  final List<String> documents;

  const ApiSellerShop({
    required this.businessName,
    required this.ownerName,
    required this.type,
    required this.brNumber,
    required this.location,
    required this.phone,
    required this.status,
    required this.specialty,
    required this.documents,
  });

  factory ApiSellerShop.fromJson(Map<String, dynamic> json) {
    return ApiSellerShop(
      businessName: _asString(json['business_name'], 'Verified Shop'),
      ownerName: _asString(json['owner_name']),
      type: _asString(json['type'], 'Verified Merchant'),
      brNumber: _asString(json['br_number'], 'Registered'),
      location: _asString(json['location'], 'Colombo'),
      phone: _asString(json['phone']),
      status: _asString(json['status'], 'Pending'),
      specialty: _asString(json['specialty']),
      documents: (json['documents'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class ApiSellerStats {
  final int listingsCount;
  final int approvedCount;
  final int pendingCount;
  final int totalViews;
  final int inquiriesCount;
  final int openInquiriesCount;
  final int bookingsCount;
  final int pendingBookingsCount;

  const ApiSellerStats({
    required this.listingsCount,
    required this.approvedCount,
    required this.pendingCount,
    required this.totalViews,
    required this.inquiriesCount,
    required this.openInquiriesCount,
    required this.bookingsCount,
    required this.pendingBookingsCount,
  });

  factory ApiSellerStats.fromJson(Map<String, dynamic> json) {
    return ApiSellerStats(
      listingsCount: _asInt(json['listings_count']),
      approvedCount: _asInt(json['approved_count']),
      pendingCount: _asInt(json['pending_count']),
      totalViews: _asInt(json['total_views']),
      inquiriesCount: _asInt(json['inquiries_count']),
      openInquiriesCount: _asInt(json['open_inquiries_count']),
      bookingsCount: _asInt(json['bookings_count']),
      pendingBookingsCount: _asInt(json['pending_bookings_count']),
    );
  }
}

class ApiSellerPart {
  final PartModel part;
  final String sku;
  final String fitment;
  final int stock;
  final String status;

  const ApiSellerPart({
    required this.part,
    required this.sku,
    required this.fitment,
    required this.stock,
    required this.status,
  });

  factory ApiSellerPart.fromJson(Map<String, dynamic> json) {
    return ApiSellerPart(
      part: ApiRepository.partFromJson(json),
      sku: _asString(json['sku']),
      fitment: _asString(json['fitment']),
      stock: _asInt(json['stock']),
      status: _asString(json['status'], 'Pending Review'),
    );
  }
}

class ApiSellerInquiry {
  final int id;
  final String buyerName;
  final String partTitle;
  final String vehicle;
  final int offerLkr;
  final String status;
  final String timeLabel;
  final List<ChatMessage> messages;

  const ApiSellerInquiry({
    required this.id,
    required this.buyerName,
    required this.partTitle,
    required this.vehicle,
    required this.offerLkr,
    required this.status,
    required this.timeLabel,
    required this.messages,
  });

  factory ApiSellerInquiry.fromJson(Map<String, dynamic> json) {
    return ApiSellerInquiry(
      id: _asInt(json['id']),
      buyerName: _asString(json['buyer_name'], 'Buyer'),
      partTitle: _asString(json['part_title']),
      vehicle: _asString(json['vehicle']),
      offerLkr: _asInt(json['offer_lkr']),
      status: _asString(json['status'], 'New Inquiry'),
      timeLabel: _asString(json['time_label'], 'Just now'),
      messages: (json['messages'] as List<dynamic>? ?? const [])
          .map((m) {
            final map = m as Map<String, dynamic>;
            return ChatMessage(
              from: _asString(map['sender'], 'buyer'),
              text: _asString(map['text']),
              time: DateTime.tryParse(_asString(map['time'])) ?? DateTime.now(),
            );
          })
          .toList(),
    );
  }
}

class ApiSellerBooking {
  final int id;
  final String customerName;
  final String vehicle;
  final String service;
  final String slotDate;
  final int estimateLkr;
  final String status;

  const ApiSellerBooking({
    required this.id,
    required this.customerName,
    required this.vehicle,
    required this.service,
    required this.slotDate,
    required this.estimateLkr,
    required this.status,
  });

  factory ApiSellerBooking.fromJson(Map<String, dynamic> json) {
    return ApiSellerBooking(
      id: _asInt(json['id']),
      customerName: _asString(json['customer_name'], 'Customer'),
      vehicle: _asString(json['vehicle']),
      service: _asString(json['service']),
      slotDate: _asString(json['slot_date']),
      estimateLkr: _asInt(json['estimate_lkr']),
      status: _asString(json['status'], 'Pending'),
    );
  }
}

class ApiSellerDashboard {
  final ApiSellerShop shop;
  final ApiSellerStats stats;
  final List<ApiSellerPart> parts;
  final List<ApiSellerInquiry> inquiries;
  final List<ApiSellerBooking> bookings;

  const ApiSellerDashboard({
    required this.shop,
    required this.stats,
    required this.parts,
    required this.inquiries,
    required this.bookings,
  });
}

class ApiRepository {
  ApiRepository({
    ApiClient? client,
    TokenStorage? tokenStorage,
  })  : _client = client ?? ApiClient(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final ApiClient _client;
  final TokenStorage _tokenStorage;

  bool get hasToken => _tokenStorage.getToken() != null;

  Future<ApiUser> login({
    required String identifier,
    required String password,
    String deviceName = 'apexgarage-mobile',
  }) async {
    try {
      final res = await _client.post('/api/v1/auth/login', data: {
        'identifier': identifier,
        'password': password,
        'device_name': deviceName,
      });
      final data = _asMap(res.data);
      final token = _asString(data['token']);
      if (token.isNotEmpty) {
        await _tokenStorage.saveToken(token);
      }
      return ApiUser.fromJson(_asMap(data['user']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ApiUser> register({
    required String name,
    required String identifier,
    required String password,
    required List<String> cultures,
    String deviceName = 'apexgarage-mobile',
  }) async {
    try {
      final res = await _client.post('/api/v1/auth/register', data: {
        'name': name,
        'identifier': identifier,
        'password': password,
        'cultures': cultures,
        'device_name': deviceName,
      });
      final data = _asMap(res.data);
      final token = _asString(data['token']);
      if (token.isNotEmpty) {
        await _tokenStorage.saveToken(token);
      }
      return ApiUser.fromJson(_asMap(data['user']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> logout() async {
    try {
      if (hasToken) {
        await _client.post('/api/v1/auth/logout');
      }
    } catch (_) {
      // Clear local token even if server revoke fails.
    } finally {
      await _tokenStorage.clearToken();
    }
  }

  Future<ApiUser> me() async {
    try {
      final res = await _client.get('/api/v1/auth/me');
      final data = _asMap(res.data);
      return ApiUser.fromJson(_asMap(data['user']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ApiUser> updateOnboarding({
    required List<String> cultures,
    bool completed = true,
  }) async {
    try {
      final res = await _client.patch('/api/v1/user/onboarding', data: {
        'cultures': cultures,
        'onboarding_completed': completed,
      });
      final data = _asMap(res.data);
      return ApiUser.fromJson(_asMap(data['user']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> setActiveVehicle(int vehicleId) async {
    try {
      await _client.patch('/api/v1/user/active-vehicle', data: {
        'vehicle_id': vehicleId,
      });
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ApiHomeDashboard> fetchHomeDashboard() async {
    try {
      final res = await _client.get('/api/v1/home');
      final data = _asMap(res.data);

      final activeVehicleJson = data['active_vehicle'];
      final nextMeetJson = data['next_meet'];
      final promoJson = data['active_promotion'];

      final partsList = (data['recommended_parts'] as List<dynamic>? ?? const []);
      final savedIds = <String>{};
      final parts = partsList.map((raw) {
        final m = _asMap(raw);
        final p = partFromJson(m);
        if (m['is_saved'] == true) savedIds.add(p.id);
        return p;
      }).toList();

      final postsList = (data['feed_posts'] as List<dynamic>? ?? const []);
      final likedIds = <String>{};
      final posts = postsList.map((raw) {
        final m = _asMap(raw);
        final p = feedPostFromJson(m);
        if (m['is_liked'] == true) likedIds.add(p.id);
        return p;
      }).toList();

      final rsvpedIds = <String>{};
      MeetModel? nextMeet;
      if (nextMeetJson is Map<String, dynamic>) {
        nextMeet = meetFromJson(nextMeetJson);
        if (nextMeetJson['is_attending'] == true) {
          rsvpedIds.add(nextMeet.id);
        }
      }

      final adsList = (data['sponsored_ads'] as List<dynamic>? ?? const []);
      final sponsoredAds = adsList.map((raw) {
        final m = _asMap(raw);
        return SponsoredAdModel(
          id: _asString(m['id']),
          sponsor: _asString(m['sponsor']),
          headline: _asString(m['headline']),
          placement: _asString(m['placement']),
        );
      }).toList();

      return ApiHomeDashboard(
        activeVehicle: activeVehicleJson is Map<String, dynamic>
            ? vehicleFromJson(activeVehicleJson)
            : null,
        nextMeet: nextMeet,
        recommendedParts: parts,
        activePromotion: promoJson is Map<String, dynamic>
            ? ApiPromotion.fromJson(promoJson)
            : null,
        sponsoredAds: sponsoredAds,
        feedPosts: posts,
        likedPostIds: likedIds,
        savedPartIds: savedIds,
        rsvpedMeetIds: rsvpedIds,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<List<VehicleModel>> fetchVehicles() async {
    try {
      final res = await _client.get('/api/v1/vehicles');
      final data = _asMap(res.data);
      final list = data['vehicles'] as List<dynamic>? ?? const [];
      return list.map((e) => vehicleFromJson(_asMap(e))).toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<VehicleModel> createVehicle(Map<String, dynamic> payload) async {
    try {
      final res = await _client.post('/api/v1/vehicles', data: payload);
      final data = _asMap(res.data);
      return vehicleFromJson(_asMap(data['vehicle']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<BuildLogEntry> addBuildLog(
    String vehicleId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final res = await _client.post(
        '/api/v1/vehicles/$vehicleId/build-logs',
        data: payload,
      );
      final data = _asMap(res.data);
      return buildLogFromJson(_asMap(data['build_log']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ServiceRecord> addServiceRecord(
    String vehicleId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final res = await _client.post(
        '/api/v1/vehicles/$vehicleId/service-records',
        data: payload,
      );
      final data = _asMap(res.data);
      return serviceRecordFromJson(_asMap(data['service_record']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<String> uploadMedia(File file, {String folder = 'receipts'}) async {
    try {
      final formData = FormData.fromMap({
        'folder': folder,
        'file': await MultipartFile.fromFile(file.path),
      });
      final res = await _client.post(
        '/api/v1/media/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = _asMap(res.data);
      return _asString(data['url']);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<({List<PartModel> parts, Set<String> savedIds})> fetchParts({
    String? query,
    String? brand,
    String? condition,
    int? minPrice,
    int? maxPrice,
    bool savedOnly = false,
    String sort = 'newest',
  }) async {
    try {
      final params = <String, dynamic>{
        'sort': sort,
        if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
        if (brand != null && brand != 'All') 'brand': brand,
        if (condition != null && condition != 'All') 'condition': condition,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (savedOnly) 'saved': 1,
      };
      final res = await _client.get('/api/v1/marketplace/parts', queryParameters: params);
      final data = _asMap(res.data);
      final list = data['parts'] as List<dynamic>? ?? const [];
      final savedIds = <String>{};
      final parts = list.map((raw) {
        final m = _asMap(raw);
        final p = partFromJson(m);
        if (m['is_saved'] == true) savedIds.add(p.id);
        return p;
      }).toList();
      return (parts: parts, savedIds: savedIds);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<PartModel> createPart(Map<String, dynamic> payload) async {
    try {
      final res = await _client.post('/api/v1/marketplace/parts', data: payload);
      final data = _asMap(res.data);
      return partFromJson(_asMap(data['part']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<bool> setPartSaved(String partId, bool saved) async {
    try {
      final res = await _client.put(
        '/api/v1/marketplace/parts/$partId/save',
        data: {'value': saved},
      );
      final data = _asMap(res.data);
      return data['is_saved'] == true;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> reservePart(String partId, {String? message}) async {
    try {
      await _client.post(
        '/api/v1/marketplace/parts/$partId/reserve',
        data: {if (message != null) 'message': message},
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<List<ChatMessage>> fetchPartChat(String partId) async {
    try {
      final res = await _client.get('/api/v1/marketplace/parts/$partId/chat');
      final data = _asMap(res.data);
      final list = data['messages'] as List<dynamic>? ?? const [];
      return list.map((raw) => chatMessageFromJson(_asMap(raw))).toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ChatMessage> sendPartChat(String partId, String text) async {
    try {
      final res = await _client.post(
        '/api/v1/marketplace/parts/$partId/chat',
        data: {'text': text},
      );
      final data = _asMap(res.data);
      return chatMessageFromJson(_asMap(data['message']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<List<MechanicModel>> fetchMechanics({String? query}) async {
    try {
      final res = await _client.get(
        '/api/v1/mechanics',
        queryParameters: {
          if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
        },
      );
      final data = _asMap(res.data);
      final list = data['mechanics'] as List<dynamic>? ?? const [];
      return list.map((raw) => mechanicFromJson(_asMap(raw))).toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> bookWorkshop({
    required String workshopId,
    required String serviceKey,
    required String slot,
    String? vehicleId,
  }) async {
    try {
      final parsedVehicleId = int.tryParse(vehicleId ?? '');
      await _client.post(
        '/api/v1/mechanics/$workshopId/book',
        data: {
          'service_key': serviceKey,
          'slot': slot,
          if (parsedVehicleId != null) 'vehicle_id': parsedVehicleId,
        },
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<({List<MeetModel> meets, Set<String> rsvpedIds})> fetchMeets() async {
    try {
      final res = await _client.get('/api/v1/meets');
      final data = _asMap(res.data);
      final list = data['meets'] as List<dynamic>? ?? const [];
      final rsvped = <String>{};
      final meets = list.map((raw) {
        final m = _asMap(raw);
        final meet = meetFromJson(m);
        if (m['is_attending'] == true) rsvped.add(meet.id);
        return meet;
      }).toList();
      return (meets: meets, rsvpedIds: rsvped);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<MeetModel> hostMeet({
    required String title,
    required String location,
    required String eventDate,
    String? description,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final res = await _client.post('/api/v1/meets', data: {
        'title': title,
        'location': location,
        'event_date': eventDate,
        if (description != null && description.isNotEmpty) 'description': description,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });
      final data = _asMap(res.data);
      return meetFromJson(_asMap(data['meet']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<int> setMeetRsvp(String meetId, bool attending) async {
    try {
      final res = await _client.put(
        '/api/v1/meets/$meetId/rsvp',
        data: {'value': attending},
      );
      final data = _asMap(res.data);
      return _asInt(data['going_count']);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<({List<CrewModel> crews, Set<String> joinedIds})> fetchCrews() async {
    try {
      final res = await _client.get('/api/v1/crews');
      final data = _asMap(res.data);
      final list = data['crews'] as List<dynamic>? ?? const [];
      final joined = <String>{};
      final crews = list.map((raw) {
        final m = _asMap(raw);
        final crew = crewFromJson(m);
        if (m['joined_by_me'] == true || m['is_joined'] == true) {
          joined.add(crew.id);
        }
        return crew;
      }).toList();
      return (crews: crews, joinedIds: joined);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<List<CrewLiveRider>> fetchLiveCrewRiders() async {
    try {
      final res = await _client.get('/api/v1/crews/live');
      final data = _asMap(res.data);
      final list = data['riders'] as List<dynamic>? ?? const [];
      return list.map((raw) => crewLiveRiderFromJson(_asMap(raw))).toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<CrewLiveRider> updateLiveCrewPresence({
    required bool isRiding,
    required double latitude,
    required double longitude,
    String? vehicleId,
    String? statusNote,
  }) async {
    try {
      final parsedVehicleId = int.tryParse(vehicleId ?? '');
      final res = await _client.put('/api/v1/crews/live', data: {
        'is_riding': isRiding,
        'latitude': latitude,
        'longitude': longitude,
        if (parsedVehicleId != null) 'vehicle_id': parsedVehicleId,
        if (statusNote != null && statusNote.isNotEmpty) 'status_note': statusNote,
      });
      final data = _asMap(res.data);
      return crewLiveRiderFromJson(_asMap(data['rider']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<int> setCrewMembership(String crewId, bool joined) async {
    try {
      final res = await _client.put(
        '/api/v1/crews/$crewId/membership',
        data: {'value': joined},
      );
      final data = _asMap(res.data);
      return _asInt(data['members_count']);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<CrewModel> createCrew({
    required String name,
    required String focus,
    required String location,
    String? description,
  }) async {
    try {
      final res = await _client.post('/api/v1/crews', data: {
        'name': name,
        'focus': focus,
        'location': location,
        if (description != null && description.isNotEmpty) 'description': description,
      });
      final data = _asMap(res.data);
      return crewFromJson(_asMap(data['crew']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<({List<CommunityFeedPost> posts, Set<String> likedIds})> fetchFeed() async {
    try {
      final res = await _client.get('/api/v1/feed');
      final data = _asMap(res.data);
      final list = data['feed_posts'] as List<dynamic>? ?? const [];
      final liked = <String>{};
      final posts = list.map((raw) {
        final m = _asMap(raw);
        final post = feedPostFromJson(m);
        if (m['is_liked'] == true) liked.add(post.id);
        return post;
      }).toList();
      return (posts: posts, likedIds: liked);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<int> setPostLike(String postId, bool liked) async {
    try {
      final res = await _client.put(
        '/api/v1/feed/$postId/like',
        data: {'value': liked},
      );
      final data = _asMap(res.data);
      return _asInt(data['likes_count']);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<List<FeedComment>> fetchFeedComments(String postId) async {
    try {
      final res = await _client.get('/api/v1/feed/$postId/comments');
      final data = _asMap(res.data);
      final list = data['comments'] as List<dynamic>? ?? const [];
      return list.map((raw) {
        final m = _asMap(raw);
        return FeedComment(
          id: _asString(m['id']),
          author: _asString(m['author'], 'Enthusiast'),
          handle: _asString(m['handle']),
          avatar: _asString(m['avatar'], 'AG'),
          body: _asString(m['body']),
          timeAgo: _asString(m['time_ago'], 'Now'),
        );
      }).toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<({FeedComment comment, int commentsCount})> postFeedComment(
    String postId,
    String body,
  ) async {
    try {
      final res = await _client.post(
        '/api/v1/feed/$postId/comments',
        data: {'body': body},
      );
      final data = _asMap(res.data);
      final m = _asMap(data['comment']);
      return (
        comment: FeedComment(
          id: _asString(m['id']),
          author: _asString(m['author'], 'Enthusiast'),
          handle: _asString(m['handle']),
          avatar: _asString(m['avatar'], 'AG'),
          body: _asString(m['body']),
          timeAgo: _asString(m['time_ago'], 'Now'),
        ),
        commentsCount: _asInt(data['comments_count']),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // ------------------------------------------------------------------
  // Shop Owner / Seller Mobile Endpoints
  // ------------------------------------------------------------------

  Future<ApiSellerDashboard> fetchSellerDashboard() async {
    try {
      final res = await _client.get('/api/v1/seller/dashboard');
      final data = _asMap(res.data);
      final shop = ApiSellerShop.fromJson(_asMap(data['shop']));
      final stats = ApiSellerStats.fromJson(_asMap(data['stats']));
      final parts = (data['parts'] as List<dynamic>? ?? const [])
          .map((e) => ApiSellerPart.fromJson(_asMap(e)))
          .toList();
      final inquiries = (data['inquiries'] as List<dynamic>? ?? const [])
          .map((e) => ApiSellerInquiry.fromJson(_asMap(e)))
          .toList();
      final bookings = (data['bookings'] as List<dynamic>? ?? const [])
          .map((e) => ApiSellerBooking.fromJson(_asMap(e)))
          .toList();
      return ApiSellerDashboard(
        shop: shop,
        stats: stats,
        parts: parts,
        inquiries: inquiries,
        bookings: bookings,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ApiSellerPart> updateSellerPart({
    required String partId,
    required int priceLkr,
    required int stock,
    String? title,
    String? fitment,
    String? description,
  }) async {
    try {
      final res = await _client.patch(
        '/api/v1/seller/parts/$partId',
        data: {
          'price_lkr': priceLkr,
          'stock': stock,
          if (title != null) 'title': title,
          if (fitment != null) 'fitment': fitment,
          if (description != null) 'description': description,
        },
      );
      final data = _asMap(res.data);
      return ApiSellerPart.fromJson(_asMap(data['data']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<({ChatMessage message, String inquiryStatus})> replySellerInquiry({
    required int inquiryId,
    required String message,
    String status = 'Replied',
  }) async {
    try {
      final res = await _client.post(
        '/api/v1/seller/inquiries/$inquiryId/reply',
        data: {
          'message': message,
          'status': status,
        },
      );
      final data = _asMap(res.data);
      final msg = _asMap(data['message']);
      return (
        message: ChatMessage(
          from: _asString(msg['sender'], 'seller'),
          text: _asString(msg['text']),
          time: DateTime.tryParse(_asString(msg['time'])) ?? DateTime.now(),
        ),
        inquiryStatus: _asString(data['inquiry_status'], status),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ApiSellerBooking> updateSellerBooking({
    required int bookingId,
    required String status,
  }) async {
    try {
      final res = await _client.patch(
        '/api/v1/seller/bookings/$bookingId',
        data: {'status': status},
      );
      final data = _asMap(res.data);
      return ApiSellerBooking.fromJson(_asMap(data['data']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ApiSellerShop> updateSellerProfile({
    required String businessName,
    required String location,
    required String phone,
    required String specialty,
  }) async {
    try {
      final res = await _client.patch(
        '/api/v1/seller/profile',
        data: {
          'business_name': businessName,
          'location': location,
          'phone': phone,
          'specialty': specialty,
        },
      );
      final data = _asMap(res.data);
      return ApiSellerShop.fromJson(_asMap(data['shop']));
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // JSON -> App Model Mappers
  // ---------------------------------------------------------------------------

  static VehicleModel vehicleFromJson(Map<String, dynamic> j) {
    final specsList = (j['specs'] as List<dynamic>? ?? const []).map((raw) {
      final s = _asMap(raw);
      return SpecItem(
        icon: LucideIcons.gauge,
        label: _asString(s['label'], 'Verified'),
      );
    }).toList();

    final logsList = (j['logs'] as List<dynamic>? ?? const [])
        .map((raw) => buildLogFromJson(_asMap(raw)))
        .toList();

    final serviceList = (j['service_records'] as List<dynamic>? ?? const [])
        .map((raw) => serviceRecordFromJson(_asMap(raw)))
        .toList();

    return VehicleModel(
      id: _asString(j['id']),
      category: _asString(j['category'], 'Car'),
      brand: _asString(j['brand'], 'JDM'),
      title: _asString(j['title']),
      subtitle: _asString(j['subtitle']),
      shortContextLabel: _asString(j['short_context_label'], _asString(j['title'])),
      watermark: _asString(j['watermark']),
      illustration: _asString(j['illustration'], 'fd2'),
      photoUrl: j['photo_url'] as String?,
      stageBadge: _asString(j['stage_badge'], 'Active Build'),
      status: _asString(j['status'], 'Good'),
      statusTone: _asString(j['status_tone'], 'emerald'),
      year: _asString(j['year'], '2020'),
      chassis: _asString(j['chassis']),
      engineCode: _asString(j['engine_code']),
      engine: _asString(j['engine']),
      currentMileage: _asInt(j['current_mileage']),
      lastServiceMileage: _asInt(j['last_service_mileage']),
      serviceInterval: _asInt(j['service_interval'], 5000),
      nextServiceMileage: _asInt(j['next_service_mileage']),
      nextServiceDate: _asString(j['next_service_date'], 'Upcoming'),
      powerValue: _asString(j['power_value'], '0'),
      powerUnit: _asString(j['power_unit'], 'WHP'),
      torqueValue: _asString(j['torque_value'], '0 Nm'),
      estimatedValueLkr: _asInt(j['estimated_value_lkr']),
      specs: specsList,
      logs: logsList,
      serviceRecords: serviceList,
    );
  }

  static BuildLogEntry buildLogFromJson(Map<String, dynamic> j) {
    return BuildLogEntry(
      id: _asString(j['id']),
      category: _asString(j['category'], 'Engine'),
      title: _asString(j['title']),
      brand: _asString(j['brand'], 'Custom'),
      date: _asString(j['date'], 'Today'),
      cost: _asInt(j['cost_lkr']),
      mechanic: _asString(j['mechanic'], 'Workshop'),
      notes: _asString(j['notes']),
      photoLabel: j['photo_label'] as String?,
      photoUrl: j['photo_url'] as String?,
    );
  }

  static ServiceRecord serviceRecordFromJson(Map<String, dynamic> j) {
    return ServiceRecord(
      id: _asString(j['id']),
      title: _asString(j['title']),
      date: _asString(j['date'], 'Today'),
      odometer: _asInt(j['odometer']),
      workshop: _asString(j['workshop']),
      partsChanged: (j['parts_changed'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      cost: _asInt(j['cost']),
      nextServiceKm: _asInt(j['next_service_km']),
      nextServiceDate: _asString(j['next_service_date'], 'Upcoming'),
      notes: _asString(j['notes']),
      receiptLabel: _asString(j['receipt_label']),
    );
  }

  static PartModel partFromJson(Map<String, dynamic> j) {
    final specsList = (j['specs'] as List<dynamic>? ?? const []).map((raw) {
      final s = _asMap(raw);
      return SpecItem(
        icon: LucideIcons.wrench,
        label: _asString(s['label'], _asString(s['value'])),
      );
    }).toList();

    return PartModel(
      id: _asString(j['id']),
      brand: _asString(j['brand']),
      title: _asString(j['title']),
      subtitle: _asString(j['subtitle']),
      watermark: _asString(j['watermark']),
      illustration: _asString(j['illustration'], 'turbo'),
      photoUrl: j['photo_url'] as String?,
      price: _asInt(j['price']),
      condition: _asString(j['condition'], 'Used'),
      trust: (j['trust'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      seller: _asString(j['seller'], 'Verified Seller'),
      location: _asString(j['location'], 'Colombo'),
      rating: _asString(j['rating'], '4.9'),
      verified: j['verified'] == true,
      specs: specsList,
      description: _asString(j['description']),
    );
  }

  static MechanicModel mechanicFromJson(Map<String, dynamic> j) {
    return MechanicModel(
      id: _asString(j['id']),
      name: _asString(j['name']),
      location: _asString(j['location']),
      specialty: _asString(j['specialty']),
      rating: _asString(j['rating'], '4.9'),
      reviews: _asInt(j['reviews']),
      basePrice: _asString(j['base_price'], 'LKR 15,000'),
      tags: (j['tags'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      availability: _asString(j['availability'], 'Slots Today'),
    );
  }

  static MeetModel meetFromJson(Map<String, dynamic> j) {
    return MeetModel(
      id: _asString(j['id']),
      pinId: _asString(j['pin_id']),
      title: _asString(j['title']),
      date: _asString(j['date']),
      location: _asString(j['location']),
      host: _asString(j['host']),
      going: _asInt(j['going']),
      pinTopRatio: _asDouble(j['pin_top_ratio'], 0.5),
      pinLeftRatio: _asDouble(j['pin_left_ratio'], 0.4),
      pinLabel: _asString(j['pin_label'], 'Meet'),
      latitude: _asDouble(j['latitude'], 6.9271),
      longitude: _asDouble(j['longitude'], 79.8612),
    );
  }

  static CrewLiveRider crewLiveRiderFromJson(Map<String, dynamic> j) {
    return CrewLiveRider(
      userId: _asString(j['user_id']),
      name: _asString(j['name'], 'Crew Rider'),
      handle: _asString(j['handle']),
      avatar: _asString(j['avatar'], 'CR'),
      crewName: _asString(j['crew_name'], 'ApexGarage SL'),
      isRiding: j['is_riding'] == true,
      isMe: j['is_me'] == true,
      vehicleId: j['vehicle_id'] != null ? _asString(j['vehicle_id']) : null,
      vehicleTitle: _asString(j['vehicle_title'], 'Enthusiast Build'),
      vehicleCategory: _asString(j['vehicle_category'], 'Car'),
      vehicleBrand: _asString(j['vehicle_brand'], 'JDM'),
      stageBadge: _asString(j['stage_badge'], 'Online'),
      latitude: _asDouble(j['latitude'], 6.9271),
      longitude: _asDouble(j['longitude'], 79.8612),
      statusNote: j['status_note'] as String?,
      lastSeenAgo: _asString(j['last_seen_ago'], 'Now'),
    );
  }

  static CrewModel crewFromJson(Map<String, dynamic> j) {
    return CrewModel(
      id: _asString(j['id']),
      name: _asString(j['name']),
      members: _asInt(j['members']),
      focus: _asString(j['focus']),
      location: _asString(j['location']),
    );
  }

  static CommunityFeedPost feedPostFromJson(Map<String, dynamic> j) {
    final author = _asString(
      j['author'] ?? j['user'],
      'Enthusiast',
    );
    final initials = author
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .take(2)
        .map((s) => s[0].toUpperCase())
        .join();
    final handle = _asString(j['handle']);
    final avatar = _asString(j['avatar']);
    return CommunityFeedPost(
      id: _asString(j['id']),
      author: author,
      handle: handle.isNotEmpty
          ? handle
          : '@${author.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_')}',
      avatar: avatar.isNotEmpty ? avatar : (initials.isEmpty ? 'AG' : initials),
      crew: _asString(j['crew'], 'ApexGarage SL'),
      timeAgo: _asString(j['time_ago'] ?? j['time'], 'Recently'),
      vehicleTitle: _asString(j['vehicle_title'] ?? j['vehicle']),
      modTitle: _asString(j['mod_title'] ?? j['mod']),
      workshop: _asString(j['workshop']),
      illustration: _asString(j['illustration'], 'fd2'),
      watermark: _asString(j['watermark'], 'JDM'),
      photoUrl: j['photo_url'] as String?,
      tags: (j['tags'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      likes: _asInt(j['likes_count'] ?? j['likes']),
      comments: _asInt(j['comments_count'] ?? j['comments']),
      liked: j['liked_by_me'] == true || j['is_liked'] == true,
    );
  }

  static ChatMessage chatMessageFromJson(Map<String, dynamic> j) {
    return ChatMessage(
      from: _asString(j['from'], 'me'),
      text: _asString(j['text']),
      time: DateTime.tryParse(_asString(j['time'])) ?? DateTime.now(),
    );
  }

  static ApiException _mapError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          return ApiException(first.first.toString(), statusCode: status);
        }
      }
      if (data['message'] is String && (data['message'] as String).isNotEmpty) {
        return ApiException(data['message'] as String, statusCode: status);
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const ApiException(
        'Cannot reach ApexGarage server. Check your connection and try again.',
      );
    }
    return ApiException(
      e.message ?? 'Unexpected network error.',
      statusCode: status,
    );
  }
}

Map<String, dynamic> _asMap(dynamic v) =>
    v is Map<String, dynamic> ? v : <String, dynamic>{};

String _asString(dynamic v, [String fallback = '']) =>
    v == null ? fallback : v.toString();

int _asInt(dynamic v, [int fallback = 0]) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v?.toString() ?? '') ?? fallback;
}

double _asDouble(dynamic v, [double fallback = 0.0]) {
  if (v is double) return v;
  if (v is num) return v.toDouble();
  return double.tryParse(v?.toString() ?? '') ?? fallback;
}
