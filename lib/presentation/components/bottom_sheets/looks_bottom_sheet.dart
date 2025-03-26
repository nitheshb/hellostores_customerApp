import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/banner/banner_bloc.dart';
import 'package:goshops/infrastructure/model/response/banners_paginate_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';

class LooksBottomSheet extends StatelessWidget {
  final BannerData look;

  const LooksBottomSheet({super.key, required this.look});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: TrKeys.looks,
      ),
      body: (colors) => SingleChildScrollView(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            16.verticalSpace,
            CustomNetworkImage(
              url: look.galleries?.first.path,
              preview: look.galleries?.first.preview,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
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
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return VerticalProductItem(
                            product: state.products[index],
                            addAndRemove: () {
                              context
                                  .read<BannerBloc>()
                                  .add(const BannerEvent.updateProduct());
                            },
                          );
                        });
              },
            ),
            Divider(
              color: colors.textHint,
            ),
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
            16.verticalSpace,
            BlocBuilder<BannerBloc, BannerState>(
              builder: (context, state) {
                return CustomButton(
                    title: AppHelpers.getTranslation(TrKeys.buyAllProduct),
                    bgColor: colors.black,
                    titleColor: colors.white,
                    onTap: () {
                      for (var element in state.products) {
                        AppHelpers.addProduct(
                            context: context,
                            product: element,
                            stock: element.stocks?.first);
                      }
                      AppRoute.goCartPage(context);
                    });
              },
            ),
            48.verticalSpace,
          ],
        ),
      ),
    );
  }
}
