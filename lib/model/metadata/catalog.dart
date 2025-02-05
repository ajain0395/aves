import 'package:aves/services/geocoding_service.dart';
import 'package:flutter/foundation.dart';

class CatalogMetadata {
  final int id;
  final int? dateMillis;
  final bool isAnimated, isGeotiff, is360, isMultiPage, isMotionPhoto, hasHdrGainMap;
  bool isFlipped;
  int? rotationDegrees;
  final String? mimeType, xmpSubjects, xmpTitle;
  double? latitude, longitude;
  Address? address;
  int rating;

  // less lenient than Flutter's `precisionErrorTolerance` (1e-10)
  static const double _precisionErrorTolerance = 1e-9;

  static const _isAnimatedMask = 1 << 0;
  static const _isFlippedMask = 1 << 1;
  static const _isGeotiffMask = 1 << 2;
  static const _is360Mask = 1 << 3;
  static const _isMultiPageMask = 1 << 4;
  static const _isMotionPhotoMask = 1 << 5;
  static const _hasHdrGainMapMask = 1 << 6;

  CatalogMetadata({
    required this.id,
    this.mimeType,
    this.dateMillis,
    this.isAnimated = false,
    this.isFlipped = false,
    this.isGeotiff = false,
    this.is360 = false,
    this.isMultiPage = false,
    this.isMotionPhoto = false,
    this.hasHdrGainMap = false,
    this.rotationDegrees,
    this.xmpSubjects,
    this.xmpTitle,
    double? latitude,
    double? longitude,
    this.rating = 0,
  }) {
    // Geocoder throws an `IllegalArgumentException` when a coordinate has a funky value like `1.7056881853375E7`
    // We also exclude zero coordinates, taking into account precision errors (e.g. {5.952380952380953e-11,-2.7777777777777777e-10}),
    // but Flutter's `precisionErrorTolerance` (1e-10) is slightly too lenient for this case.
    if (latitude != null && longitude != null && (latitude.abs() > _precisionErrorTolerance || longitude.abs() > _precisionErrorTolerance)) {
      // funny case: some files have latitude and longitude reverse
      // (e.g. a Japanese location at lat~=133 and long~=34, which is a valid longitude but an invalid latitude)
      // so we should check and assign both coordinates at once
      if (latitude >= -90.0 && latitude <= 90.0 && longitude >= -180.0 && longitude <= 180.0) {
        this.latitude = latitude;
        this.longitude = longitude;
      }
    }
  }

  CatalogMetadata copyWith({
    int? id,
    String? mimeType,
    int? dateMillis,
    bool? isAnimated,
    bool? isMultiPage,
    int? rotationDegrees,
    double? latitude,
    double? longitude,
  }) {
    return CatalogMetadata(
      id: id ?? this.id,
      mimeType: mimeType ?? this.mimeType,
      dateMillis: dateMillis ?? this.dateMillis,
      isAnimated: isAnimated ?? this.isAnimated,
      isFlipped: isFlipped,
      isGeotiff: isGeotiff,
      is360: is360,
      isMultiPage: isMultiPage ?? this.isMultiPage,
      isMotionPhoto: isMotionPhoto,
      hasHdrGainMap: hasHdrGainMap,
      rotationDegrees: rotationDegrees ?? this.rotationDegrees,
      xmpSubjects: xmpSubjects,
      xmpTitle: xmpTitle,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating,
    );
  }

  factory CatalogMetadata.fromMap(Map map) {
    final flags = map['flags'] ?? 0;
    return CatalogMetadata(
      id: map['id'],
      mimeType: map['mimeType'],
      dateMillis: map['dateMillis'] ?? 0,
      isAnimated: flags & _isAnimatedMask != 0,
      isFlipped: flags & _isFlippedMask != 0,
      isGeotiff: flags & _isGeotiffMask != 0,
      is360: flags & _is360Mask != 0,
      isMultiPage: flags & _isMultiPageMask != 0,
      isMotionPhoto: flags & _isMotionPhotoMask != 0,
      hasHdrGainMap: flags & _hasHdrGainMapMask != 0,
      // `rotationDegrees` should default to `sourceRotationDegrees`, not 0
      rotationDegrees: map['rotationDegrees'],
      xmpSubjects: map['xmpSubjects'] ?? '',
      xmpTitle: map['xmpTitle'] ?? '',
      latitude: map['latitude'],
      longitude: map['longitude'],
      rating: map['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'mimeType': mimeType,
        'dateMillis': dateMillis,
        'flags': (isAnimated ? _isAnimatedMask : 0) | (isFlipped ? _isFlippedMask : 0) | (isGeotiff ? _isGeotiffMask : 0) | (is360 ? _is360Mask : 0) | (isMultiPage ? _isMultiPageMask : 0) | (isMotionPhoto ? _isMotionPhotoMask : 0) | (hasHdrGainMap ? _hasHdrGainMapMask : 0),
        'rotationDegrees': rotationDegrees,
        'xmpSubjects': xmpSubjects,
        'xmpTitle': xmpTitle,
        'latitude': latitude,
        'longitude': longitude,
        'rating': rating,
      };

  @override
  String toString() => '$runtimeType#${shortHash(this)}{id=$id, mimeType=$mimeType, dateMillis=$dateMillis, isAnimated=$isAnimated, isFlipped=$isFlipped, isGeotiff=$isGeotiff, is360=$is360, isMultiPage=$isMultiPage, isMotionPhoto=$isMotionPhoto, rotationDegrees=$rotationDegrees, xmpSubjects=$xmpSubjects, xmpTitle=$xmpTitle, latitude=$latitude, longitude=$longitude, rating=$rating}';
}
