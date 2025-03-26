import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/components/product_items/product_item.dart';
import 'package:goshops/presentation/components/shimmer/h_product_shimmer.dart';
import 'package:goshops/presentation/components/title.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:lottie/lottie.dart';

class NewShopsProductList extends StatelessWidget {
  final CustomColorSet colors;
  final int? shopId;

  const NewShopsProductList(
      {super.key, required this.colors, required this.shopId})
     ;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return state.newShopProduct.isNotEmpty || state.isLoadingNew
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  32.verticalSpace,
                  TitleWidget(
                    title: AppHelpers.getTranslation(TrKeys.newArrivals),
                    titleColor: colors.textBlack,
                    rightTitle: TrKeys.seeAll,
                    onTap: () async {
                      await AppRoute.goProductList(
                          context: context,
                          list: state.newShopProduct,
                          title: AppHelpers.getTranslation(TrKeys.newArrivals),
                          isNew: true,
                          isMostSale: false,
                          shopId: shopId);
                      if (context.mounted) {
                        context
                            .read<ProductBloc>()
                            .add(const ProductEvent.updateState());
                      }
                    },
                  ),
                  16.verticalSpace,
                  SizedBox(
                    height: 330.r,
                    child: !state.isLoadingNew
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.r),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.newShopProduct.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8.r),
                                child: ProductItem(
                                  product: state.newShopProduct[index],
                                ),
                              );
                            })
                        : const HProductShimmer(),
                  )
                ],
              )
            : (state.newShopProduct.isNotEmpty || state.isLoadingNew)
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      42.verticalSpace,
                      Lottie.asset("assets/lottie/empty_list.json"),
                      24.verticalSpace,
                      Text(
                        AppHelpers.getTranslation(TrKeys.thereAreNoProductsThereYet),
                        style: CustomStyle.interNormal(color: colors.textBlack),
                      )
                    ],
                  );
      },
    );
  }
}
