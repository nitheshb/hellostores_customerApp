import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/shop/shop_bloc.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/components/main_shop_item.dart';
import 'package:goshops/presentation/components/shimmer/shops_shimmer.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ShopBottomSheet extends StatelessWidget {
  final RefreshController shopsRefresh;
  final CustomColorSet colors;

  const ShopBottomSheet({
    super.key,
    required this.shopsRefresh,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height-MediaQuery.paddingOf(context).top-100,
        width: double.infinity,
        child: DraggableScrollableSheet(
            initialChildSize: 0.2,
            maxChildSize: 1,
            minChildSize: 0.2,
            snap: true,
            builder: (context, scrollController) {
              return Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    color: colors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.r),
                      topLeft: Radius.circular(12.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: colors.backgroundColor.withOpacity(0.25),
                          blurRadius: 40,
                          offset: const Offset(0, -2))
                    ]),
                child: BlocBuilder<ShopBloc, ShopState>(
                  builder: (context, state) {
                    return SmartRefresher(
                      controller: shopsRefresh,
                      enablePullUp: true,
                      enablePullDown: false,
                      onRefresh: () {
                        context
                            .read<ShopBloc>()
                            .add(ShopEvent.fetchShops(
                          context: context,
                          controller: shopsRefresh,
                          isRefresh: true,
                        ));
                      },
                      onLoading: () {
                        context
                            .read<ShopBloc>()
                            .add(ShopEvent.fetchShops(
                          context: context,
                          controller: shopsRefresh,
                        ));
                      },
                      child: ListView(
                        padding: REdgeInsets.symmetric(horizontal: 16),
                        controller: scrollController,
                        children: [
                          6.verticalSpace,
                          const ModalDrag(),
                          12.verticalSpace,
                          state.isLoadingoshopss
                              ? const Loading()
                              : state.isLoadingoshopss
                                  ? const ShopsShimmer()
                                  : ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding:
                                          EdgeInsets.only(bottom: 90.r),
                                      shrinkWrap: true,
                                      itemCount: state.shops.length,
                                      itemBuilder: (context, index) {
                                        return MainShopItem(
                                          colors: colors,
                                          shop: state.shops[index],
                                        );
                                      }),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
