import 'package:goshops/infrastructure/model/response/delivery_point_response.dart';

import 'location_model.dart';
import 'translation_model.dart';

class ShopData {
  int? id;
  String? uuid;
  dynamic discountsCount;
  int? userId;
  num? tax;
  num? percentage;
  String? phone;
  bool? open;
  bool? visibility;
  bool? verify;
  String? backgroundImg;
  String? logoImg;
  num? minAmount;
  int? deliveryType;
  String? status;
  String? statusNote;
  DeliveryTime? deliveryTime;
  String? inviteLink;
  LocationModel? location;
  int? rCount;
  num? rAvg;
  num? rSum;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? productsCount;
  Translation? translation;
  List<Translation>? translations;
  List<String>? locales;
  List<double>? latLong;
  Seller? seller;
  dynamic bonus;
  List<Social>? socials;
  List<WorkingDay>? workingDays;
  List<dynamic>? shopClosedDate;

  ShopData({
    this.id,
    this.uuid,
    this.discountsCount,
    this.deliveryType,
    this.userId,
    this.tax,
    this.percentage,
    this.phone,
    this.open,
    this.latLong,
    this.visibility,
    this.verify,
    this.backgroundImg,
    this.logoImg,
    this.minAmount,
    this.status,
    this.statusNote,
    this.deliveryTime,
    this.inviteLink,
    this.location,
    this.rCount,
    this.rAvg,
    this.rSum,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
    this.translation,
    this.translations,
    this.locales,
    this.seller,
    this.bonus,
    this.socials,
    this.workingDays,
    this.shopClosedDate,
  });

  ShopData copyWith({
    int? id,
    String? uuid,
    dynamic discountsCount,
    int? userId,
    num? tax,
    int? percentage,
    int? deliveryType,
    String? phone,
    bool? open,
    bool? visibility,
    bool? verify,
    String? backgroundImg,
    String? logoImg,
    num? minAmount,
    String? status,
    String? statusNote,
    DeliveryTime? deliveryTime,
    String? inviteLink,
    LocationModel? location,
    int? rCount,
    double? rAvg,
    int? rSum,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productsCount,
    Translation? translation,
    List<Translation>? translations,
    List<String>? locales,
    Seller? seller,
    dynamic bonus,
    List<Social>? socials,
    List<WorkingDay>? workingDays,
    List<dynamic>? shopClosedDate,
  }) =>
      ShopData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        discountsCount: discountsCount ?? this.discountsCount,
        userId: userId ?? this.userId,
        tax: tax ?? this.tax,
        percentage: percentage ?? this.percentage,
        phone: phone ?? this.phone,
        open: open ?? this.open,
        visibility: visibility ?? this.visibility,
        verify: verify ?? this.verify,
        backgroundImg: backgroundImg ?? this.backgroundImg,
        logoImg: logoImg ?? this.logoImg,
        minAmount: minAmount ?? this.minAmount,
        status: status ?? this.status,
        statusNote: statusNote ?? this.statusNote,
        deliveryTime: deliveryTime ?? this.deliveryTime,
        inviteLink: inviteLink ?? this.inviteLink,
        location: location ?? this.location,
        rCount: rCount ?? this.rCount,
        rAvg: rAvg ?? this.rAvg,
        rSum: rSum ?? this.rSum,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        productsCount: productsCount ?? this.productsCount,
        translation: translation ?? this.translation,
        translations: translations ?? this.translations,
        locales: locales ?? this.locales,
        seller: seller ?? this.seller,
        bonus: bonus ?? this.bonus,
        socials: socials ?? this.socials,
        workingDays: workingDays ?? this.workingDays,
        shopClosedDate: shopClosedDate ?? this.shopClosedDate,
        deliveryType: deliveryType ?? this.deliveryType,
      );

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      id: json["id"],
      uuid: json["uuid"],
      discountsCount: json["discounts_count"],
      userId: json["user_id"],
      tax: json["tax"],
      percentage: json["percentage"],
      phone: json["phone"],
      open: json["open"],
      deliveryType: json["delivery_type"],
      visibility: json["visibility"],
      verify: json["verify"],
      backgroundImg: json["background_img"],
      logoImg: json["logo_img"],
      minAmount: json["min_amount"],
      status: json["status"],
      statusNote: json["status_note"],
      deliveryTime: json["delivery_time"] == null
          ? null
          : DeliveryTime.fromJson(json["delivery_time"]),
      inviteLink: json["invite_link"],
      location: json["lat_long"] == null && json["location"] == null
          ? null
          : json["lat_long"] != null && json["lat_long"].isNotEmpty
              ? LocationModel.fromJson(json["lat_long"])
              : json["location"].runtimeType == Map
                  ? LocationModel.fromJson(json["location"])
                  : null,
      rCount: json["r_count"],
      rAvg: json["r_avg"]?.toDouble(),
      rSum: json["r_sum"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.tryParse(json["created_at"])?.toLocal(),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.tryParse(json["updated_at"])?.toLocal(),
      productsCount: json["products_count"],
      translation: json["translation"] == null
          ? null
          : Translation.fromJson(json["translation"]),
      translations: json["translations"] == null
          ? []
          : List<Translation>.from(
              json["translations"]!.map((x) => Translation.fromJson(x))),
      locales: json["locales"] == null
          ? []
          : List<String>.from(json["locales"]!.map((x) => x)),
      seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
      bonus: json["bonus"],
      socials: json["socials"] == null
          ? []
          : List<Social>.from(json["socials"]!.map((x) => Social.fromJson(x))),
      latLong: json["lat_long"].runtimeType == List
          ? List<double>.from(json["lat_long"])
          : [],
      workingDays: json["shop_working_days"] == null
          ? []
          : List<WorkingDay>.from(
              json["shop_working_days"]!.map((x) => WorkingDay.fromJson(x))),
      shopClosedDate: json["shop_closed_date"] == null
          ? []
          : List<dynamic>.from(json["shop_closed_date"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "discounts_count": discountsCount,
        "user_id": userId,
        "tax": tax,
        "delivery_type": deliveryType,
        "percentage": percentage,
        "phone": phone,
        "open": open,
        "visibility": visibility,
        "verify": verify,
        "background_img": backgroundImg,
        "logo_img": logoImg,
        "min_amount": minAmount,
        "status": status,
        "status_note": statusNote,
        "delivery_time": deliveryTime?.toJson(),
        "invite_link": inviteLink,
        "location": location?.toJson(),
        "r_count": rCount,
        "r_avg": rAvg,
        "r_sum": rSum,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "products_count": productsCount,
        "translation": translation?.toJson(),
        "translations": translations == null
            ? []
            : List<dynamic>.from(translations!.map((x) => x.toJson())),
        "lat_long":
            latLong == null ? [] : List<dynamic>.from(latLong!.map((x) => x)),
        "locales":
            locales == null ? [] : List<dynamic>.from(locales!.map((x) => x)),
        "seller": seller?.toJson(),
        "bonus": bonus,
        "socials":
            socials == null ? [] : List<dynamic>.from(socials!.map((x) => x)),
        "shop_working_days": workingDays == null
            ? []
            : List<dynamic>.from(workingDays!.map((x) => x.toJson())),
        "shop_closed_date": shopClosedDate == null
            ? []
            : List<dynamic>.from(shopClosedDate!.map((x) => x)),
      };
}

class DeliveryTime {
  DeliveryTime({
    this.to,
    this.from,
    this.type,
  });

  String? to;
  String? from;
  String? type;

  factory DeliveryTime.fromJson(Map<String, dynamic> json) => DeliveryTime(
        to: json["to"].toString(),
        from: json["from"].toString(),
        type: json["type"] ?? "min",
      );

  Map<String, dynamic> toJson() => {
        "to": to,
        "from": from,
        "type": type,
      };
}

class Social {
  int? id;
  int? shopId;
  String? type;
  String? content;
  String? img;
  DateTime? createdAt;
  DateTime? updatedAt;

  Social({
    this.id,
    this.shopId,
    this.type,
    this.content,
    this.img,
    this.createdAt,
    this.updatedAt,
  });

  Social copyWith({
    int? id,
    int? shopId,
    String? type,
    String? content,
    String? img,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Social(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        type: type ?? this.type,
        content: content ?? this.content,
        img: img ?? this.img,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        id: json["id"],
        shopId: json["shop_id"],
        type: json["type"],
        content: json["content"],
        img: json["img"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "type": type,
        "content": content,
        "img": img,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Seller {
  Seller({
    int? id,
    String? firstname,
    String? lastname,
    String? role,
  }) {
    _id = id;
    _firstname = firstname;
    _lastname = lastname;
    _role = role;
  }

  Seller.fromJson(dynamic json) {
    _id = json['id'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _role = json['role'];
  }

  int? _id;
  String? _firstname;
  String? _lastname;
  String? _role;

  Seller copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? role,
  }) =>
      Seller(
        id: id ?? _id,
        firstname: firstname ?? _firstname,
        lastname: lastname ?? _lastname,
        role: role ?? _role,
      );

  int? get id => _id;

  String? get firstname => _firstname;

  String? get lastname => _lastname;

  String? get role => _role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['role'] = _role;
    return map;
  }
}
