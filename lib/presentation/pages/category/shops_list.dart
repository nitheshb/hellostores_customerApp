import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/shop/shop_bloc.dart';
import 'package:goshops/application/story/story_bloc.dart';
import 'package:goshops/presentation/pages/category/widgets/story_item.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/shimmer/shops_shimmer.dart';
import 'widgets/shop_item.dart';

class ShopsList extends StatelessWidget {
  final CustomColorSet colors;
  final RefreshController shopsRefresh;
  final RefreshController storyRefresh;

  const ShopsList(
      {super.key,
      required this.colors,
      required this.shopsRefresh,
      required this.storyRefresh})
     ;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        return SmartRefresher(
          controller: shopsRefresh,
          enablePullUp: true,
          onRefresh: () {
            context.read<ShopBloc>().add(ShopEvent.fetchShops(
                context: context, controller: shopsRefresh, isRefresh: true));

            context.read<StoryBloc>().add(StoryEvent.fetchStory(
                context: context, controller: storyRefresh, isRefresh: true));
          },
          onLoading: () {
            context.read<ShopBloc>().add(ShopEvent.fetchShops(
                context: context, controller: shopsRefresh));
          },
          child: state.isLoadingoshopss
              ? const ShopsShimmer()
              : ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 20.r),
                  children: [
                    BlocBuilder<StoryBloc, StoryState>(
                      builder: (context, state) {
                        return state.story.isNotEmpty
                            ? SizedBox(
                                height: 64.r,
                                child: SmartRefresher(
                                  enablePullDown: false,
                                  enablePullUp: true,
                                  controller: storyRefresh,
                                  scrollDirection: Axis.horizontal,
                                  onLoading: () {
                                    context.read<StoryBloc>().add(
                                        StoryEvent.fetchStory(
                                            context: context,
                                            controller: storyRefresh));
                                  },
                                  child: SizedBox(
                                    height: 64.r,
                                    child: ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.r),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.story.length,
                                        itemBuilder: (context, index) {
                                          return StoryItem(
                                            colors: colors,
                                            story: (state.story[index]
                                                        ?.isNotEmpty ??
                                                    false)
                                                ? (state.story[index]?.first)
                                                : null,
                                            onTap: () {
                                              AppRoute.goStoryPagePage(
                                                  context: context,
                                                  controller: storyRefresh,
                                                  index: index);
                                            },
                                          );
                                        }),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    16.verticalSpace,
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                            right: 16.r, left: 16.r, bottom: 90.r),
                        shrinkWrap: true,
                        itemCount: state.shops.length,
                        itemBuilder: (context, index) {
                          return ShopItemPage(
                            colors: colors,
                            shop: state.shops[index],
                          );
                        }),
                  ],
                ),
        );
      },
    );
  }
}
