import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/infrastructure/service/enums.dart';

class FilterModel {
  final String type;
  final List<int>? shopId;
  final List<int>? brandId;
  final List<int>? categoryId;
  final List<int>? extrasId;
  final num? priceTo;
  final num? priceFrom;
  final int? parentId;
  final FilterType filterType;

  FilterModel({
    required this.type,
    this.shopId,
    this.brandId,
    this.categoryId,
    this.extrasId,
    this.priceTo,
    this.priceFrom,
    this.parentId,
    required this.filterType,
  });

  factory FilterModel.fromJson({
    required String type,
    required List<int>? shopId,
    required List<int>? brandId,
    required List<int>? categoryId,
    required List<int>? extrasId,
    required num priceTo,
    required num priceFrom,
    required int parentId,
    required FilterType filterType,
  }) {
    return FilterModel(
      type: type,
      shopId: shopId,
      brandId: brandId,
      categoryId: categoryId,
      extrasId: extrasId,
      priceTo: priceTo,
      priceFrom: priceFrom,
      parentId: parentId,
      filterType: filterType,
    );
  }

  Map<String, dynamic> toJson() {
    List listOfCategory = [];
    listOfCategory.addAll(categoryId ?? []);
    if (parentId != null) {
      listOfCategory.add(parentId);
    }
    return {
      for (int i = 0; i < listOfCategory.length; i++)
        'category_ids[$i]': listOfCategory[i],
      if (brandId != null)
        for (int i = 0; i < (brandId?.length ?? 0); i++)
          if (brandId?[i] != -1) 'brand_ids[$i]': brandId?[i],
      if (shopId != null)
        for (int i = 0; i < (shopId?.length ?? 0); i++)
          'shop_ids[$i]': shopId?[i],
      if (extrasId != null)
        for (int i = 0; i < (extrasId?.length ?? 0); i++)
          'extras[$i]': extrasId?[i],
      if (priceTo != null) "price_to": priceTo,
      if (priceFrom != null) 'price_from': priceFrom,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'type': type,
      if (filterType == FilterType.popular) 'popular': 1,
      if (filterType == FilterType.news) "column": "created_at",
      if (filterType == FilterType.news) 'sort': 'desc',
      if (filterType == FilterType.mostSold) "column": "od_count",
      if (filterType == FilterType.mostSold) 'sort': 'desc',
      if (filterType == FilterType.priceMin ||
          filterType == FilterType.priceMax)
        "column_price": "price",
      if (filterType == FilterType.priceMin) 'sort': 'asc',
      if (filterType == FilterType.priceMax) 'sort': 'desc',
      if (LocalStorage.getAddress()?.regionId != null)
        "region_id": LocalStorage.getAddress()?.regionId,
      if (LocalStorage.getAddress()?.countryId != null)
        'country_id': LocalStorage.getAddress()?.countryId,
      if (LocalStorage.getAddress()?.cityId != null)
        'city_id': LocalStorage.getAddress()?.cityId,
    };
  }
}
