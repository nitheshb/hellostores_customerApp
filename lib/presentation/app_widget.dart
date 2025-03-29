import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/address/address_bloc.dart';
import 'package:goshops/application/auth/auth_bloc.dart';
import 'package:goshops/application/banner/banner_bloc.dart';
import 'package:goshops/application/blog/blog_bloc.dart';
import 'package:goshops/application/brand/brand_bloc.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/application/category/category_bloc.dart';
import 'package:goshops/application/main/main_bloc.dart';
import 'package:goshops/application/notification/notification_bloc.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/application/profile/profile_bloc.dart';
import 'package:goshops/application/shop/shop_bloc.dart';
import 'package:goshops/application/story/story_bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/infrastructure/repository/settings_repository.dart';
import 'package:goshops/presentation/pages/auth/login_cart.dart';
import 'package:goshops/presentation/pages/auth/sign_up_cart.dart';
import 'package:goshops/presentation/style/themes/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'pages/country/country_page.dart';
import 'pages/main/main_page.dart';
import 'style/style.dart';
import 'style/theme/theme.dart';

@pragma('vm:entry-point')
Future<int> getOtherTranslation(int arg) async {
  final settingsRepository = SettingsRepository();
  final res = await settingsRepository.getLanguages(arg: true);
  res.fold((l) {
    l.data?.forEach((e) async {
      final translations =
          await settingsRepository.getMobileTranslations(lang: e.locale);
      translations.fold((d) {
        LocalStorage.setOtherTranslations(
            translations: d.data, key: e.id.toString());
      }, (r) => null);
    });
  }, (r) => null);
  return 0;
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  Future isolate() {
    return FlutterIsolate.spawn(getOtherTranslation, 0);
  }

  @override
  void initState() {
    if (LocalStorage.getTranslations().isNotEmpty) {
      fetchSettingNoAwait();
    }
    isolate();
    FlutterDisplayMode.setHighRefreshRate();
    super.initState();
  }

  Future fetchSetting() async {
    final connect = await Connectivity().checkConnectivity();
    if (connect.contains(ConnectivityResult.wifi) ||
        connect.contains(ConnectivityResult.mobile) ||
        connect.contains(ConnectivityResult.ethernet)) {
      settingsRepository.getGlobalSettings();
      await settingsRepository.getLanguages();
      await settingsRepository.getMobileTranslations();
      if (LocalStorage.getSelectedCurrency() == null) {
        settingsRepository.getCurrencies();
      }
    }
  }

  Future fetchSettingNoAwait() async {
    settingsRepository.getGlobalSettings();
    settingsRepository.getLanguages();
    settingsRepository.getMobileTranslations();
    if (LocalStorage.getSelectedCurrency() == null) {
      settingsRepository.getCurrencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait({
          AppTheme.create,
          if (LocalStorage.getTranslations().isEmpty) fetchSetting()
        }),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            FlutterNativeSplash.remove();
            final AppTheme theme = snapshot.data?[0];
            return ScreenUtilInit(
              useInheritedMediaQuery: true,
              designSize: const Size(375, 812),
              builder: (context, child) {
                return RefreshConfiguration(
                  footerBuilder: _refreshFooter,
                  headerBuilder: _refreshHeader,
                  child: ChangeNotifierProvider(
                    create: (BuildContext context) => theme,
                    child: MaterialApp(
                      theme: lightTheme(theme.colors),
                      title: AppHelpers.getAppName(),
                      builder: (context, child) => ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: child!,
                      ),
                      debugShowCheckedModeBanner: false,
                      home:
                     // LocalStorage.getAddress() == null
                       //   ? _address()
                           _main(),


                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        });
  }

  Widget _refreshFooter() {
    return ClassicFooter(
      idleIcon: const SizedBox.shrink(),
      idleText: '',
      loadingText: AppHelpers.getTranslation(TrKeys.loadingText),
      noDataText: AppHelpers.getTranslation(TrKeys.noMoreText),
      failedText: AppHelpers.getTranslation(TrKeys.refreshFailedText),
      canLoadingText: AppHelpers.getTranslation(TrKeys.canLoadingText),
    );
  }

  Widget _refreshHeader() {
    return WaterDropHeader(
      waterDropColor: CustomStyle.primary,
      complete: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.done, color: Colors.grey),
          15.horizontalSpace,
          Text(
            AppHelpers.getTranslation(TrKeys.refreshCompleteText),
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
      // refreshingText: AppHelpers.getTranslation(TrKeys.refreshingText),
      // releaseText: AppHelpers.getTranslation(TrKeys.canRefreshText),
      // completeText: AppHelpers.getTranslation(TrKeys.refreshCompleteText),
      // canTwoLevelText: AppHelpers.getTranslation(TrKeys.canTwoLevelText),
      // idleText: AppHelpers.getTranslation(TrKeys.idleRefreshText),
      // failedText: AppHelpers.getTranslation(TrKeys.refreshFailedText),
      idleIcon: const Icon(
        FlutterRemix.loader_2_fill,
        size: 15,
        color: CustomStyle.white,
      ),
    );
  }

  // BlocProvider<AuthBloc> _auth() {
  //   return BlocProvider(
  //     create: (context) => AuthBloc(),
  //     child: const AuthPage(),
  //   );
  // }
  BlocProvider<AddressBloc> _address() {
    return BlocProvider(
      create: (context) => AddressBloc()
        ..add(AddressEvent.fetchCountry(context: context, isRefresh: true)),
      child: const CountryPage(),
    );
  }

  MultiBlocProvider _main() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(create: (context) => MainBloc()),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc()
            ..add(
                CategoryEvent.fetchCategory(context: context, isRefresh: true)),
        ),
        BlocProvider<ShopBloc>(
          create: (context) => ShopBloc()
            ..add(ShopEvent.fetchShops(context: context, isRefresh: true)),
        ),
        BlocProvider<StoryBloc>(
          create: (context) => StoryBloc()
            ..add(StoryEvent.fetchStory(context: context, isRefresh: true)),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc()
            ..add(ProductEvent.fetchMostSaleProduct(
                context: context, isRefresh: true))
            ..add(ProductEvent.fetchPopularProduct(
                context: context, isRefresh: true))
            ..add(
                ProductEvent.fetchNewProduct(context: context, isRefresh: true))
            ..add(ProductEvent.fetchAllProduct(
                context: context, isRefresh: true)),
        ),
        BlocProvider<BlogBloc>(
          create: (context) => BlogBloc()
            ..add(BlogEvent.fetchBlog(context: context, isRefresh: true)),
        ),
        BlocProvider<BannerBloc>(
          create: (context) => BannerBloc()
            ..add(BannerEvent.fetchBanner(context: context, isRefresh: true))
            ..add(BannerEvent.fetchDiscount(context: context, isRefresh: true))
            ..add(BannerEvent.fetchAdsBanner(context: context, isRefresh: true))
            ..add(BannerEvent.fetchLooks(context: context, isRefresh: true))
            ..add(BannerEvent.fetchAdsListProduct(
                context: context, isRefresh: true)),
        ),
        LocalStorage.getToken().isNotEmpty
            ? BlocProvider<CartBloc>(
                create: (context) =>
                    CartBloc()..add(CartEvent.getCart(context: context)),
              )
            : BlocProvider<CartBloc>(create: (context) => CartBloc()),
        if (LocalStorage.getToken().isNotEmpty)
          BlocProvider<NotificationBloc>(
              create: (context) => NotificationBloc()
                ..add(NotificationEvent.fetchCount(context: context))),
        BlocProvider<BrandBloc>(
            create: (context) =>
                BrandBloc()..add(BrandEvent.fetchBrands(context: context))),
      ],
      child: const MainPage(),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}
