import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/banner/banner_bloc.dart';
import 'package:goshops/application/blog/blog_bloc.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/application/category/category_bloc.dart';
import 'package:goshops/application/main/main_bloc.dart';
import 'package:goshops/application/notification/notification_bloc.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/pages/home/widgets/popular_product.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'widgets/discount_banner_list.dart';
import 'widgets/invite_item.dart';
import 'widgets/main_category_circle.dart';
import 'widgets/main_category_item.dart';
import 'widgets/main_category_list.dart';
import 'widgets/most_product.dart';
import 'widgets/ads_list.dart';
import 'widgets/all_product_list.dart';
import 'widgets/banner_list.dart';
import 'widgets/looks_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RefreshController categoryRefresh;
  late RefreshController productRefresh;
  late RefreshController looksRefresh;
  late RefreshController adsRefresh;
  late RefreshController bannerRefresh;
  late RefreshController discountRefresh;
  late PageController pageController;
  late ScrollController scrollController;

  void listen() {
    final direction = scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      context.read<MainBloc>().add(const MainEvent.showSearch(value: false));
    } else if (direction == ScrollDirection.forward) {
      context.read<MainBloc>().add(const MainEvent.showSearch(value: true));
    }
  }

  @override
  void initState() {
    categoryRefresh = RefreshController();
    productRefresh = RefreshController();
    looksRefresh = RefreshController();
    adsRefresh = RefreshController();
    bannerRefresh = RefreshController();
    discountRefresh = RefreshController();
    pageController = PageController();
    scrollController = ScrollController();
    scrollController.addListener(listen);
    super.initState();
  }

  @override
  void dispose() {
    categoryRefresh.dispose();
    productRefresh.dispose();
    pageController.dispose();
    looksRefresh.dispose();
    adsRefresh.dispose();
    bannerRefresh.dispose();
    discountRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => _buildAppBar(colors),
      body: (colors) {
        return SmartRefresher(
          controller: productRefresh,
          enablePullUp: true,
          onRefresh: () {
            context.read<CategoryBloc>().add(CategoryEvent.fetchCategory(
                context: context, isRefresh: true, controller: productRefresh));
            context.read<ProductBloc>()
              ..add(ProductEvent.fetchMostSaleProduct(
                  context: context,
                  isRefresh: true,
                  controller: productRefresh))
              ..add(ProductEvent.fetchPopularProduct(
                  context: context,
                  isRefresh: true,
                  controller: productRefresh))
              ..add(ProductEvent.fetchNewProduct(
                  context: context,
                  isRefresh: true,
                  controller: productRefresh))
              ..add(ProductEvent.fetchAllProduct(
                  context: context,
                  isRefresh: true,
                  controller: productRefresh));
            context.read<BlogBloc>().add(BlogEvent.fetchBlog(
                context: context, isRefresh: true, controller: productRefresh));
            context.read<BannerBloc>()
              ..add(BannerEvent.fetchBanner(
                  context: context,
                  isRefresh: true,
                  controller: productRefresh))
              ..add(BannerEvent.fetchDiscount(
                  context: context,
                  isRefresh: true,
                  controller: productRefresh))
              ..add(BannerEvent.fetchLooks(
                  context: context,
                  isRefresh: true,
                  controller: productRefresh))
              ..add(BannerEvent.fetchAdsBanner(
                  context: context,
                  isRefresh: true,
                  controller: productRefresh));
            productRefresh.resetNoData();
          },
          onLoading: () {
            context.read<ProductBloc>().add(ProductEvent.fetchNewProduct(
                context: context, controller: productRefresh));
          },
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 12.r),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: BlocBuilder<MainBloc, MainState>(
                  buildWhen: (p, n) {
                    return p.isShowSearch != n.isShowSearch;
                  },
                  builder: (context, state) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: state.isShowSearch ? 46.r : 0,
                      child: state.isShowSearch
                          ? CustomTextFormField(
                              onTap: () {
                                AppRoute.goSearchPage(context: context);
                              },
                              fillColor: colors.newBoxColor,
                              readOnly: true,
                              prefixIcon: const Icon(
                                FlutterRemix.search_2_line,
                                color: CustomStyle.textHint,
                              ),
                              hint: AppHelpers.getTranslation(TrKeys.search),
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ),
              12.verticalSpace,
              Padding(
                padding: REdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          AppRoute.goCategoryListPage(context: context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 24.r,
                              width: 24.r,
                              decoration: BoxDecoration(
                                color: CustomStyle.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radius.r,
                                ),
                              ),
                              child: Icon(
                                Icons.grid_view,
                                color: colors.textBlack,
                                size: 18.r,
                              ),
                            ),
                            6.horizontalSpace,
                            Text(
                              AppHelpers.getTranslation(TrKeys.categories),
                              style: CustomStyle.interNormal(
                                color: colors.textBlack,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      FlutterRemix.arrow_down_s_line,
                      color: colors.textBlack,
                      size: 18.r,
                    ),
                    8.horizontalSpace,
                    Container(
                      color: colors.textBlack,
                      width: 1.w,
                      height: 28.h,
                    ),
                    8.horizontalSpace,
                    InkWell(
                      onTap: () {
                        AppRoute.goSelectCountry(context: context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FlutterRemix.map_pin_2_line,
                            color: colors.textBlack,
                            size: 18.r,
                          ),
                          4.horizontalSpace,
                          AutoSizeText(
                            "${LocalStorage.getAddress()?.country ?? ''}${LocalStorage.getAddress()?.city != null ? ',' : ''} ${LocalStorage.getAddress()?.city ?? ''}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: CustomStyle.interNormal(
                                color: colors.textBlack, size: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              8.verticalSpace,
              const Divider(color: CustomStyle.dividerColor),
              BannerList(
                pageController: pageController,
                colors: colors,
                controller: bannerRefresh,
                onLoading: () {
                  context.read<BannerBloc>().add(BannerEvent.fetchBanner(
                      context: context, controller: bannerRefresh));
                },
              ),
              16.verticalSpace,
              MainCategoryList(colors: colors),
              PopularList(colors: colors),
              DiscountBannerList(
                pageController: pageController,
                colors: colors,
                controller: discountRefresh,
                onLoading: () {
                  context.read<BannerBloc>().add(BannerEvent.fetchDiscount(
                      context: context, controller: discountRefresh));
                },
              ),
              MainCategoryItem(colors: colors),
              LooksList(
                colors: colors,
                controller: looksRefresh,
                onLoading: () {
                  context.read<BannerBloc>().add(BannerEvent.fetchLooks(
                      context: context, controller: looksRefresh));
                },
              ),
              MostProductList(colors: colors),
              MainCategoryCircleItem(colors: colors),
               const InviteItem(),
              // NewProductList(colors: colors),
              AdsList(
                colors: colors,
                controller: adsRefresh,
                onLoading: () {
                  context.read<BannerBloc>().add(BannerEvent.fetchAdsBanner(
                      context: context, controller: adsRefresh));
                },
              ),
              // BrandsList(
              //   brandRefresh: bannerRefresh,
              //   colors: colors,
              // ),
              // BlogList(colors: colors),
              AllProductList(colors: colors),
              80.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(CustomColorSet colors) {
    return AppBar(
      backgroundColor: colors.backgroundColor,
      elevation: 0.0,
      actions: [
        IconButton(
            onPressed: () => AppRoute.goCartPage(context),
            icon: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return Badge(
                  isLabelVisible: LocalStorage.getCartList()
                      .where((element) => element.count > 0)
                      .isNotEmpty,
                  label: LocalStorage.getCartList()
                          .where((element) => element.count > 0)
                          .isEmpty
                      ? const Text("0")
                      : Text(
                          LocalStorage.getCartList()
                              .where((element) => element.count > 0)
                              .length
                              .toString(),
                          style: CustomStyle.interNormal(
                              color: colors.white, size: 10),
                        ),
                  child: Icon(
                    FlutterRemix.shopping_cart_line,
                    color: colors.textBlack,
                  ),
                );
              },
            )),
        IconButton(
            onPressed: () {
              if (LocalStorage.getToken().isEmpty) {
                AppRoute.goLogin(context);
                return;
              }
              AppRoute.goNotification(context: context);
            },
            icon: Badge(
              label: (LocalStorage.getToken().isEmpty)
                  ? const Text("0")
                  : BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, state) {
                        return Text(state.countOfNotifications?.notification
                                .toString() ??
                            "0");
                      },
                    ),
              child: Icon(
                FlutterRemix.notification_line,
                color: colors.textBlack,
              ),
            )),
      ],
      centerTitle: false,
      title: Text(
        AppHelpers.getAppName(),
        style: CustomStyle.interSemi(color: colors.textBlack, size: 15),
      ),
    );
  }
}
