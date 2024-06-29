class CampingModel {
  List<dynamic>? images;
  String? title;
  double? price;
  String? about;
  String? address;
  double? rating;
  int? commentsCount;
  int? reviewCount;
  double? customizeBoatDriverPrice;
  double? customizeFilmingVideoPrice;
  double? customizeArtistMusicianPrice;
  double? customizeATourGuidePrice;
  double? customizeFoodServicesPrice;
  List<dynamic>? packageDays;

  CampingModel({
    this.images,
    this.title,
    this.price,
    this.about,
    this.address,
    this.rating,
    this.commentsCount,
    this.reviewCount,
    this.customizeBoatDriverPrice,
    this.customizeFilmingVideoPrice,
    this.customizeArtistMusicianPrice,
    this.customizeATourGuidePrice,
    this.customizeFoodServicesPrice,
    this.packageDays,
  });

  factory CampingModel.fromJson(Map<String, dynamic> json) => CampingModel(
        images: json['images'] as List<dynamic>?,
        title: json['title'] as String?,
        price: double.parse(json['price'].toString()),
        about: json['about'] as String?,
        address: json['address'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        commentsCount: json['commentsCount'] as int?,
        reviewCount: json['reviewCount'] as int?,
        customizeBoatDriverPrice:
            double.parse(json['customizeBoatDriverPrice'].toString()),
        customizeFilmingVideoPrice:
            double.parse(json['customizeFilmingVideoPrice'].toString()),
        customizeArtistMusicianPrice:
            double.parse(json['customizeArtistMusicianPrice'].toString()),
        customizeATourGuidePrice:
            double.parse(json['customizeATourGuidePrice'].toString()),
        customizeFoodServicesPrice:
            double.parse(json['customizeFoodServicesPrice'].toString()),
        packageDays: json['packageDays'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'images': images,
        'title': title,
        'price': price,
        'about': about,
        'address': address,
        'rating': rating,
        'commentsCount': commentsCount,
        'reviewCount': reviewCount,
        'customizeBoatDriverPrice': customizeBoatDriverPrice,
        'customizeFilmingVideoPrice': customizeFilmingVideoPrice,
        'customizeArtistMusicianPrice': customizeArtistMusicianPrice,
        'customizeATourGuidePrice': customizeATourGuidePrice,
        'customizeFoodServicesPrice': customizeFoodServicesPrice,
        'packageDays': packageDays,
      };
}
