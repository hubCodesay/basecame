import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model for a gear listing stored in the `gear` collection.
class Gear {
  String? id;

  // A. Required (MVP)
  final String ownerId;
  final String title;
  final String description;
  final String category;
  final num priceAmount;
  final String priceCurrency;
  final bool depositRequired;
  final num depositAmount;
  final String depositCurrency;
  final GeoPoint locationGeo;
  String locationGeohash;
  final String locationCity;
  final String locationCountryCode;
  String status;
  String visibility;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  // B. Recommended (optional)
  String? brand;
  String? model;
  String? condition; // excellent|very_good|good|fair|poor
  Map<String, dynamic>? availability;
  String? mapPointId;

  // C. Photos (array) — each element is a map with url and optional storagePath
  final List<Map<String, dynamic>> photos;

  Gear({
    this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.category,
    required this.priceAmount,
    required this.priceCurrency,
    required this.depositRequired,
    required this.depositAmount,
    required this.depositCurrency,
    required this.locationGeo,
    this.locationGeohash = '',
    required this.locationCity,
    required this.locationCountryCode,
    this.status = 'active',
    this.visibility = 'public',
    this.createdAt,
    this.updatedAt,
    this.brand,
    this.model,
    this.condition,
    this.availability,
    this.mapPointId,
    List<Map<String, dynamic>>? photos,
  }) : photos = photos ?? [] {
    // basic validation for required MVP fields
    assert(ownerId.isNotEmpty, 'ownerId is required');
    assert(title.isNotEmpty, 'title is required');
    assert(category.isNotEmpty, 'category is required');
  }

  /// Convert to a Map suitable for creating/updating a Firestore document.
  /// Note: `createdAt` and `updatedAt` should be set to server timestamps
  /// when creating or updating documents.
  Map<String, dynamic> toMap({bool setServerTimestamps = true}) {
    return {
      if (ownerId.isNotEmpty) 'ownerId': ownerId,
      'title': title,
      'description': description,
      'category': category,
      'pricePerDay': {'amount': priceAmount, 'currency': priceCurrency},
      'deposit': {
        'required': depositRequired,
        'amount': depositAmount,
        'currency': depositCurrency,
      },
      'location': {
        'geo': locationGeo,
        'geohash': locationGeohash,
        'city': locationCity,
        'countryCode': locationCountryCode,
      },
      'status': status,
      'visibility': visibility,
      'createdAt': setServerTimestamps
          ? FieldValue.serverTimestamp()
          : createdAt,
      'updatedAt': setServerTimestamps
          ? FieldValue.serverTimestamp()
          : updatedAt,
      'brand': brand,
      'model': model,
      'condition': condition,
      'availability': availability,
      'mapPointId': mapPointId ?? '',
      'photos': photos,
    };
  }

  /// Construct a Gear from a Firestore document snapshot
  factory Gear.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};

    final price = data['pricePerDay'] as Map<String, dynamic>?;
    final deposit = data['deposit'] as Map<String, dynamic>?;
    final location = data['location'] as Map<String, dynamic>?;

    return Gear(
      id: doc.id,
      ownerId: data['ownerId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      priceAmount: price != null ? (price['amount'] as num? ?? 0) : 0,
      priceCurrency: price != null
          ? (price['currency'] as String? ?? 'EUR')
          : 'EUR',
      depositRequired: deposit != null
          ? (deposit['required'] as bool? ?? false)
          : false,
      depositAmount: deposit != null ? (deposit['amount'] as num? ?? 0) : 0,
      depositCurrency: deposit != null
          ? (deposit['currency'] as String? ?? 'EUR')
          : 'EUR',
      locationGeo: location != null && location['geo'] is GeoPoint
          ? location['geo'] as GeoPoint
          : GeoPoint(0, 0),
      locationGeohash: location != null
          ? (location['geohash'] as String? ?? '')
          : '',
      locationCity: location != null ? (location['city'] as String? ?? '') : '',
      locationCountryCode: location != null
          ? (location['countryCode'] as String? ?? '')
          : '',
      status: data['status'] as String? ?? 'active',
      visibility: data['visibility'] as String? ?? 'public',
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
      brand: data['brand'] as String?,
      model: data['model'] as String?,
      condition: data['condition'] as String?,
      availability: data['availability'] as Map<String, dynamic>?,
      mapPointId: data['mapPointId'] as String?,
      photos: (() {
        final List<Map<String, dynamic>> result = [];
        try {
          final raw = data['photos'];
          if (raw is List) {
            for (final e in raw) {
              if (e is Map) {
                try {
                  result.add(Map<String, dynamic>.from(e));
                } catch (_) {
                  // skip malformed map
                }
              }
            }
          }
        } catch (_) {
          // ignore and return empty list
        }
        return result;
      })(),
    );
  }
}
