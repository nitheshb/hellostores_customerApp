import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/components/product_items/product_item.dart';
import 'package:goshops/presentation/components/title.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class AllProductList extends StatelessWidget {
  final CustomColorSet colors;

  const AllProductList({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            32.verticalSpace,
            TitleWidget(
              title: AppHelpers.getTranslation(TrKeys.newArrivals),
              titleColor: colors.textBlack,
              // rightTitle: TrKeys.seeAll,
              onTap: () async {
                await AppRoute.goProductList(
                  context: context,
                  list: state.newProduct,
                  title: AppHelpers.getTranslation(TrKeys.newArrivals),
                  total: state.newProductCount,
                  isNew: true,
                  isMostSale: false,
                );
                if (context.mounted) {
                  context
                      .read<ProductBloc>()
                      .add(const ProductEvent.updateState());
                }
              },
            ),
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(right: 16.r, left: 16.r, top: 16.r),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.8.r,
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.r,
                  mainAxisExtent: 328.h,
                ),
                itemCount: state.newProduct.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.r),
                    child: ProductItem(
                      width: MediaQuery.sizeOf(context).width,
                      product: state.newProduct[index],
                    ),
                  );
                }),
          ],
        );
      },
    );
  }
}
