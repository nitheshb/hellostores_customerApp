import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/review/review_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class CommentButton extends StatelessWidget {
  final CustomColorSet colors;
  final TextEditingController controller;
  final int? shopId;
  final int? blogId;
  final int? productId;
  final int? orderId;
  final String? productUuid;

  const CommentButton(
      {super.key,
      required this.colors,
      required this.controller,
      this.shopId,
      this.productUuid,
      this.productId,
      this.blogId,
      this.orderId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            return state.listOfImage.isNotEmpty
                ? SizedBox(
                    height: 48.r,
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 8.r),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.listOfImage.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 4.r),
                            height: 48.r,
                            width: 48.r,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                  File(state.listOfImage[index]),
                                ),
                              ),
                            ),
                          );
                        }))
                : const SizedBox.shrink();
          },
        ),
        Container(
          decoration: BoxDecoration(
              color: colors.textWhite,
              borderRadius: BorderRadius.circular(AppConstants.radius.r)),
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              BlocBuilder<ReviewBloc, ReviewState>(
                buildWhen: (p, n) {
                  return p.review != n.review;
                },
                builder: (context, state) {
                  return Text(
                    "${AppHelpers.getTranslation(TrKeys.yourRating)} – ${state.review.toInt()} ${AppHelpers.getTranslation(TrKeys.outOf)} 5",
                    style: CustomStyle.interNormal(
                        color: colors.textBlack, size: 12),
                  );
                },
              ),
              const Spacer(),
              RatingBar.builder(
                unratedColor: colors.textHint,
                initialRating: 3,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 24.r,
                glowColor: CustomStyle.rate,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.r),
                onRatingUpdate: (rating) {
                  context
                      .read<ReviewBloc>()
                      .add(ReviewEvent.setReview(review: rating));
                },
                itemBuilder: (BuildContext context, int index) {
                  return const Icon(
                    FlutterRemix.star_smile_fill,
                    color: CustomStyle.rate,
                  );
                },
              )
            ],
          ),
        ),
        8.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                AppHelpers.openDialogImagePicker(
                  context: context,
                  openCamera: () async {
                    String? titleImg = await ImgService.getCamera();
                    if (context.mounted && (titleImg != null)) {
                      context
                          .read<ReviewBloc>()
                          .add(ReviewEvent.setImage(imagePath: titleImg));
                      Navigator.pop(context);
                    }
                  },
                  openGallery: () async {
                    String? titleImg = await ImgService.getGallery();
                    if (context.mounted && (titleImg != null)) {
                      context
                          .read<ReviewBloc>()
                          .add(ReviewEvent.setImage(imagePath: titleImg));
                      Navigator.pop(context);
                    }
                  },
                );
              },
              child: Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMax),
                    border: Border.all(color: colors.icon)),
                child: Icon(
                  FlutterRemix.attachment_2,
                  size: 18.r,
                  color: colors.textBlack,
                ),
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Container(
                height: 48.r,
                margin: EdgeInsets.only(bottom: 8.r),
                padding: REdgeInsets.only(right: 16, left: 8.r),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.icon),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMax.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        autocorrect: true,
                        controller: controller,
                        cursorWidth: 1.r,
                        cursorColor: colors.textBlack,
                        style: CustomStyle.interNormal(
                          size: 14,
                          letterSpacing: -0.2,
                          color: colors.textBlack,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: CustomStyle.interNormal(
                            size: 12,
                            letterSpacing: -0.2,
                            color: colors.textHint,
                          ),
                          hintText:
                              AppHelpers.getTranslation(TrKeys.typeSomething),
                        ),
                      ),
                    ),
                    BlocBuilder<ReviewBloc, ReviewState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            if (state.isButtonLoading) {
                              return;
                            }
                            context.read<ReviewBloc>().add(
                                  ReviewEvent.sendReview(
                                    context: context,
                                    comment: controller.text,
                                    shopId: shopId,
                                    blogId: blogId,
                                    orderId: orderId,
                                    productUuid: productUuid,
                                    onSuccess: () {
                                      controller.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                          },
                          child: SizedBox(
                            width: 42.r,
                            height: 42.r,
                            child: state.isButtonLoading
                                ? const Loading()
                                : Icon(
                                    FlutterRemix.send_plane_2_fill,
                                    size: 18.r,
                                    color: colors.textBlack,
                                  ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
