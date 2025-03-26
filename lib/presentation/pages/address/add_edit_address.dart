import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/address/address_bloc.dart';
import 'package:goshops/application/map/map_bloc.dart';
import 'package:goshops/infrastructure/model/request/add_user_address_model.dart';
import 'package:goshops/infrastructure/model/model/location_model.dart';
import 'package:goshops/infrastructure/model/response/city_pagination_response.dart';
import 'package:goshops/infrastructure/model/response/user_address_response.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/pages/map/map_page.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:phone_text_field/phone_text_field.dart';

class AddEditAddressPage extends StatefulWidget {
  final UserAddress? address;

  const AddEditAddressPage({super.key, this.address});

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController phone;
  late TextEditingController zipcode;
  late TextEditingController city;
  late TextEditingController homeNumber;
  late TextEditingController detail;
  late TextEditingController location;
  CityModel? cityModel;
  LocationModel? locationModel;

  @override
  void initState() {
    firstName = TextEditingController(text: widget.address?.firstname);
    lastName = TextEditingController(text: widget.address?.lastname);
    phone = TextEditingController(text: widget.address?.phone);
    zipcode = TextEditingController(text: widget.address?.zipcode);
    city = TextEditingController(
        text: widget.address?.cityModel?.translation?.title ??
            LocalStorage.getAddress()?.city);
    homeNumber = TextEditingController(text: widget.address?.streetHouseNumber);
    detail = TextEditingController(text: widget.address?.additionalDetails);
    location = TextEditingController(text: widget.address?.location?.address);
    cityModel = widget.address?.cityModel ??
        CityModel(id: LocalStorage.getAddress()?.cityId);
    locationModel = widget.address?.location;
    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    zipcode.dispose();
    city.dispose();
    homeNumber.dispose();
    detail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: (colors) => SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      PopButton(color: colors.textBlack),
                      8.horizontalSpace,
                      Text(
                        AppHelpers.getTranslation(TrKeys.addAddress),
                        style: CustomStyle.interNoSemi(
                            color: colors.textBlack, size: 18),
                      ),
                    ],
                  ),
                  24.verticalSpace,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: MediaQuery.viewInsetsOf(context),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.r),
                          child: Form(
                            key: form,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                        validation:
                                            AppValidators.isNotEmptyValidator,
                                        controller: firstName,
                                        hint: AppHelpers.getTranslation(
                                            TrKeys.firstName),
                                      ),
                                    ),
                                    16.horizontalSpace,
                                    Expanded(
                                      child: CustomTextFormField(
                                        validation:
                                            AppValidators.isNotEmptyValidator,
                                        controller: lastName,
                                        hint: AppHelpers.getTranslation(
                                            TrKeys.lastName),
                                      ),
                                    ),
                                  ],
                                ),
                                24.verticalSpace,
                                _phoneTextFormField(colors),
                                24.verticalSpace,
                                CustomTextFormField(
                                  validation: AppValidators.isNotEmptyValidator,
                                  controller: location,
                                  readOnly: true,
                                  onTap: () async {
                                    final data =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider(
                                                  create: (context) =>
                                                      MapBloc()),
                                            ],
                                            child: MapPage(
                                              location: locationModel,
                                            )),
                                      ),
                                    );
                                    if (data.runtimeType == LocationModel) {
                                      location.text =
                                          (data as LocationModel).address ?? "";
                                      locationModel = data;
                                    }
                                  },
                                  hint: AppHelpers.getTranslation(
                                      TrKeys.locationInMap),
                                ),
                                24.verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                        validation:
                                            AppValidators.isNotEmptyValidator,
                                        controller: zipcode,
                                        hint: AppHelpers.getTranslation(
                                            TrKeys.zipCode),
                                        inputType: TextInputType.number,
                                      ),
                                    ),
                                    16.horizontalSpace,
                                    Expanded(
                                      child: CustomTextFormField(
                                        validation:
                                            AppValidators.isNotEmptyValidator,
                                        readOnly: city.text.isNotEmpty,
                                        controller: city,
                                        hint: AppHelpers.getTranslation(
                                            TrKeys.city),
                                      ),
                                    ),
                                  ],
                                ),
                                24.verticalSpace,
                                CustomTextFormField(
                                  validation: AppValidators.isNotEmptyValidator,
                                  controller: homeNumber,
                                  hint: AppHelpers.getTranslation(
                                      TrKeys.homeNumber),
                                ),
                                16.verticalSpace,
                                CustomTextFormField(
                                  validation: AppValidators.isNotEmptyValidator,
                                  controller: detail,
                                  hint:
                                      AppHelpers.getTranslation(TrKeys.detail),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    child: BlocBuilder<AddressBloc, AddressState>(
                      builder: (context, state) {
                        return CustomButton(
                            isLoading: state.isButtonLoading,
                            title: AppHelpers.getTranslation(
                                widget.address?.id == null
                                    ? TrKeys.save
                                    : TrKeys.edit),
                            bgColor: colors.primary,
                            titleColor: colors.white,
                            onTap: () {
                              if (form.currentState?.validate() ?? false) {
                                if (widget.address?.id != null) {
                                  context
                                      .read<AddressBloc>()
                                      .add(AddressEvent.editAddress(
                                          context: context,
                                          addUserAddress: AddUserAddressModel(
                                            firstName: firstName.text,
                                            lastName: lastName.text,
                                            phone: phone.text,
                                            zipcode: zipcode.text,
                                            city:
                                                cityModel?.id.toString() ?? "",
                                            homeNumber: homeNumber.text,
                                            detail: detail.text,
                                            locationModel: locationModel,
                                          ),
                                          onSuccess: () {
                                            Navigator.pop(context);
                                          },
                                          addressId: widget.address?.id));
                                  return;
                                }
                                context
                                    .read<AddressBloc>()
                                    .add(AddressEvent.addAddress(
                                      context: context,
                                      addUserAddress: AddUserAddressModel(
                                        firstName: firstName.text,
                                        lastName: lastName.text,
                                        phone: phone.text,
                                        zipcode: zipcode.text,
                                        city: cityModel?.id.toString(),
                                        homeNumber: homeNumber.text,
                                        detail: detail.text,
                                        locationModel: locationModel,
                                      ),
                                      onSuccess: () {
                                        Navigator.pop(context);
                                      },
                                    ));
                              }
                            });
                      },
                    ),
                  )
                ],
              ),
            ));
  }

  PhoneTextField _phoneTextFormField(CustomColorSet colors) {
    return PhoneTextField(
      initialValue: phone.text,
      initialCountryCode: LocalStorage.getAddress()?.countryCode?.toUpperCase(),
      textStyle: CustomStyle.interNormal(color: colors.textBlack),
      invalidNumberMessage: AppHelpers.getTranslation(TrKeys.invalidPhone),
      decoration: InputDecoration(
        hintText: AppHelpers.getTranslation(TrKeys.phoneNumber),
        hintStyle: CustomStyle.interNormal(
          size: 14.sp,
          color: CustomStyle.textHint,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: CustomStyle.black,
        filled: false,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.merge(
                const BorderSide(color: CustomStyle.icon),
                const BorderSide(color: CustomStyle.icon)),
            borderRadius: BorderRadius.circular(AppConstants.radius.r)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide.merge(
                const BorderSide(color: CustomStyle.icon),
                const BorderSide(color: CustomStyle.icon)),
            borderRadius: BorderRadius.circular(AppConstants.radius.r)),
        border: OutlineInputBorder(
            borderSide: BorderSide.merge(
                const BorderSide(color: CustomStyle.icon),
                const BorderSide(color: CustomStyle.icon)),
            borderRadius: BorderRadius.circular(AppConstants.radius.r)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide.merge(
                const BorderSide(color: CustomStyle.icon),
                const BorderSide(color: CustomStyle.icon)),
            borderRadius: BorderRadius.circular(AppConstants.radius.r)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide.merge(
                const BorderSide(color: CustomStyle.icon),
                const BorderSide(color: CustomStyle.icon)),
            borderRadius: BorderRadius.circular(AppConstants.radius.r)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.merge(
                const BorderSide(color: CustomStyle.icon),
                const BorderSide(color: CustomStyle.icon)),
            borderRadius: BorderRadius.circular(AppConstants.radius.r)),
      ),
      onChanged: (s) {
        phone.text = s.completeNumber;
      },
    );
  }
}
