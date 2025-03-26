part of 'cart_bloc.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default(false) bool isLoading,
    @Default(false) bool isButtonLoading,
    @Default(null) Cart? cart,
    @Default([]) List<ProductNote>? notes,
    @Default({}) Map<int, String> coupons,
    @Default(false) bool isAcceptTerm,
    @Default(null) CartCalculate? cartCalculate,
    @Default(null) String? groupOrderLink,
    @Default(null) ProductCalculateResponse? productCalculate,
  }) = _CartState;
}
