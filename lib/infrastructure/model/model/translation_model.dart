class Translation {
  Translation({
    int? id,
    String? locale,
    String? title,
    String? description,
    String? shortDesc,
    String? address,
    String? img,
  }) {
    _id = id;
    _img = img;
    _locale = locale;
    _title = title;
    _description = description;
    _shortDesc = shortDesc;
    _address = address;
  }

  Translation.fromJson(dynamic json) {
    _id = json?['id'];
    _locale = json?['locale'];
    _title = json?['title'];
    _img = json?['img'];
    _description = json?['description'];
    _shortDesc = json?['short_desc'] ?? json?['faq'];
    _address = json?['address'];
  }

  int? _id;
  String? _locale;
  String? _title;
  String? _description;
  String? _shortDesc;
  String? _address;
  String? _img;

  Translation copyWith({
    int? id,
    String? locale,
    String? title,
    String? img,
    String? description,
    String? shortDesc,
    String? address,
  }) =>
      Translation(
        id: id ?? _id,
        img: img ?? _img,
        locale: locale ?? _locale,
        title: title ?? _title,
        description: description ?? _description,
        shortDesc: shortDesc ?? _shortDesc,
        address: address ?? _address,
      );

  int? get id => _id;

  String? get locale => _locale;

  String? get img => _img;

  String? get title => _title;

  String? get description => _description;

  String? get shortDesc => _shortDesc;

  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['img'] = _img;
    map['locale'] = _locale;
    map['title'] = _title;
    map['description'] = _description;
    map['short_desc'] = _shortDesc;
    map['address'] = _address;
    return map;
  }
}
