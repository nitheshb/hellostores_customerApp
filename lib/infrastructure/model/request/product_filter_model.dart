import 'package:goshops/infrastructure/local_storage/local_storage.dart';

class ProductFilterModel {
  final String? query;
  final int? categoryId;
  final int? brandId;
  final int? shopId;
  final int? bannerId;
  final bool? isNew;
  final bool? isPopular;
  final bool? isMostSold;
  final bool? priceMin;
  final bool? priceMax;
  final List<int>? brandIds;
  final List<int>? categoryIds;
  final List<int>? extrasId;
  final num? priceTo;
  final num? priceFrom;
  final int page;

  ProductFilterModel({
    this.query,
    this.categoryId,
    this.brandId,
    this.shopId,
    this.bannerId,
    this.isNew,
    this.isPopular,
    this.isMostSold,
    this.priceMax,
    this.priceMin,
    this.brandIds,
    this.categoryIds,
    this.extrasId,
    this.priceTo,
    this.priceFrom,
    required this.page,
  });

  factory ProductFilterModel.fromJson({
    String? query,
    int? categoryId,
    int? brandId,
    int? shopId,
    int? bannerId,
    bool? isNew,
    bool? priceMax,
    bool? priceMin,
    bool? isPopular,
    bool? isMostSold,
    List<int>? brandIds,
    List<int>? categoryIds,
    List<int>? extrasId,
    num? priceTo,
    num? priceFrom,
    required int page,
  }) {
    return ProductFilterModel(
      query: query,
      categoryId: categoryId,
      brandId: brandId,
      shopId: shopId,
      bannerId: bannerId,
      isNew: isNew,
      priceMax: priceMax,
      priceMin: priceMin,
      isPopular: isPopular,
      isMostSold: isMostSold,
      brandIds: brandIds,
      categoryIds: categoryIds,
      extrasId: extrasId,
      priceTo: priceTo,
      priceFrom: priceFrom,
      page: page,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (query != null) 'search': query,
      'perPage': 10,
      "page": page,
      if (categoryIds != null)
        for (int i = 0; i < (categoryIds?.length ?? 0); i++)
          'category_ids[$i]': categoryIds?[i],
      if (brandIds != null)
        for (int i = 0; i < (brandIds?.length ?? 0); i++)
          if (brandIds?[i] != -1) 'brand_ids[$i]': brandIds?[i],
      if (extrasId != null)
        for (int i = 0; i < (extrasId?.length ?? 0); i++)
          'extras[$i]': extrasId?[i],
      if (priceTo != null) "price_to": priceTo,
      if (priceFrom != null) 'price_from': priceFrom,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
      if (shopId != null) 'shop_id': shopId,
      if (bannerId != null) 'banner_id': bannerId,
      if (isNew ?? false) "column": "created_at",
      if (isNew ?? false) 'sort': 'desc',
      if (isMostSold ?? false) "column": "od_count",
      if (isMostSold ?? false) 'sort': 'desc',
      // if (isPopular ?? false) "column": "r_avg",
      // if (isPopular ?? false) 'sort': 'desc',
      if (isPopular ?? false) 'popular': 1,
      if ((priceMin ?? false) ||( priceMax ?? false)) "column_price": "price",
      if (priceMin ?? false) 'sort': 'asc',
      if (priceMax ?? false) 'sort': 'desc',
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      if (LocalStorage.getAddress()?.regionId != null)
        "region_id": LocalStorage.getAddress()?.regionId,
      if (LocalStorage.getAddress()?.countryId != null)
        'country_id': LocalStorage.getAddress()?.countryId,
      if (LocalStorage.getAddress()?.cityId != null)
        'city_id': LocalStorage.getAddress()?.cityId,
    };
  }
}
