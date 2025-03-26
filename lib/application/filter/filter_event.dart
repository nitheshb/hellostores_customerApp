part of 'filter_bloc.dart';

@freezed
abstract class FilterEvent with _$FilterEvent {
  const factory FilterEvent.selectType({required LayoutType selectType}) =
      SelectType;

  const factory FilterEvent.selectSort({required FilterType type}) =
      SelectSort;

  const factory FilterEvent.fetchExtras(
      {required BuildContext context,
      String? type,
      required bool isPrice,
      int? categoryId,
      int? shopId}) = FetchExtras;

  const factory FilterEvent.setExtras({required List<int> ids}) = SetExtras;

  const factory FilterEvent.setRangePrice({required RangeValues price}) =
      SetRangePrice;

  const factory FilterEvent.setCategory({required CategoryData category}) = SetCategory;

  const factory FilterEvent.setBrands({required List<int> ids}) = SetBrands;

  const factory FilterEvent.clearFilter() = ClearFilter;
}
