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

class UpdatePasswordScreen extends StatefulWidget {
  final CustomColorSet colors;
  final String phone;

  const UpdatePasswordScreen(
      {super.key, required this.colors, required this.phone});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  late TextEditingController password;
  late TextEditingController confirmPassword;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    confirmPassword = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    confirmPassword.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360.r,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.updatePassword),
                  style: CustomStyle.interNoSemi(
                      color: widget.colors.textBlack, size: 30),
                ),
                32.verticalSpace,
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
                24.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (l, n) {
                    return l.isLoading != n.isLoading;
                  },
                  builder: (context, state) {
                    return CustomButton(
                        title: AppHelpers.getTranslation(TrKeys.updatePassword),
                        bgColor: widget.colors.primary,
                        titleColor: CustomStyle.white,
                        isLoading: state.isLoading,
                        onTap: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context
                                .read<AuthBloc>()
                                .add(AuthEvent.forgotPasswordAfter(
                                    context: context,
                                    phone: widget.phone,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
