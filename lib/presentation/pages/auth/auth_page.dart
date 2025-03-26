import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/auth/auth_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/firebase/firebase_service.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/pages/auth/confirm_screen.dart';
import 'package:goshops/presentation/pages/auth/forget_password.dart';
import 'package:goshops/presentation/pages/auth/login_cart.dart';
import 'package:goshops/presentation/pages/auth/sign_up_cart.dart';
import 'package:goshops/presentation/pages/auth/sign_up_field_cart.dart';
import 'package:goshops/presentation/pages/auth/update_password.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late TextEditingController phone;

  @override
  void initState() {
    phone = TextEditingController();
    FirebaseService.initDynamicLinks(context);
    super.initState();
  }

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage(AppConstants.loginBg),
          //   fit: BoxFit.cover,
          // ),
          ),
      child: CustomScaffold(
        body: (colors) => SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            child: Column(
              children: [
                16.verticalSpace,
                Row(
                  children: [
                    Text(
                      AppHelpers.getAppName(),
                      style: CustomStyle.interNormal(color: colors.textBlack),
                    ),
                    const Spacer(),
                    SecondButton(
                      title: AppHelpers.getTranslation(TrKeys.skip),
                      bgColor: colors.newBoxColor,
                      titleColor: colors.textBlack,
                      onTap: () {
                        if (LocalStorage.getAddress() == null) {
                          AppRoute.goSelectCountry(context: context);
                          return;
                        }
                        if (AppConstants.isDemo &&
                            LocalStorage.getUiType() == null) {
                          AppRoute.goSelectUIType(context: context);
                          return;
                        }
                        AppRoute.goMain(context);
                      },
                    )
                  ],
                ),
                48.verticalSpace,
                Container(
                  margin: MediaQuery.viewInsetsOf(context),
                  child: BlurWrap(
                    radius: BorderRadius.circular(AppConstants.radiusMax.r),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: colors.backgroundColor.withOpacity(0.8),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMax.r)),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        buildWhen: (l, n) {
                          return l.screenType != n.screenType;
                        },
                        builder: (context, state) {
                          switch (state.screenType) {
                            case AuthType.login:
                              return LoginCart(colors: colors);
                            case AuthType.signUpSendCode:
                              return SignUpCart(
                                colors: colors,
                                phone: phone,
                              );
                            case AuthType.confirm:
                              return ConfirmScreen(
                                colors: colors,
                                phone: phone.text,
                                isReset: state.isReset,
                                email: AppHelpers.checkPhone(phone.text)
                                    ? null
                                    : phone.text,
                              );
                            case AuthType.signUpFull:
                              return SignUpFieldCart(
                                phone: phone.text,
                                colors: colors,
                                isPhone: AppHelpers.checkPhone(
                                    phone.text.replaceAll(" ", "")),
                              );
                            case AuthType.forgetPassword:
                              return ForgetPasswordScreen(
                                  colors: colors, phone: phone);
                            case AuthType.updatePassword:
                              return UpdatePasswordScreen(
                                colors: colors,
                                phone: phone.text,
                              );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (l, n) {
                    return l.screenType != n.screenType;
                  },
                  builder: (context, state) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppHelpers.getTranslation(
                              state.screenType == AuthType.login
                                  ? "${TrKeys.dontHaveAnAcc}?"
                                  : TrKeys.doHaveAnAcc),
                          style:
                              CustomStyle.interRegular(color: colors.textBlack),
                        ),
                        4.horizontalSpace,
                        GestureDetector(
                          onTap: () {
                            context.read<AuthBloc>().add(
                                  AuthEvent.switchScreen(
                                      state.screenType != AuthType.login
                                          ? AuthType.login
                                          : AuthType.signUpSendCode),
                                );
                          },
                          child: Text(
                            AppHelpers.getTranslation(
                                state.screenType == AuthType.login
                                    ? TrKeys.signUp
                                    : TrKeys.signIn),
                            style: CustomStyle.interRegular(
                                color: colors.textBlack),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
