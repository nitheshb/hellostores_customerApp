part of 'address_bloc.dart';

@freezed
abstract class AddressEvent with _$AddressEvent {

  const factory AddressEvent.searchAddress({
    required BuildContext context,
    String? search,
  }) = SearchAddress;

  const factory AddressEvent.selectAddress({
    required BuildContext context,
    required int index,
  }) = SelectAddress;

  const factory AddressEvent.editAddress({
    required BuildContext context,
    required AddUserAddressModel addUserAddress,
    required int? addressId,
    VoidCallback? onSuccess
  }) = EditAddress;


  const factory AddressEvent.addAddress({
    required BuildContext context,
    required AddUserAddressModel addUserAddress,
    VoidCallback? onSuccess
  }) = AddAddress;

  const factory AddressEvent.fetchUserAddress(
      {required BuildContext context,
        bool? isRefresh,
        RefreshController? controller}) = FetchUserAddress;


  const factory AddressEvent.fetchCountry(
      {required BuildContext context,
      bool? isRefresh,
      RefreshController? controller}) = FetchCountry;

  const factory AddressEvent.searchCountry({
    required BuildContext context,
    String? search,
  }) = SearchCountry;

  const factory AddressEvent.fetchCity(
      {required BuildContext context,
      required int countyId,
      bool? isRefresh,
      RefreshController? controller}) = FetchCity;

  const factory AddressEvent.searchCity({
    required BuildContext context,
    required int countyId,
    String? search,
  }) = SearchCity;
}
