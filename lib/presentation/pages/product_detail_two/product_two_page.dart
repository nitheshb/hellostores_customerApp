import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/product_detail/product_detail_bloc.dart';
import 'package:goshops/infrastructure/model/model/review_data.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/pages/product_detail/widgets/bottom_widget.dart';
import 'package:goshops/presentation/pages/product_detail_one/widgets/related_and_viewed_products_one.dart';
import 'package:goshops/presentation/pages/product_detail_two/widgets/description_screen_two.dart';
import 'package:goshops/presentation/style/style.dart';

import 'widgets/image_screen_two.dart';
import 'widgets/product_extras_two.dart';
import 'widgets/product_info_two.dart';
import 'widgets/product_title_two.dart';

class ProductTwoPage extends StatefulWidget {
  const ProductTwoPage({super.key});

  @override
  State<ProductTwoPage> createState() => _ProductTwoPageState();
}

class _ProductTwoPageState extends State<ProductTwoPage> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: (colors) => BlocConsumer<ProductDetailBloc, ProductDetailState>(
        listenWhen: (p, n) {
          return p.selectImage?.id != n.selectImage?.id ||
              p.galleries.length != n.galleries.length;
        },
        listener: (context, state) {
          if (state.galleries.length == 1) {
            return;
          }
          if (!state.jumpTo) {
            pageController.jumpToPage(
                state.galleries.indexOf(state.selectImage ?? Galleries()));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 170.r),
                  child: Column(
                    children: [
                      ImageTwoScreen(
                        controller: pageController,
                        colors: colors,
                        product: state.product,
                        selectImage: state.selectImage,
                        galleries: state.galleries,
                      ),
                      20.verticalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductTitleTwo(
                            product: state.product,
                            colors: colors,
                            selectStock: state.selectedStock,
                          ),
                          ProductExtrasTwo(
                            list: state.galleries,
                            stocks: state.product?.stocks ?? [],
                            types: state.typedExtras,
                            colors: colors,
                            selectStock: state.selectedStock,
                          ),
                          DescriptionTwoScreen(
                            colors: colors,
                            product: state.product,
                            selectStock: state.selectedStock,
                          ),
                          ProductInfoTwo(
                            colors: colors,
                            product: state.product,
                          ),
                          RelatedAndViewedProductsOne(
                            colors: colors,
                            list: state.buyWithProduct,
                            title:
                                AppHelpers.getTranslation(TrKeys.withThisProductAlsoBuy),
                          ),
                          RelatedAndViewedProductsOne(
                            colors: colors,
                            list: state.relatedProduct,
                            title: AppHelpers.getTranslation(TrKeys.relatedProducts),
                          ),
                          RelatedAndViewedProductsOne(
                            colors: colors,
                            list: state.viewedProduct,
                            title: AppHelpers.getTranslation(TrKeys.historyView),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 4.r + MediaQuery.paddingOf(context).top,
                left: 16.r,
                child: BlurWrap(
                  radius: BorderRadius.circular(32.r),
                  child: Container(
                    color: colors.textBlack.withOpacity(0.5),
                    child: const PopButton(
                      color: CustomStyle.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingButton: (colors) =>
          BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          return BottomWidget(
            selectStock: state.selectedStock,
            colors: colors,
            product: state.product,
          );
        },
      ),
    );
  }
}
