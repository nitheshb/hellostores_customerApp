import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/style.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? url;
  final String? preview;
  final String? name;
  final double height;
  final double width;
  final double radius;
  final double shimmerRadius;
  final BoxFit fit;
  final bool enableButton;

  const CustomNetworkImage({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    this.radius = AppConstants.radius,
    this.fit = BoxFit.cover,
    this.name,
    this.preview,
    this.enableButton = true,
    this.shimmerRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: preview != null
          ? Stack(
              children: [
                CachedNetworkImage(
                  height: height.r,
                  width: width.r,
                  imageUrl: preview ?? "",
                  fit: fit,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Container(
                      height: height.r,
                      width: width.r,
                      decoration: BoxDecoration(
                          color: CustomStyle.shimmerBase,
                          borderRadius: BorderRadius.circular(shimmerRadius.r)),
                      child: width > 58
                          ? Center(
                              child: Text(
                                AppHelpers.getTranslation(
                                    AppHelpers.getAppName()),
                                style: CustomStyle.interNormal(
                                    color: CustomStyle.textHint),
                              ),
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius.r),
                        color: name == null
                            ? CustomStyle.shimmerBase
                            : CustomStyle.primary,
                      ),
                      alignment: Alignment.center,
                      child: name == null
                          ? const Icon(FlutterRemix.file_unknow_line)
                          : Text(
                              name?.substring(0, 1) ?? "",
                              style: CustomStyle.interNormal(
                                  color: CustomStyle.white, size: height / 2.5),
                            ),
                    );
                  },
                ),
                if (enableButton)
                  Positioned.fill(
                    child: Center(
                      child: ButtonEffectAnimation(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoPage(url: url)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: CustomStyle.icon),
                              shape: BoxShape.circle),
                          child: Container(
                            margin: EdgeInsets.all(2.r),
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                                color: CustomStyle.primary.withOpacity(0.4),
                                shape: BoxShape.circle),
                            child: const Icon(
                              FlutterRemix.play_fill,
                              color: CustomStyle.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            )
          : AppHelpers.checkAvif(url)
              ? AvifImage.network(
                  url ?? '',
                  height: height.r,
                  fit: BoxFit.contain,
                )
              : CachedNetworkImage(
                  height: height.r,
                  width: width.r,
                  imageUrl: url ?? "",
                  fit: fit,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Container(
                      height: height.r,
                      width: width.r,
                      decoration: BoxDecoration(
                        color: CustomStyle.shimmerBase,
                      ),
                      child: width > 58
                          ? Center(
                              child: Text(
                                AppHelpers.getTranslation(
                                    AppHelpers.getAppName()),
                                style: CustomStyle.interNormal(
                                    color: CustomStyle.textHint),
                              ),
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius.r),
                        color: name == null
                            ? CustomStyle.shimmerBase
                            : CustomStyle.primary,
                      ),
                      alignment: Alignment.center,
                      child: name == null
                          ? const Icon(FlutterRemix.file_unknow_line)
                          : Text(
                              name?.substring(0, 1) ?? "",
                              style: CustomStyle.interNormal(
                                  color: CustomStyle.white, size: height / 2.5),
                            ),
                    );
                  },
                ),
    );
  }
}
