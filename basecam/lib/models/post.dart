class Post {
  final String? id;
  final String title;
  final String description;
  final String? ownerId;
  final double? latitude;
  final double? longitude;
  // Additional optional fields (stubs for map.dart usage)
  final String? category;
  final double? pricePerDayAmount;
  final bool? depositRequired;
  final double? depositAmount;
  final dynamic locationGeo;
  final String? locationGeohash;
  final String? locationCity;
  final String? locationCountryCode;
  final String? brand;
  final String? model;
  final String? condition;
  final String? availabilityTimezone;
  final String? mapPointId;
  final List<Map<String, dynamic>>? photos;

  Post({
    this.id,
    required this.title,
    required this.description,
    this.latitude,
    this.longitude,
    this.ownerId,
    this.category,
    this.pricePerDayAmount,
    this.depositRequired,
    this.depositAmount,
    this.locationGeo,
    this.locationGeohash,
    this.locationCity,
    this.locationCountryCode,
    this.brand,
    this.model,
    this.condition,
    this.availabilityTimezone,
    this.mapPointId,
    this.photos,
  });
}
