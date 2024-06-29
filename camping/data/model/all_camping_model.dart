class AllCampingModel {
  int? id;
  String? campingImage;
  String? title;
  String? address;
  bool? isFavorite;
  AllCampingModel(
      {this.id, this.campingImage, this.title, this.address, this.isFavorite});

  factory AllCampingModel.fromJson(Map<String, dynamic> json) {
    return AllCampingModel(
      id: json['id'] as int?,
      campingImage: json['campingImage'] as String?,
      title: json['title'] as String?,
      address: json['address'] as String?,
      isFavorite: json['isFavorite'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'campingImage': campingImage,
        'title': title,
        'address': address,
        'isFavorite': isFavorite,
      };
}
