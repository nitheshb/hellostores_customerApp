import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/components/shimmer/products_shimmer.dart';
import 'package:goshops/presentation/pages/products/widgets/simple_list_page.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage>
    with SingleTickerProviderStateMixin {
  late RefreshController discountRefresh;
  late RefreshController likeRefresh;
  late TabController tabController;
  final isLtr = LocalStorage.getLangLtr();

  List<Tab> listTabs = [
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(FlutterRemix.heart_3_fill),
          6.horizontalSpace,
          Text(AppHelpers.getTranslation(TrKeys.likedProduct)),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(FlutterRemix.gift_2_fill),
          6.horizontalSpace,
          Text(AppHelpers.getTranslation(TrKeys.discount)),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    tabController = TabController(length: listTabs.length, vsync: this);
    discountRefresh = RefreshController();
    likeRefresh = RefreshController();
    context.read<ProductBloc>()
      ..add(ProductEvent.fetchLikeProduct(context: context))
      ..add(
          ProductEvent.fetchDiscountProduct(context: context, isRefresh: true));
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    discountRefresh.dispose();
    likeRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: TrKeys.likedProduct,
      ),
      body: (colors) => SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return _like(state, colors, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget discount(
      ProductState state, BuildContext context, CustomColorSet colors) {
    return state.isLoadingDiscount
        ? const ProductsShimmer()
        : state.isLoadingDiscount || state.discountProduct.isNotEmpty
            ? SimpleListPage(
                list: state.discountProduct,
                refreshController: discountRefresh,
                onLoading: () {
                  context.read<ProductBloc>().add(
                      ProductEvent.fetchDiscountProduct(
                          context: context, controller: discountRefresh));
                },
                onRefresh: () {
                  context.read<ProductBloc>().add(
                      ProductEvent.fetchDiscountProduct(
                          context: context,
                          controller: discountRefresh,
                          isRefresh: true));
                },
              )
            : _noItem(colors);
  }

  Widget _like(
      ProductState state, CustomColorSet colors, BuildContext context) {
    return state.isLoadingLike
        ? const ProductsShimmer()
        : state.isLoadingLike || state.likeProducts.isNotEmpty
            ? SimpleListPage(
                list: state.likeProducts,
                refreshController: likeRefresh,
                onRefresh: () {
                  context.read<ProductBloc>().add(ProductEvent.fetchLikeProduct(
                      context: context,
                      controller: likeRefresh,
                      isRefresh: true));
                },
              )
            : _noItem(colors);
  }

  Widget _noItem(CustomColorSet colors) {
    return Center(
      child: Column(
        children: [
          Lottie.asset('assets/lottie/noItem.json'),
          16.verticalSpace,
          Text(
            AppHelpers.getTranslation(TrKeys.noProduct),
            style: CustomStyle.interNoSemi(
              color: colors.textBlack,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
