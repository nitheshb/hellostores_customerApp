import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/product_detail/product_detail_bloc.dart';
import 'package:goshops/infrastructure/model/model/review_data.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/style/style.dart';

import 'widgets/bottom_widget.dart';
import 'widgets/image_screen.dart';
import 'widgets/product_extras.dart';
import 'widgets/product_info.dart';
import 'widgets/related_and_viewed_products.dart';
import 'widgets/shop_item.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late PageController pageController;
  late ScrollController scrollController;

  @override
  void initState() {
    pageController = PageController();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
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
          if (!state.nextImageTo) {
            scrollController.animateTo(
                state.galleries.indexOf(state.selectImage ?? Galleries()) *
                    44.r,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear);
          }
          if (scrollController.position.maxScrollExtent >
              state.galleries.indexOf(state.selectImage ?? Galleries()) *
                  44.r) {
            scrollController.animateTo(
                state.galleries.indexOf(state.selectImage ?? Galleries()) *
                    44.r,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 120.r),
                  child: Column(
                    children: [
                      ImageScreen(
                        scrollController: scrollController,
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
                          ShopItem(
                            colors: colors,
                            shop: state.product?.shop,
                          ),
                          20.verticalSpace,
                          Padding(
                            padding: REdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              state.product?.translation?.title ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: CustomStyle.interNormal(
                                color: colors.textBlack,
                                size: 18
                              ),
                            ),
                          ),
                          22.verticalSpace,
                          ProductExtras(
                            list: state.galleries,
                            stocks: state.product?.stocks ?? [],
                            types: state.typedExtras,
                            colors: colors,
                            selectStock: state.selectedStock,
                            product: state.product,
                          ),
                          ProductInfo(
                            colors: colors,
                            product: state.product,
                          ),
                          RelatedAndViewedProducts(
                            colors: colors,
                            list: state.relatedProduct,
                            title: TrKeys.relatedProducts,
                          ),
                          RelatedAndViewedProducts(
                            colors: colors,
                            list: state.viewedProduct,
                            title: TrKeys.historyView,
                          ),
                          RelatedAndViewedProducts(
                            colors: colors,
                            list: state.buyWithProduct,
                            title: TrKeys.withThisProductAlsoBuy,
                          )
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
                    color: CustomStyle.black.withOpacity(0.5),
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
