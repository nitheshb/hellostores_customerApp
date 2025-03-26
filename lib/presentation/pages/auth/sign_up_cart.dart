import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/auth/auth_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/infrastructure/firebase/firebase_service.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

import 'widgets/social_button.dart';

class SignUpCart extends StatefulWidget {
  final CustomColorSet colors;
  final TextEditingController phone;

  const SignUpCart({
    super.key,
    required this.colors,
    required this.phone,
  });

  @override
  State<SignUpCart> createState() => _SignUpCartState();
}

class _SignUpCartState extends State<SignUpCart> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380.r,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.signUp),
                  style: CustomStyle.interNoSemi(
                      color: widget.colors.textBlack, size: 30),
                ),
                32.verticalSpace,
                if (AppConstants.signUpType == SignUpType.email)
                  CustomTextFormField(
                    validation: AppValidators.isValidEmail,
                    controller: widget.phone,
                    hint: AppHelpers.getTranslation(TrKeys.email),
                    inputType: TextInputType.text,
                  ),
                if (AppConstants.signUpType == SignUpType.phone)
                  CustomTextFormField(
                    validation: AppValidators.isNotEmptyValidator,
                    controller: widget.phone,
                    hint: AppHelpers.getTranslation(TrKeys.phoneNumber),
                    inputType: TextInputType.phone,
                  ),
                if (AppConstants.signUpType == SignUpType.both)
                  CustomTextFormField(
                    validation: AppValidators.isNotEmptyValidator,
                    controller: widget.phone,
                    hint: AppHelpers.getTranslation(TrKeys.phoneNumberOrEmail),
                    inputType: TextInputType.text,
                  ),
                16.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (l, n) {
                    return l.isLoading != n.isLoading;
                  },
                  builder: (context, state) {
                    return CustomButton(
                        isLoading: state.isLoading,
                        title: AppHelpers.getTranslation(TrKeys.signUp),
                        bgColor: widget.colors.primary,
                        titleColor: CustomStyle.white,
                        onTap: () {
                          if (formKey.currentState?.validate() ?? false) {
                            if (AppHelpers.checkPhone(
                                widget.phone.text.replaceAll(" ", ""))) {
                              context.read<AuthBloc>().add(AuthEvent.checkPhone(
                                  context: context,
                                  phone: widget.phone.text,
                                  onSuccess: () {
                                    FirebaseService.sendCode(
                                        phone: widget.phone.text,
                                        onSuccess: (id) {
                                          context.read<AuthBloc>().add(
                                              AuthEvent.setVerificationId(
                                                  id: id));
                                        },
                                        onError: (e) {
                                          AppHelpers.errorSnackBar(
                                              context: context, message: e);
                                        });
                                  }));
                            } else {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthEvent.signUpEmail(
                                    context: context,
                                    email: widget.phone.text,
                                  ));
                            }
                          }
                        });
                  },
                ),
                16.verticalSpace,
                Divider(
                  color: widget.colors.icon,
                ),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: AppConstants.socialSignIn
                      .map((e) => SocialButton(
                            iconColor: widget.colors.textBlack,
                            bgColor: widget.colors.socialButtonColor,
                            icon: e,
                            onTap: () {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthEvent.socialSignIn(
                                      context: context,
                                      type: e,
                                      onSuccess: () {
                                        if (LocalStorage.getAddress() == null) {
                                          AppRoute.goSelectCountry(
                                              context: context);
                                          return;
                                        }
                                        if (AppConstants.isDemo &&
                                            LocalStorage.getUiType() == null) {
                                          AppRoute.goSelectUIType(
                                              context: context);
                                          return;
                                        }
                                        AppRoute.goMain(context);
                                      }));
                            },
                          ))
                      .toList(),
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
