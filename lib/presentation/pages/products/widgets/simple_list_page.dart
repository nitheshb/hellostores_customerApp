import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/product_items/product_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SimpleListPage extends StatelessWidget {
  final List<ProductData> list;
  final RefreshController refreshController;
  final VoidCallback? onLoading;
  final VoidCallback? onRefresh;

  const SimpleListPage({
    super.key,
    required this.list,
    required this.refreshController,
    this.onLoading,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: onLoading != null,
      onLoading: onLoading,
      onRefresh: onRefresh,
      child: GridView.builder(
          padding: EdgeInsets.only(
            right: 16.r,
            left: 16.r,
            top: 16.r,
            bottom: 56.r,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8.r,
            crossAxisCount: 2,
            mainAxisSpacing: 8.r,
            mainAxisExtent: AppHelpers.getType() == 0 ? 316.r : 356.r,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.r),
              child: ProductItem(
                width: MediaQuery.sizeOf(context).width,
                product: list[index],
              ),
            );
          }),
    );
  }
}
