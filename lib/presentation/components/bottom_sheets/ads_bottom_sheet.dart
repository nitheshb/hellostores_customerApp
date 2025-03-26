import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/banner/banner_bloc.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/model/response/banners_paginate_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/style.dart';

class AdsBottomSheet extends StatelessWidget {
  final BannerData look;

  const AdsBottomSheet({super.key, required this.look});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: look.translation?.title ?? TrKeys.ads,
      ),
      body: (colors) => Container(
        padding: EdgeInsets.all(16.r),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomNetworkImage(
              url: look.galleries?.first.path,
              preview: look.galleries?.first.preview,
              height: 300,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              radius: AppConstants.radiusMax,
            ),
            16.verticalSpace,
            Text(
              look.translation?.description ?? "",
              style: CustomStyle.interNormal(
                color: colors.textBlack,
                size: 18,
              ),
            ),
            16.verticalSpace,
            BlocBuilder<BannerBloc, BannerState>(
              buildWhen: (p, n) {
                return p.isLoadingProduct != n.isLoadingProduct;
              },
              builder: (context, state) {
                return state.isLoadingProduct
                    ? const Loading()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.shopAds.length,
                        itemBuilder: (context, index) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state
                                      .shopAds[index].shopAdsProducts?.length ??
                                  0,
                              itemBuilder: (context, productIndex) {
                                return VerticalProductItem(
                                  product: state.shopAds[index]
                                          .shopAdsProducts?[productIndex] ??
                                      ProductData(),
                                  addAndRemove: () {
                                    context
                                        .read<BannerBloc>()
                                        .add(const BannerEvent.updateProduct());
                                  },
                                );
                              });
                        });
              },
            ),
            const Divider(),
            Text(
              AppHelpers.getTranslation(TrKeys.description),
              style: CustomStyle.interNormal(
                color: colors.textBlack,
                size: 16,
              ),
            ),
            8.verticalSpace,
            Text(
              look.translation?.description ?? "",
              style: CustomStyle.interRegular(
                color: colors.textBlack,
                size: 14,
              ),
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
