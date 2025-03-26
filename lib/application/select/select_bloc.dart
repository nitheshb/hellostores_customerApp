// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_event.dart';

part 'select_state.dart';

part 'select_bloc.freezed.dart';

class SelectBloc extends Bloc<SelectEvent, SelectState> {
  SelectBloc() : super(const SelectState()) {
    on<ChangeIndex>(changeIndex);
    on<SelectIds>(selectIds);
    on<SelectId>(selectId);
  }

  changeIndex(event, emit) {
    emit(state.copyWith(selectIndex: event.selectIndex));
  }

  selectIds(event, emit) {
    List<int> list = [];
    list.addAll(event.ids);
    emit(state.copyWith(selectIds: list));
  }

  selectId(event, emit) {
    List<int> list = List.from(state.selectIds);
    if (list.contains(event.id)) {
      list.remove(event.id);
    } else {
      list.add(event.id);
    }
    emit(state.copyWith(selectIds: list));
  }
}
