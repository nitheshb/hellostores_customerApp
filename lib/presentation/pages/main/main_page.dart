// ignore_for_file: prefer_is_empty

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/cart/cart_bloc.dart';
import 'package:goshops/application/main/main_bloc.dart';
import 'package:goshops/application/notification/notification_bloc.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/application/profile/profile_bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/firebase/firebase_service.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';

import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/pages/home/home_page.dart';
import 'package:goshops/presentation/pages/view_map/view_map_page.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'widgets/bottom_navigation_bar_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final isLtr = LocalStorage.getLangLtr();
  Timer? timer;

  List<IndexedStackChild> list = [
    IndexedStackChild(child: const HomePage()),
    IndexedStackChild(child: const ViewMapPage()),
    // IndexedStackChild(child: const LikePage()),
    // IndexedStackChild(child: const CartPage(), preload: true),
  ];

  @override
  void initState() {
    if (LocalStorage.getToken().isNotEmpty) {
      userRepository.getProfileDetails(context);
      settingsRepository.getAdminInfo();
      productsRepository.getProductsByIds(LocalStorage.getLikedProductsList());
      addressRepository.showWareHouse();
      if (LocalStorage.getToken().isNotEmpty) {
        timer = Timer.periodic(
            Duration(seconds: AppConstants.timeRefresh.inSeconds), (Timer t) {
          context
              .read<NotificationBloc>()
              .add(NotificationEvent.fetchCount(context: context));
        });
      }
    }
    FirebaseService.initDynamicLinks(context);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: (colors) => BlocBuilder<MainBloc, MainState>(
        buildWhen: (l, n) {
          return l.selectIndex != n.selectIndex;
        },
        builder: (context, state) {
          return ProsteIndexedStack(
            index: state.selectIndex,
            children: list,
          );
        },
      ),
      bottomNavigationBar: (colors) =>
          AppHelpers.getType() == 0 || AppHelpers.getType() == 3
              ? _bottomNavigationBarNew(colors)
              : const SizedBox.shrink(),
    );
  }

  Widget bottomNavigationBarTwo(CustomColorSet colors) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return BottomNavigationBar(
            backgroundColor: colors.backgroundColor,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: state.selectIndex,
            selectedItemColor: colors.primary,
            unselectedItemColor: colors.textHint,
            onTap: (index) {
              if (index == 4) {
                Scaffold.of(context).openDrawer();
                return;
              }
              if (index == 3) {
                context.read<CartBloc>().add(CartEvent.insertCart(
                      context: context,
                      onSuccess: () {
                        if (LocalStorage.getToken().isNotEmpty) {
                          context.read<CartBloc>().add(
                              CartEvent.calculateCartWithCoupon(
                                  context: context));
                        }

                        context
                            .read<ProductBloc>()
                            .add(const ProductEvent.updateState());
                      },
                    ));
              }
              if (index == 2) {
                context
                    .read<ProductBloc>()
                    .add(ProductEvent.fetchLikeProduct(context: context));
              }
              context.read<MainBloc>().add(MainEvent.changeIndex(index: index));
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(FlutterRemix.home_5_line),
                label: AppHelpers.getTranslation(TrKeys.home),
              ),
              BottomNavigationBarItem(
                icon: const Icon(FlutterRemix.apps_2_line),
                label: AppHelpers.getTranslation(TrKeys.catalog),
              ),
              BottomNavigationBarItem(
                  icon: BlocBuilder<CartBloc, CartState>(
                    builder: (context, stateCart) {
                      return Badge(
                          label: Text(LocalStorage.getCartList()
                              .where((element) => element.count > 0)
                              .length
                              .toString()),
                          isLabelVisible: LocalStorage.getCartList()
                                  .where((element) => element.count > 0)
                                  .length !=
                              -1,
                          child: const Icon(FlutterRemix.shopping_bag_3_line));
                    },
                  ),
                  label: AppHelpers.getTranslation(TrKeys.cart)),
              BottomNavigationBarItem(
                  icon: BlocBuilder<ProfileBloc, ProfileState>(
                    buildWhen: (p, n) {
                      return p.isLoading != n.isLoading;
                    },
                    builder: (context, s) {
                      return CustomNetworkImage(
                        url: LocalStorage.getUser().img,
                        height: 40,
                        width: 40,
                        radius: 20,
                        name: LocalStorage.getUser().firstname ??
                            LocalStorage.getUser().lastname,
                      );
                    },
                  ),
                  label: ""),
            ]);
      },
    );
  }

  Widget _bottomNavigationBarNew(CustomColorSet colors) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
            child: Container(
              height: Platform.isAndroid ? 67.r : 80.r,
              decoration: BoxDecoration(
                color: colors.backgroundColor.withOpacity(0.7),
                boxShadow: [
                  BoxShadow(
                    color: CustomStyle.bottomNavigationShadow,
                    spreadRadius: 25.r,
                    blurRadius: 35.r,
                    offset: Offset(0.r, 0.r),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomNavigationBarButton(
                    iconData: FlutterRemix.store_2_fill,
                    isSelected: state.selectIndex == 0,
                    label: AppHelpers.getTranslation(TrKeys.shopList),
                    onTap: () {
                      context
                          .read<MainBloc>()
                          .add(const MainEvent.changeIndex(index: 0));
                    },
                    colors: colors,
                  ),
                  BottomNavigationBarButton(
                    iconData: FlutterRemix.map_2_fill,
                    isSelected: state.selectIndex == 1,
                    label: AppHelpers.getTranslation(TrKeys.viewMap),
                    onTap: () {
                      context
                          .read<MainBloc>()
                          .add(const MainEvent.changeIndex(index: 1));
                    },
                    colors: colors,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20.r),
                    onTap: () {
                      AppRoute.goProfile(context: context);
                    },
                    child: (LocalStorage.getUser().img?.isEmpty ?? true)
                        ? Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.newBoxColor,
                            ),
                            child: Icon(
                              FlutterRemix.user_line,
                              size: 21.r,
                              color: colors.textBlack,
                            ),
                          )
                        : CustomNetworkImage(
                            url: LocalStorage.getUser().img,
                            width: 40,
                            height: 40,
                            radius: 20,
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
