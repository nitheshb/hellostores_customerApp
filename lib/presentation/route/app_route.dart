import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/address/address_bloc.dart';
import 'package:goshops/application/auth/auth_bloc.dart';
import 'package:goshops/application/banner/banner_bloc.dart';
import 'package:goshops/application/become_seller/become_seller_bloc.dart';
import 'package:goshops/application/blog/blog_bloc.dart';
import 'package:goshops/application/brand/brand_bloc.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/application/category/category_bloc.dart';
import 'package:goshops/application/chat/chat_bloc.dart';
import 'package:goshops/application/checkout/checkout_bloc.dart';
import 'package:goshops/application/compare/compare_bloc.dart';
import 'package:goshops/application/filter/filter_bloc.dart';
import 'package:goshops/application/game/game_bloc.dart';
import 'package:goshops/application/main/main_bloc.dart';
import 'package:goshops/application/maksekeskus/maksekeskus_bloc.dart';
import 'package:goshops/application/map/map_bloc.dart';
import 'package:goshops/application/notification/notification_bloc.dart';
import 'package:goshops/application/order/order_bloc.dart';
import 'package:goshops/application/parcel/parcel_bloc.dart';
import 'package:goshops/application/parcels_list/parcels_list_bloc.dart';
import 'package:goshops/application/product_detail/product_detail_bloc.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/application/profile/profile_bloc.dart';
import 'package:goshops/application/review/review_bloc.dart';
import 'package:goshops/application/search/search_bloc.dart';
import 'package:goshops/application/shop/shop_bloc.dart';
import 'package:goshops/application/wallet/wallet_bloc.dart';
import 'package:goshops/infrastructure/model/model/blog_model.dart';
import 'package:goshops/infrastructure/model/request/create_order_model.dart';
import 'package:goshops/infrastructure/model/model/order_model.dart';
import 'package:goshops/infrastructure/model/model/parcel_order_model.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/model/model/review_data.dart';
import 'package:goshops/infrastructure/model/model/shop_model.dart';
import 'package:goshops/infrastructure/model/response/banners_paginate_response.dart';
import 'package:goshops/infrastructure/model/response/cart_response.dart';
import 'package:goshops/infrastructure/model/response/categories_paginate_response.dart';
import 'package:goshops/infrastructure/model/response/delivery_point_response.dart';
import 'package:goshops/infrastructure/model/response/notification_response.dart';
import 'package:goshops/infrastructure/model/response/refund_pagination_response.dart';
import 'package:goshops/infrastructure/model/response/user_address_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/game/game.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/bottom_sheets/ads_bottom_sheet.dart';
import 'package:goshops/presentation/components/bottom_sheets/looks_bottom_sheet.dart';
import 'package:goshops/presentation/components/select_ui_type.dart';
import 'package:goshops/presentation/pages/address/add_edit_address.dart';
import 'package:goshops/presentation/pages/address/search_address_page.dart';
import 'package:goshops/presentation/pages/cart/cart_page.dart';
import 'package:goshops/presentation/pages/category/more_categories_page.dart';
import 'package:goshops/presentation/pages/checkout/failure_page.dart';
import 'package:goshops/presentation/pages/checkout/maksekeskus_screen.dart';
import 'package:goshops/presentation/pages/checkout/widget/select_delivery_point.dart';
import 'package:goshops/presentation/pages/compare/compare_list_page.dart';
import 'package:goshops/presentation/pages/compare/compare_product_page.dart';
import 'package:goshops/presentation/pages/country/city_page.dart';
import 'package:goshops/presentation/pages/country/country_page.dart';
import 'package:goshops/presentation/pages/menu/app_info/app_info.dart';
import 'package:goshops/presentation/pages/menu/app_info/help_policy_term/help_page.dart';
import 'package:goshops/presentation/pages/menu/app_info/help_policy_term/policy_page.dart';
import 'package:goshops/presentation/pages/menu/app_info/help_policy_term/term_page.dart';
import 'package:goshops/presentation/pages/menu/menu_page.dart';
import 'package:goshops/presentation/pages/like/like_page.dart';
import 'package:goshops/presentation/pages/menu/become_seller/become_seller.dart';
import 'package:goshops/presentation/pages/menu/blog/blog_list_page.dart';
import 'package:goshops/presentation/pages/menu/blog/blog_screen.dart';
import 'package:goshops/presentation/pages/menu/group_order/group_order_page.dart';
import 'package:goshops/presentation/pages/menu/my_digital_files/my_digital_list.dart';
import 'package:goshops/presentation/pages/menu/profile/change_password.dart';
import 'package:goshops/presentation/pages/menu/profile/edit_account.dart';
import 'package:goshops/presentation/pages/menu/profile/my_account.dart';
import 'package:goshops/presentation/pages/menu/profile/referral_page.dart';
import 'package:goshops/presentation/pages/menu/transactions/transaction_list.dart';
import 'package:goshops/presentation/pages/notification/widgets/notification_bottom_sheet.dart';
import 'package:goshops/presentation/pages/menu/app_setting/app_setting.dart';
import 'package:goshops/presentation/pages/menu/app_setting/widgets/currency.dart';
import 'package:goshops/presentation/pages/menu/app_setting/widgets/language.dart';
import 'package:goshops/presentation/pages/auth/auth_page.dart';
import 'package:goshops/presentation/pages/cart/widget/note_product.dart';
import 'package:goshops/presentation/pages/category/search_page.dart';
import 'package:goshops/presentation/pages/chat/chat_list_page.dart';
import 'package:goshops/presentation/pages/chat/chat_page.dart';
import 'package:goshops/presentation/pages/checkout/checkout_page.dart';
import 'package:goshops/presentation/pages/checkout/congrats_page.dart';
import 'package:goshops/presentation/pages/checkout/widget/select_date.dart';
import 'package:goshops/presentation/pages/filter/filter_page.dart';
import 'package:goshops/presentation/pages/main/main_page.dart';
import 'package:goshops/presentation/pages/map/map_page.dart';
import 'package:goshops/presentation/pages/notification/notification_page.dart';
import 'package:goshops/presentation/pages/order/order_screen.dart';
import 'package:goshops/presentation/pages/order/orders_list.dart';
import 'package:goshops/presentation/components/web_view.dart';
import 'package:goshops/presentation/pages/order/refund_screen.dart';
import 'package:goshops/presentation/pages/parcel/parcel_list_page.dart';
import 'package:goshops/presentation/pages/parcel/parcel_order_page.dart';
import 'package:goshops/presentation/pages/parcel/parcel_page.dart';
import 'package:goshops/presentation/pages/parcel/widgets/info_screen.dart';
import 'package:goshops/presentation/pages/products/products_list_page.dart';
import 'package:goshops/presentation/pages/review/review_page.dart';
import 'package:goshops/presentation/pages/review/widgets/review_images.dart';
import 'package:goshops/presentation/pages/shop/shop_page.dart';
import 'package:goshops/presentation/pages/story/story_page.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../application/story/story_bloc.dart';
import '../pages/category/category_list_page.dart';
import '../pages/product_detail/product_page.dart';
import '../pages/product_detail/widgets/only_image.dart';
import '../pages/product_detail_one/product_one_page.dart';
import '../pages/product_detail_two/product_two_page.dart';

abstract class AppRoute {
  AppRoute._();

  static goMain(BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<MainBloc>(create: (context) => MainBloc()),
                BlocProvider<ProfileBloc>(
                  create: (context) => ProfileBloc(),
                ),
                BlocProvider<CategoryBloc>(
                  create: (context) => CategoryBloc()
                    ..add(CategoryEvent.fetchCategory(
                        context: context, isRefresh: true)),
                ),
                BlocProvider<ShopBloc>(
                  create: (context) => ShopBloc()
                    ..add(ShopEvent.fetchShops(
                        context: context, isRefresh: true)),
                ),
                BlocProvider<StoryBloc>(
                  create: (context) => StoryBloc()
                    ..add(StoryEvent.fetchStory(
                        context: context, isRefresh: true)),
                ),
                BlocProvider<ProductBloc>(
                  create: (context) => ProductBloc()
                    ..add(ProductEvent.fetchMostSaleProduct(
                        context: context, isRefresh: true))
                    ..add(ProductEvent.fetchPopularProduct(
                        context: context, isRefresh: true))
                    ..add(ProductEvent.fetchNewProduct(
                        context: context, isRefresh: true))
                    ..add(ProductEvent.fetchAllProduct(
                        context: context, isRefresh: true)),
                ),
                BlocProvider<BlogBloc>(
                  create: (context) => BlogBloc()
                    ..add(
                        BlogEvent.fetchBlog(context: context, isRefresh: true)),
                ),
                BlocProvider<BannerBloc>(
                  create: (context) => BannerBloc()
                    ..add(BannerEvent.fetchBanner(
                        context: context, isRefresh: true))
                    ..add(BannerEvent.fetchDiscount(
                        context: context, isRefresh: true))
                    ..add(BannerEvent.fetchAdsBanner(
                        context: context, isRefresh: true))
                    ..add(BannerEvent.fetchLooks(
                        context: context, isRefresh: true))
                    ..add(BannerEvent.fetchAdsListProduct(
                        context: context, isRefresh: true)),
                ),
                LocalStorage.getToken().isNotEmpty
                    ? BlocProvider<CartBloc>(
                        create: (context) => CartBloc()
                          ..add(CartEvent.getCart(context: context)),
                      )
                    : BlocProvider<CartBloc>(create: (context) => CartBloc()),
                if (LocalStorage.getToken().isNotEmpty)
                  BlocProvider<NotificationBloc>(
                      create: (context) => NotificationBloc()
                        ..add(NotificationEvent.fetchCount(context: context))),
                BlocProvider<BrandBloc>(
                    create: (context) => BrandBloc()
                      ..add(BrandEvent.fetchBrands(context: context))),
              ],
              child: const MainPage(),
            );
          },
        ),
        (route) => false,
      );

  static goLogin(BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthBloc(),
            child: const AuthPage(),
          ),
        ),
        (route) => false,
      );

  static goProductPage(
      {required BuildContext context, required ProductData product}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProductDetailBloc()
                ..add(ProductDetailEvent.fetchProductById(
                    context: context, product: product))
                ..add(ProductDetailEvent.fetchRelatedProduct(
                    context: context,
                    productUuid: product.uuid,
                    isRefresh: true))
                ..add(ProductDetailEvent.fetchViewedProducts(
                    context: context, productId: product.id))
                ..add(ProductDetailEvent.fetchBuyWithProduct(
                    context: context, productId: product.id)),
            ),
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>())
          ],
          child: AppHelpers.getType() == 0
              ? const ProductPage()
              : AppHelpers.getType() == 1
                  ? const ProductOnePage()
                  : const ProductTwoPage(),
        ),
      ),
    );
  }

  static goOnlyImagePage(
      {required BuildContext context,
      required List<Galleries>? list,
      int? selectIndex}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ProductDetailBloc>())
          ],
          child: OnlyImagePage(list: list, selectIndex: selectIndex ?? 0),
        ),
      ),
    );
  }

  static goCheckoutPage(
      {required BuildContext context, required bool fullDigital}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => CheckoutBloc()
                    ..add(CheckoutEvent.fetchPayments(context: context))
                    ..add(CheckoutEvent.fetchUserAddress(
                        context: context, isRefresh: true))
                    ..add(CheckoutEvent.fetchDeliveryPoint(context: context))
                    ..add(CheckoutEvent.fetchDeliveryPrice(context: context))),
              BlocProvider(create: (context) => OrderBloc()),
              BlocProvider(create: (context) => AddressBloc()),
              BlocProvider.value(
                value: context.read<CartBloc>(),
              ),
              BlocProvider.value(
                value: context.read<MainBloc>(),
              ),
              BlocProvider.value(
                value: context.read<ProductBloc>(),
              ),
            ],
            child: CheckoutPage(
              fullDigital: fullDigital,
            )),
      ),
    );
  }

  static Future goProductList({
    required BuildContext context,
    List<ProductData>? list,
    String? title,
    int? total,
    bool? isNew,
    bool? isMostSale,
    bool? isPopular,
    int? categoryId,
    int? brandId,
    int? bannerId,
    int? shopId,
  }) async =>
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ProductBloc()
                  ..add(ProductEvent.fetchProducts(
                      context: context,
                      isRefresh: true,
                      list: list,
                      isNew: isNew,
                      isPopular: isPopular,
                      isMostSale: isMostSale,
                      categoryId: categoryId,
                      bannerId: bannerId,
                      brandId: brandId == null ? null : [brandId],
                      shopId: shopId)),
              ),
              BlocProvider.value(value: context.read<MainBloc>()),
              BlocProvider.value(value: context.read<CartBloc>()),
              BlocProvider(
                create: (context) => FilterBloc()
                  ..add(FilterEvent.selectSort(
                    type: isMostSale ?? false
                        ? FilterType.mostSold
                        : isPopular ?? false
                            ? FilterType.popular
                            : FilterType.news,
                  ))
                  ..add(FilterEvent.fetchExtras(
                    context: context,
                    categoryId: categoryId,
                    isPrice: true,
                  ))
                  ..add(FilterEvent.setBrands(ids: [brandId ?? -1])),
              ),
            ],
            child: ProductsListPage(
              list: list ?? [],
              title: title ?? "",
              totalCount: total ?? 0,
              isMostSaleProduct: isMostSale,
              isNewProduct: isNew,
              isPopular: isPopular,
              categoryId: categoryId,
              shopId: shopId,
              brandId: brandId,
              bannerId: bannerId,
            ),
          ),
        ),
      );

  static goGroupOrder(BuildContext context, CustomColorSet colors) {
    return AppHelpers.showCustomModalBottomSheet(
      context: context,
      paddingTop: 100,
      modal: BlocProvider.value(
        value: LocalStorage.getGroupOrder().id == null
            ? (context.read<CartBloc>()
              ..add(CartEvent.createLink(context: context)))
            : (context.read<CartBloc>()
              ..add(CartEvent.getCart(context: context))),
        child: GroupOrderPage(
          colors: colors,
        ),
      ),
    );
  }

  static goBlogPage(BuildContext context, BlogData blog) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<BlogBloc>()
            ..add(BlogEvent.fetchBlogById(
                context: context, id: blog.id ?? 0, blog: blog)),
          child: const BlogScreen(),
        ),
      ),
    );
  }

  static goNoteForProduct(
      BuildContext context, CartDetailProduct? product, String? note) {
    return AppHelpers.showCustomModalBottomSheet(
      paddingTop: 0,
      context: context,
      modal: BlocProvider.value(
        value: context.read<CartBloc>(),
        child: NoteProduct(
          cartItem: product,
          note: note,
        ),
      ),
    );
  }

  static Future goMap(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(providers: [
          BlocProvider(create: (context) => MapBloc()),
        ], child: const MapPage()),
      ),
    );
  }

  static goLookBottomSheet(
      BuildContext context, BannerData banner, CustomColorSet colors) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
                value: context.read<BannerBloc>()
                  ..add(BannerEvent.fetchProduct(
                      context: context, id: banner.id ?? 0))),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider.value(value: context.read<ProductBloc>()),
          ],
          child: LooksBottomSheet(look: banner),
        ),
      ),
    );
  }

  static goAdsBottomSheet(
      BuildContext context, BannerData banner, CustomColorSet colors) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
                value: context.read<BannerBloc>()
                  ..add(BannerEvent.fetchAdsProduct(
                      context: context, id: banner.id ?? 0))),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider.value(value: context.read<ProductBloc>())
          ],
          child: AdsBottomSheet(look: banner),
        ),
      ),
    );
  }

  static goFilterPage(BuildContext context, {int? categoryId}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            if (categoryId != null)
              BlocProvider.value(
                value: context.read<FilterBloc>()
                  ..add(
                    FilterEvent.setCategory(
                        category: CategoryData(id: categoryId)),
                  ),
              ),
            BlocProvider.value(value: context.read<FilterBloc>()),
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider(
              create: (context) => CategoryBloc()
                ..add(
                  CategoryEvent.fetchCategory(
                      context: context, isRefresh: true),
                ),
            ),
          ],
          child: FilterPage(categoryId: categoryId),
        ),
      ),
    );
  }

  static goCartPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<MainBloc>()),
              BlocProvider.value(
                value: context.read<CartBloc>()
                  ..add(
                      CartEvent.insertCart(context: context, onSuccess: () {}))
                  ..add(CartEvent.calculateCartWithCoupon(context: context)),
              ),
              BlocProvider.value(value: context.read<ProductBloc>()),
            ],
            child: const CartPage(),
          ),
        ), (route) {
      return route.isFirst;
    });
  }

  static Future goShopPage(
      {required BuildContext context, required ShopData? shop}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProductBloc()
                ..add(ProductEvent.fetchMostSaleShopProduct(
                  context: context,
                  isRefresh: true,
                  shopId: shop?.id,
                ))
                ..add(ProductEvent.fetchNewShopProduct(
                    context: context, isRefresh: true, shopId: shop?.id)),
            ),
            BlocProvider(
              create: (context) => ShopBloc()
                ..add(ShopEvent.fetchShopById(context: context, shop: shop)),
            ),
            if (AppHelpers.getType() != 0)
              BlocProvider(
                create: (context) => CategoryBloc()
                  ..add(CategoryEvent.fetchCategory(
                      context: context,
                      isRefresh: true,
                      shopId: shop?.id ?? 0)),
              ),
            if (AppHelpers.getType() != 0)
              BlocProvider(
                create: (context) => BannerBloc()
                  ..add(BannerEvent.fetchLooks(
                      context: context, isRefresh: true, shopId: shop?.id ?? 0))
                  ..add(BannerEvent.fetchAdsListProduct(
                      context: context,
                      isRefresh: true,
                      shopId: shop?.id ?? 0)),
              ),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
          ],
          child: ShopPage(shopId: shop?.id),
        ),
      ),
    );
  }

  static goSearchPage({required BuildContext context, int? shopId}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<ProductBloc>(),
            ),
            BlocProvider.value(
              value: context.read<ShopBloc>(),
            ),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider(
              create: (context) => SearchBloc(),
            ),
          ],
          child: SearchPage(shopId: shopId),
        ),
      ),
    );
  }

  static goMoreCategoriesPage(
      {required BuildContext context, CategoryData? category}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<ShopBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider.value(
                value: context.read<CategoryBloc>()
                  ..add(
                    CategoryEvent.selectOnlyCategory(
                      context: context,
                      category: category,
                    ),
                  )),
          ],
          child: const MoreCategoriesPage(),
        ),
      ),
    );
  }

  static goCategoryListPage({required BuildContext context, int? categoryId}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<ShopBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider.value(
              value: context.read<CategoryBloc>()
                ..add(CategoryEvent.selectCategory(context: context)),
            ),
          ],
          child: const CategoryListPage(),
        ),
      ),
    );
  }

  static goLikePage({required BuildContext context, int? categoryId}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
                value: context.read<ProductBloc>()
                  ..add(ProductEvent.fetchLikeProduct(context: context))),
            BlocProvider.value(value: context.read<ShopBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider.value(value: context.read<CategoryBloc>()),
          ],
          child: const LikePage(),
        ),
      ),
    );
  }

  static goProfile({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ProfileBloc>()),
            if (LocalStorage.getToken().isNotEmpty)
              BlocProvider.value(value: context.read<NotificationBloc>()),
            BlocProvider.value(value: context.read<BlogBloc>()),
            BlocProvider(create: (context) => OrderBloc()),
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider.value(value: context.read<CategoryBloc>()),
            BlocProvider.value(value: context.read<BannerBloc>()),
            BlocProvider.value(value: context.read<ProfileBloc>()),
            BlocProvider.value(value: context.read<BlogBloc>()),
            BlocProvider.value(value: context.read<ShopBloc>()),
            BlocProvider.value(value: context.read<StoryBloc>()),
            BlocProvider.value(value: context.read<BrandBloc>()),
          ],
          child: const MenuPage(),
        ),
      ),
    );
  }

  static goMyAccount({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<ProfileBloc>(),
            ),
            BlocProvider.value(
              value: context.read<NotificationBloc>(),
            ),
            BlocProvider.value(value: context.read<BlogBloc>()),
            BlocProvider(
              create: (context) => OrderBloc(),
            ),
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
          ],
          child: const MyAccount(),
        ),
      ),
    );
  }

  static goAppSetting({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.read<ProductBloc>()),
                  BlocProvider.value(value: context.read<CategoryBloc>()),
                  BlocProvider.value(value: context.read<BannerBloc>()),
                  BlocProvider.value(value: context.read<ProfileBloc>()),
                  BlocProvider.value(value: context.read<BlogBloc>()),
                  BlocProvider.value(value: context.read<ShopBloc>()),
                  BlocProvider.value(value: context.read<StoryBloc>()),
                  BlocProvider.value(value: context.read<BrandBloc>()),
                ],
                child: const AppSettingPage(),
              )),
    );
  }

  static goComparePage({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
            BlocProvider(
                create: (context) => CompareBloc()
                  ..add(CompareEvent.fetchActiveParcel(
                      context: context, isRefresh: true)))
          ],
          child: const CompareListPage(),
        ),
      ),
    );
  }

  static goLanguage({
    required BuildContext context,
  }) {
    return AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ProductBloc>()),
          BlocProvider.value(value: context.read<CategoryBloc>()),
          BlocProvider.value(value: context.read<BannerBloc>()),
          BlocProvider.value(value: context.read<ProfileBloc>()),
          BlocProvider.value(value: context.read<BlogBloc>()),
          BlocProvider.value(value: context.read<BrandBloc>()),
          BlocProvider.value(value: context.read<ShopBloc>()),
          BlocProvider.value(value: context.read<StoryBloc>()),
        ],
        child: const LanguagePage(),
      ),
    );
  }

  static goCurrency({
    required BuildContext context,
  }) {
    return AppHelpers.showCustomModalBottomSheetDrag(
      context: context,
      maxChildSize: 0.8,
      modal: (c) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ProductBloc>()),
          BlocProvider.value(value: context.read<CategoryBloc>()),
          BlocProvider.value(value: context.read<BannerBloc>()),
          BlocProvider.value(value: context.read<ProfileBloc>()),
          BlocProvider.value(value: context.read<BlogBloc>()),
          BlocProvider.value(value: context.read<BrandBloc>()),
          BlocProvider.value(value: context.read<ShopBloc>()),
          BlocProvider.value(value: context.read<StoryBloc>()),
        ],
        child: CurrencyPage(
          controller: c,
        ),
      ),
    );
  }

  static goReviewPage({
    required BuildContext context,
    required CustomColorSet colors,
    int? shopId,
    int? productId,
    int? blogId,
    int? driverId,
    int? orderId,
    String? productUuid,
  }) {
    return AppHelpers.showCustomModalBottomSheetDrag(
      paddingTop: 0,
      maxChildSize: 1,
      context: context,
      modal: (c) => BlocProvider(
        create: (context) => ReviewBloc()
          ..add(ReviewEvent.fetchReviewList(
              context: context,
              shopId: shopId,
              productUuid: productUuid,
              blogId: blogId,
              driverId: driverId,
              isRefresh: true))
          ..add(ReviewEvent.fetchReview(
              context: context,
              shopId: shopId,
              driverId: driverId,
              productId: productId,
              blogId: blogId)),
        child: ReviewPage(
          colors: colors,
          blogId: blogId,
          controller: c,
          shopId: shopId,
          orderId: orderId,
          productId: productId,
          productUuid: productUuid,
        ),
      ),
    );
  }

  static goEditProfile(
      {required BuildContext context, required CustomColorSet colors}) {
    return AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<ProfileBloc>(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
        ],
        child: EditAccountScreen(
          colors: colors,
        ),
      ),
    );
  }

  static goChangePassword(
      {required BuildContext context, required CustomColorSet colors}) {
    return AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: ChangePassword(
          colors: colors,
        ),
      ),
    );
  }

  static goSelectDate(
      {required BuildContext context,
      required CustomColorSet colors,
      required DateTime? dateTime}) {
    return AppHelpers.showCustomModalBottomSheet(
        context: context,
        paddingTop: 400.r,
        modal: BlocProvider.value(
          value: context.read<CheckoutBloc>(),
          child: SelectDate(
            colors: colors,
            dateTime: dateTime,
          ),
        ));
  }

  static goNotification({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
                value: context.read<NotificationBloc>()
                  ..add(NotificationEvent.fetchNotification(
                      context: context, isRefresh: true))
                  ..add(NotificationEvent.fetchCount(context: context))),
            BlocProvider.value(value: context.read<BlogBloc>()),
            BlocProvider(
              create: (context) => OrderBloc(),
            ),
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
          ],
          child: const NotificationPage(),
        ),
      ),
    );
  }

  static goAboutThisApp({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ProfileBloc>(),
          child: const AppInfoPage(),
        ),
      ),
    );
  }

  static goHelp({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ProfileBloc>()
            ..add(ProfileEvent.getHelps(context: context)),
          child: const HelpPage(),
        ),
      ),
    );
  }

  static goPolicy({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ProfileBloc>()
            ..add(ProfileEvent.getPolicy(context: context)),
          child: const PolicyPage(),
        ),
      ),
    );
  }

  static goTerm({required BuildContext context, bool isProfile = true}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          if (isProfile) {
            return BlocProvider.value(
              value: context.read<ProfileBloc>()
                ..add(ProfileEvent.getTerm(context: context)),
              child: const TermPage(),
            );
          } else {
            return BlocProvider(
              create: (context) =>
                  ProfileBloc()..add(ProfileEvent.getTerm(context: context)),
              child: const TermPage(),
            );
          }
        },
      ),
    );
  }

  static goBlog({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<BlogBloc>(),
          child: const BlogListPage(),
        ),
      ),
    );
  }

  static goChatsList({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => ChatBloc(),
          child: const ChatListPage(),
        ),
      ),
    );
  }

  static goChat(
      {required BuildContext context, required int senderId, String? chatId}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => ChatBloc()
            ..add(ChatEvent.checkChatId(context: context, sellerId: senderId)),
          child: ChatPage(
            senderId: senderId,
            chatId: chatId,
          ),
        ),
      ),
    );
  }

  static goCongratsPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const CongratsPage(
                  isOrder: true,
                )),
        (route) => route.isFirst);
  }

  static goNotificationBottomSheet(BuildContext context,
      NotificationModel notification, CustomColorSet colors) {
    return AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: NotificationBottomSheetSheet(
        notification: notification,
        colors: colors,
      ),
    );
  }

  static goSelectCountry({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AddressBloc()
            ..add(AddressEvent.fetchCountry(context: context, isRefresh: true)),
          child: const CountryPage(),
        ),
      ),
    );
  }

  static goSelectCity(
      {required BuildContext context,
      required int countryId,
      bool pushAddress = false}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AddressBloc()
            ..add(AddressEvent.fetchCity(
                context: context, isRefresh: true, countyId: countryId)),
          child: CityPage(
            countryId: countryId,
            pushAddress: pushAddress,
          ),
        ),
      ),
    );
  }

  static goSelectDeliveryPoint(
      {required BuildContext context, required List<DeliveryPoint> list}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CheckoutBloc>(),
          child: SelectDeliveryPoint(list: list),
        ),
      ),
    );
  }

  static goOrdersList({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) => OrderBloc()
                        ..add(OrderEvent.fetchActiveOrders(context: context))
                        ..add(OrderEvent.fetchRefundOrders(context: context))),
                  BlocProvider.value(value: context.read<ProductBloc>()),
                  BlocProvider.value(value: context.read<MainBloc>()),
                  BlocProvider.value(value: context.read<CartBloc>()),
                ],
                child: const OrdersListPage(),
              )),
    );
  }

  static goParcelList({required BuildContext context}) {
    Navigator.popUntil(context, (route) {
      return route.isFirst;
    });
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => ParcelsListBloc()
            ..add(ParcelsListEvent.fetchActiveParcel(
                context: context, isRefresh: true))
            ..add(ParcelsListEvent.fetchHistoryParcel(
                context: context, isRefresh: true)),
          child: const ParcelListPage(),
        ),
      ),
    );
  }

  static goTransactionList({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ProfileBloc>()),
            BlocProvider(
              create: (context) => WalletBloc()
                ..add(WalletEvent.fetchTransactions(
                    context: context, isRefresh: true))
                ..add(WalletEvent.fetchPayments(context: context)),
            )
          ],
          child: const TransactionList(),
        ),
      ),
    );
  }

  static goOrderPage(BuildContext context, OrderShops order) {
    return AppHelpers.showCustomModalBottomSheetDrag(
      context: context,
      paddingTop: MediaQuery.sizeOf(context).height / 10,
      modal: (c) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OrderBloc()
              ..add(
                OrderEvent.fetchOrderById(
                  context: context,
                  id: order.id ?? 0,
                  order: OrderModel(orderShops: [order]),
                ),
              ),
          ),
          BlocProvider.value(value: context.read<ProductBloc>()),
          BlocProvider.value(value: context.read<MainBloc>()),
          BlocProvider.value(value: context.read<CartBloc>()),
        ],
        child: OrderScreen(
          controller: c,
        ),
      ),
    );
  }

  static goRefundOrderPage(
      BuildContext context, CustomColorSet colors, RefundModel? refund) {
    return AppHelpers.showCustomModalBottomSheetDrag(
      context: context,
      paddingTop: MediaQuery.sizeOf(context).height / 10,
      modal: (c) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OrderBloc()
              ..add(
                OrderEvent.fetchRefundOrderById(
                  context: context,
                  id: refund?.id ?? 0,
                  refund: refund,
                ),
              ),
          ),
          BlocProvider.value(value: context.read<ProductBloc>()),
          BlocProvider.value(value: context.read<MainBloc>()),
          BlocProvider.value(value: context.read<CartBloc>()),
        ],
        child: RefundScreen(
          colors: colors,
          controller: c,
        ),
      ),
    );
  }

  static goParcelOrderPage(
      BuildContext context, ParcelOrder? parcel, CustomColorSet colors) {
    return AppHelpers.showCustomModalBottomSheetDrag(
      context: context,
      paddingTop: MediaQuery.sizeOf(context).height / 3,
      modal: (c) => BlocProvider(
        create: (context) => ParcelBloc()
          ..add(ParcelEvent.showParcel(
              context: context, orderId: parcel?.id ?? 0, parcel: parcel)),
        child: ParcelOrderScreen(
          colors: colors,
          controller: c,
        ),
      ),
    );
  }

  static goParcel({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ParcelBloc()..add(ParcelEvent.fetchTypes(context)),
            ),
            BlocProvider(
              create: (_) => CheckoutBloc()
                ..add(CheckoutEvent.fetchPayments(context: context)),
            ),
          ],
          child: const ParcelPage(),
        ),
      ),
    );
  }

  static goBecomeSeller({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => BecomeSellerBloc(),
            ),
            BlocProvider.value(
              value: context.read<ProfileBloc>()
                ..add(ProfileEvent.fetchProfile(context: context)),
            ),
          ],
          child: const BecomeSellerPage(),
        ),
      ),
    );
  }

  static Future goAddEditAddress(
      {required BuildContext context, UserAddress? address}) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AddressBloc(),
          child: AddEditAddressPage(
            address: address,
          ),
        ),
      ),
    );
  }

  static Future goSearchAddress(
      {required BuildContext context, UserAddress? address}) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => AddressBloc(),
          child: const SearchAddressPage(),
        ),
      ),
    );
  }

  static Future goWebView({required BuildContext context, String? url}) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebViewPage(url: url),
      ),
    );
  }

  static Future goCompareProductPage(
      {required BuildContext context, required List<ProductData> list}) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<CompareBloc>(),
            ),
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
          ],
          child: CompareProductPage(
            list: list,
          ),
        ),
      ),
    );
  }

  static Future goStoryPagePage(
      {required BuildContext context,
      required RefreshController controller,
      required int index}) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<StoryBloc>(),
            ),
            BlocProvider.value(value: context.read<ProductBloc>()),
            BlocProvider.value(value: context.read<MainBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
          ],
          child: StoryPage(
            controller: controller,
            index: index,
          ),
        ),
      ),
    );
  }

  static goInfoScreen(
      {required BuildContext context,
      required int index,
      bool replace = false,
      required CustomColorSet colors}) {
    if (replace) {
      return Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => InfoPage(index: index, colors: colors),
        ),
      );
    }
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InfoPage(index: index, colors: colors),
      ),
    );
  }

  static goMyDigitalList({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<ProfileBloc>()
                      ..add(ProfileEvent.fetchDigitalList(
                          context: context, isRefresh: true)),
                  ),
                  BlocProvider.value(value: context.read<ProductBloc>()),
                  BlocProvider.value(value: context.read<MainBloc>()),
                  BlocProvider.value(value: context.read<CartBloc>()),
                ],
                child: const MyDigitalList(),
              )),
    );
  }

  static goMyReferral({required BuildContext context}) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
              value: context.read<ProfileBloc>()
                ..add(ProfileEvent.fetchReferral(context: context)),
              child: const ReferralPage(),
            )));
  }

  static goSelectUIType({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SelectUITypePage()),
    );
  }

  static goReviewImages(
      {required BuildContext context,
      required int index,
      required List<Galleries> list}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReviewImages(
          selectIndex: index,
          list: list,
        ),
      ),
    );
  }

  static goGamePage({required BuildContext context}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => GameBloc()..add(const GameEvent.init()),
          child: const Game(),
        ),
      ),
    );
  }

  static goMaksekeskusBottomSheet(
      {required BuildContext context,
      CreateOrderModel? order,
      bool? parcel,
      bool? wallet,
      int? parcelId,
      num? price,
      required CustomColorSet colors,
      required ValueChanged<String> onSuccess}) {
    return AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: BlocProvider<MaksekeskusBloc>(
        create: (context) => MaksekeskusBloc()
          ..add(MaksekeskusEvent.fetchMaksekeskus(
            order: order,
            price: price,
            wallet: wallet,
            parcel: parcel,
            context: context,
            parcelId: parcelId,
          )),
        child: MaksekeskusScreen(colors: colors, onSuccess: onSuccess),
      ),
    );
  }

  static goFailOrderPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FailurePage()),
        (route) => route.isFirst);
  }

  static goFailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FailurePage()),
    );
  }

  static goSuccessPage(BuildContext context, {VoidCallback? onTap}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CongratsPage(onTap: onTap)),
    );
  }
}
