import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/auth/auth_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class SignUpFieldCart extends StatefulWidget {
  final CustomColorSet colors;
  final bool isPhone;
  final String phone;

  const SignUpFieldCart(
      {super.key,
      required this.colors,
      required this.isPhone,
      required this.phone})
     ;

  @override
  State<SignUpFieldCart> createState() => _SignUpFieldCartState();
}

class _SignUpFieldCartState extends State<SignUpFieldCart> {
  late TextEditingController firstName;
  late TextEditingController userName;
  late TextEditingController phone;
  late TextEditingController email;
  late TextEditingController referral;
  late TextEditingController password;
  late TextEditingController confirmPassword;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    firstName = TextEditingController();
    userName = TextEditingController();
    phone = TextEditingController();
    email = TextEditingController();
    confirmPassword = TextEditingController();
    password = TextEditingController();
    referral = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    userName.dispose();
    phone.dispose();
    email.dispose();
    confirmPassword.dispose();
    password.dispose();
    referral.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height - 200.r,
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
                CustomTextFormField(
                  validation: AppValidators.isNotEmptyValidator,
                  controller: firstName,
                  hint: AppHelpers.getTranslation(TrKeys.fullName),
                ),
                16.verticalSpace,
                CustomTextFormField(
                  validation: AppValidators.isNotEmptyValidator,
                  controller: userName,
                  hint: AppHelpers.getTranslation(TrKeys.userName),
                ),
                16.verticalSpace,
                if (!widget.isPhone)
                  CustomTextFormField(
                    validation: AppValidators.isNotEmptyValidator,
                    controller: phone,
                    hint: AppHelpers.getTranslation(TrKeys.phoneNumber),
                  ),
                16.verticalSpace,
                if (widget.isPhone)
                  CustomTextFormField(
                    validation: AppValidators.isValidEmail,
                    controller: email,
                    hint: AppHelpers.getTranslation(TrKeys.email),
                  ),
                16.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (l, n) {
                    return l.isShowPassword != n.isShowPassword;
                  },
                  builder: (context, state) {
                    return CustomTextFormField(
                      obscure: state.isShowPassword,
                      controller: password,
                      validation: AppValidators.isValidPassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEvent.showPassword());
                        },
                        icon: Icon(
                          !state.isShowPassword
                              ? FlutterRemix.eye_close_line
                              : FlutterRemix.eye_line,
                          color: widget.colors.textBlack,
                        ),
                      ),
                      hint: AppHelpers.getTranslation(TrKeys.password),
                    );
                  },
                ),
                16.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (l, n) {
                    return l.isShowConfirmPassword != n.isShowConfirmPassword;
                  },
                  builder: (context, state) {
                    return CustomTextFormField(
                      obscure: state.isShowConfirmPassword,
                      controller: confirmPassword,
                      validation: (s) => AppValidators.isValidConfirmPassword(
                          password.text, s),
                      suffixIcon: IconButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEvent.showConfirmPassword());
                        },
                        icon: Icon(
                          !state.isShowConfirmPassword
                              ? FlutterRemix.eye_close_line
                              : FlutterRemix.eye_line,
                          color: widget.colors.textBlack,
                        ),
                      ),
                      hint: AppHelpers.getTranslation(TrKeys.confirmPassword),
                    );
                  },
                ),
                16.verticalSpace,
                CustomTextFormField(
                  controller: referral,
                  hint: AppHelpers.getTranslation(TrKeys.referral),
                ),
                16.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (l, n) {
                    return l.isLoading != n.isLoading;
                  },
                  builder: (context, state) {
                    return CustomButton(
                        title: AppHelpers.getTranslation(TrKeys.signUp),
                        bgColor: widget.colors.primary,
                        titleColor: CustomStyle.white,
                        isLoading: state.isLoading,
                        onTap: () {
                          if (formKey.currentState?.validate() ?? false) {
                            if (LocalStorage.getToken().isNotEmpty) {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthEvent.signUpWithData(
                                    context: context,
                                    firstname: firstName.text,
                                    lastname: userName.text,
                                    phone: phone.text,
                                    password: password.text,
                                    referral: referral.text,
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
                                    },
                                  ));
                              return;
                            }
                            context.read<AuthBloc>().add(AuthEvent.signUp(
                                  context: context,
                                  firstname: firstName.text,
                                  lastname: userName.text,
                                  email: email.text,
                                  phone: widget.phone,
                                  password: password.text,
                                  referral: referral.text,
                                  onSuccess: () {
                                    if (LocalStorage.getAddress() == null) {
                                      AppRoute.goSelectCountry(
                                          context: context);
                                      return;
                                    }
                                    if (AppConstants.isDemo &&
                                        LocalStorage.getUiType() == null) {
                                      AppRoute.goSelectUIType(context: context);
                                      return;
                                    }
                                    AppRoute.goMain(context);
                                  },
                                ));
                          }
                        });
                  },
                ),
                KeyboardVisibilityBuilder(builder: (s, isKeyboard) {
                  return isKeyboard ? 200.verticalSpace : 24.verticalSpace;
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
