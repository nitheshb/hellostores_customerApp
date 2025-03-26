import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import 'widgets/social_button.dart';

class LoginCart extends StatefulWidget {
  final CustomColorSet colors;

  const LoginCart({super.key, required this.colors});

  @override
  State<LoginCart> createState() => _LoginCartState();
}

class _LoginCartState extends State<LoginCart> {
  late TextEditingController phone;
  late TextEditingController password;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    phone = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 560.r,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.login),
                style: CustomStyle.interNoSemi(
                    color: widget.colors.textBlack, size: 30),
              ),
              32.verticalSpace,
              CustomTextFormField(
                validation: AppValidators.isNotEmptyValidator,
                controller: phone,
                hint:
                    AppHelpers.getTranslation(TrKeys.phoneNumberOrEmail),
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
                    hint: AppHelpers.getTranslation(TrKeys.password),
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
                  );
                },
              ),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonEffectAnimation(
                    onTap: () {
                      context.read<AuthBloc>().add(
                          const AuthEvent.switchScreen(
                              AuthType.forgetPassword));
                    },
                    child: Text(
                      '${AppHelpers.getTranslation(TrKeys.forgetPassword)}?',
                      style: CustomStyle.interNormal(
                          color: widget.colors.textBlack, size: 14),
                    ),
                  ),
                ],
              ),
              32.verticalSpace,
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (l, n) {
                  return l.isLoading != n.isLoading;
                },
                builder: (context, state) {
                  return CustomButton(
                      isLoading: state.isLoading,
                      title: AppHelpers.getTranslation(TrKeys.signIn),
                      bgColor: widget.colors.primary,
                      titleColor: CustomStyle.white,
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {
                          context.read<AuthBloc>().add(AuthEvent.login(
                              context: context,
                              phone: phone.text,
                              password: password.text,
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
                        }
                      });
                },
              ),
              78.verticalSpace,
              Divider(color: widget.colors.icon),
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: AppConstants.socialSignIn
                    .map((e) => SocialButton(
                          iconColor: widget.colors.textBlack,
                          bgColor: widget.colors.socialButtonColor,
                          icon: e,
                          onTap: () {
                            context.read<AuthBloc>().add(AuthEvent.socialSignIn(
                                context: context,
                                type: e,
                                onSuccess: () {
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
                                }));
                          },
                        ))
                    .toList(),
              ),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
