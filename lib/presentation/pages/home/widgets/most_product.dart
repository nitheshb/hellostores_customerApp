import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/components/product_items/product_item.dart';
import 'package:goshops/presentation/components/title.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

import '../../../components/shimmer/h_product_shimmer.dart';

class MostProductList extends StatelessWidget {
  final CustomColorSet colors;

  const MostProductList({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return state.mostSaleProduct.isNotEmpty || state.isLoadingMostSale
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  32.verticalSpace,
                  TitleWidget(
                   subTitle: TrKeys.bestSale,
                    title: AppHelpers.getTranslation(TrKeys.mostSales),
                    titleColor: colors.textBlack,
                    rightTitle: TrKeys.seeAll,
                    onTap: () async {
                      await AppRoute.goProductList(
                        context: context,
                        list: state.mostSaleProduct,
                        title: AppHelpers.getTranslation(TrKeys.mostSales),
                        total: state.mostSaleProductCount,
                        isNew: false,
                        isMostSale: true,
                      );
                      if (context.mounted) {
                        context
                            .read<ProductBloc>()
                            .add(const ProductEvent.updateState());
                      }
                    },
                  ),
                  16.verticalSpace,
                  SizedBox(
                    height: 312.r,
                    child: !state.isLoadingMostSale
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.r),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.mostSaleProduct.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8.r),
                                child: ProductItem(
                                  product: state.mostSaleProduct[index],
                                ),
                              );
                            })
                        : const HProductShimmer(),
                  )
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
