part of 'select_bloc.dart';

@freezed
class SelectEvent with _$SelectEvent {
  const factory SelectEvent.changeIndex({required int selectIndex}) =
      ChangeIndex;

  const factory SelectEvent.selectIds({required List<int> ids}) = SelectIds;
  const factory SelectEvent.selectId({required int? id}) = SelectId;
}
