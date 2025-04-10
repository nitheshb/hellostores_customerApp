import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/infrastructure/model/model/blog_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/service/time_service.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme_wrapper.dart';
import 'button/animation_button_effect.dart';
import 'custom_network_image.dart';

class BlogItem extends StatelessWidget {
  final BlogData blog;
  final bool isHomePage;

  const BlogItem({super.key, required this.blog, this.isHomePage = true})
     ;

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(builder: (colors, controller) {
      return ButtonEffectAnimation(
        onTap: () {
          if (isHomePage) {
            AppRoute.goBlogPage(context, blog);
            return;
          }
          AppRoute.goBlogPage(context, blog);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 8.r),
          height: 254.r,
          width: MediaQuery.sizeOf(context).width - 100,
          decoration: BoxDecoration(
              border: Border.all(color: colors.icon),
              borderRadius: BorderRadius.circular(AppConstants.radius.r),
              color: CustomStyle.icon),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppConstants.radius.r),
                    topLeft: Radius.circular(AppConstants.radius.r)),
                child: CustomNetworkImage(
                    url: blog.img,
                    height: 160,
                    width: double.infinity,
                    radius: 0),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog.translation?.title ?? "",
                        style: CustomStyle.interNormal(
                            color: colors.textBlack, size: 16),
                      ),
                      const Spacer(),
                      Text(
                        TimeService.dateFormatDMY(blog.updatedAt),
                        style: CustomStyle.interRegular(
                            color: colors.textBlack, size: 14),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
