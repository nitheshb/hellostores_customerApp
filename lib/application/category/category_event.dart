part of 'category_bloc.dart';

@freezed
abstract class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.fetchCategory(
      {required BuildContext context,
      bool? isRefresh,
      int? shopId,
      RefreshController? controller}) = FetchCategory;

  const factory CategoryEvent.selectCategory(
      {required BuildContext context, CategoryData? category}) = SelectCategory;

  const factory CategoryEvent.selectOnlyCategory(
      {required BuildContext context,
      CategoryData? category}) = SelectOnlyCategory;

  const factory CategoryEvent.selectCategoryTwo(
      {required BuildContext context,
      CategoryData? category}) = SelectCategoryTwo;
}
