import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/profile/profile_bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class LogoutButton extends StatelessWidget {
  final CustomColorSet colors;

  const LogoutButton({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return ButtonEffectAnimation(
      onTap: () {
        if (LocalStorage.getToken().isEmpty) {
          AppRoute.goLogin(context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
            color: colors.newBoxColor,
            borderRadius: BorderRadius.circular(AppConstants.radius.r)),
        child: LocalStorage.getToken().isNotEmpty
            ? BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (p, n) {
                  return p.isLoading != n.isLoading;
                },
                builder: (context, state) {
                  return Row(
                    children: [
                      CustomNetworkImage(
                        url: LocalStorage.getUser().img,
                        name: LocalStorage.getUser().firstname ??
                            LocalStorage.getUser().lastname,
                        height: 50,
                        width: 50,
                        radius: 25,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocalStorage.getUser().firstname ?? "",
                              style: CustomStyle.interNoSemi(
                                  color: colors.textBlack, size: 18),
                              maxLines: 1,
                            ),
                            Text(
                              "${AppHelpers.getTranslation(TrKeys.id)}: ${LocalStorage.getUser().id}",
                              style: CustomStyle.interRegular(
                                  color: colors.textHint, size: 14),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            AppRoute.goLogin(context);
                            authRepository.logout();
                          },
                          icon: Icon(
                            FlutterRemix.logout_circle_r_line,
                            color: colors.textBlack,
                          ))
                    ],
                  );
                },
              )
            : Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.r),
                  child: Text(
                    AppHelpers.getTranslation(TrKeys.signIn),
                    style: CustomStyle.interNoSemi(
                        color: colors.textBlack, size: 16),
                  ),
                ),
              ),
      ),
    );
  }
}
