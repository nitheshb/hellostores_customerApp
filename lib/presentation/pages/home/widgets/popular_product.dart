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

class PopularList extends StatelessWidget {
  final CustomColorSet colors;

  const PopularList({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return state.popularProduct.isNotEmpty || state.isLoadingPopular
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  32.verticalSpace,
                  TitleWidget(
                    subTitle: TrKeys.bestRate,
                    title: AppHelpers.getTranslation(TrKeys.popular),
                    titleColor: colors.textBlack,
                    rightTitle: TrKeys.seeAll,
                    onTap: () async {
                      await AppRoute.goProductList(
                        context: context,
                        list: state.popularProduct,
                        title: AppHelpers.getTranslation(TrKeys.popular),
                        total: state.popularProductCount,
                        isPopular: true,
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
                    height: 316.r,
                    child: !state.isLoadingMostSale
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.r),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.popularProduct.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8.r),
                                child: ProductItem(
                                  product: state.popularProduct[index],
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
