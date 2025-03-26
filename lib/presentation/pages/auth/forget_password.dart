import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/auth/auth_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/infrastructure/firebase/firebase_service.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final CustomColorSet colors;
  final TextEditingController phone;

  const ForgetPasswordScreen(
      {super.key, required this.colors, required this.phone});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.r,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.forgetPassword),
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
                32.verticalSpace,
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (l, n) {
                    return l.isLoading != n.isLoading;
                  },
                  builder: (context, state) {
                    return CustomButton(
                        isLoading: state.isLoading,
                        title: AppHelpers.getTranslation(TrKeys.sendSmsCode),
                        bgColor: widget.colors.primary,
                        titleColor: CustomStyle.white,
                        onTap: () {
                          final event = context.read<AuthBloc>();
                          if (formKey.currentState?.validate() ?? false) {
                            if (AppValidators.isEmail(widget.phone.text)){
                              event.add(AuthEvent.forgotPassword(
                                  context: context,
                                  email: widget.phone.text,
                                  onSuccess: () {
                                    event.add(
                                        AuthEvent.setVerificationId(id: "id"));
                                  }));
                              return;
                            }
                            if (AppHelpers.checkPhone(
                                widget.phone.text.replaceAll(" ", ""))) {
                              event.add(AuthEvent.checkPhone(
                                  context: context,
                                  phone: widget.phone.text,
                                  onSuccess: () {
                                    FirebaseService.sendCode(
                                        phone: widget.phone.text,
                                        onSuccess: (id) {
                                          event.add(AuthEvent.setVerificationId(
                                              id: id));
                                        },
                                        onError: (e) {
                                          AppHelpers.errorSnackBar(
                                              context: context, message: e);
                                        });
                                  }));
                            } else {
                              AppHelpers.errorSnackBar(
                                  context: context,
                                  message: AppHelpers.getTranslation(
                                      TrKeys.thisNotPhoneNumber));
                            }
                          }
                        });
                  },
                ),
                32.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
