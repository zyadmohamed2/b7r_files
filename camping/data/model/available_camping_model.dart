class AvailableCampingModel {
  String? nameAvailable;
  String? photoPathAvailable;

  AvailableCampingModel({this.nameAvailable, this.photoPathAvailable});

  factory AvailableCampingModel.fromJson(Map<String, dynamic> json) {
    return AvailableCampingModel(
      nameAvailable: json['nameAvailable'] as String?,
      photoPathAvailable: json['photoPathAvailable'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'nameAvailable': nameAvailable,
        'photoPathAvailable': photoPathAvailable,
      };
}
