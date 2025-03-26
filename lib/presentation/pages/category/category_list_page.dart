import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/category/category_bloc.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'widgets/category_item.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  late RefreshController categoryRefresh;
  late RefreshController refreshController;
  final isLtr = LocalStorage.getLangLtr();

  @override
  void initState() {
    categoryRefresh = RefreshController();
    refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    categoryRefresh.dispose();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: TrKeys.categories,
      ),
      body: (colors) => SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () {
          context.read<CategoryBloc>().add(
                CategoryEvent.fetchCategory(
                    context: context,
                    controller: refreshController,
                    isRefresh: true),
              );
        },
        onLoading: () {
          context.read<CategoryBloc>().add(CategoryEvent.fetchCategory(
              context: context, controller: refreshController));
        },
        child:
            BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
          return state.categories.isNotEmpty || state.isLoadingCategory
              ? ListView.builder(
                  key: const PageStorageKey<String>("list"),
                  shrinkWrap: true,
                  padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    return CategoryListItem(
                        colors: colors,
                        category: state.categories[index],
                        selectCategory: state.selectCategory,
                        selectCategoryTwo: state.selectCategoryTwo,
                        onTap: () {
                          context.read<CategoryBloc>().add(
                                CategoryEvent.selectCategory(
                                  context: context,
                                  category: state.categories[index],
                                ),
                              );
                        },
                        onTwoTap: (value) {
                          context.read<CategoryBloc>().add(
                              CategoryEvent.selectCategoryTwo(
                                  context: context, category: value));
                        },
                        onLastTap: (value) async {
                          await AppRoute.goProductList(
                              context: context,
                              title: value?.translation?.title ?? "",
                              categoryId: value?.id);
                          if (context.mounted) {
                            context
                                .read<ProductBloc>()
                                .add(const ProductEvent.updateState());
                          }
                        });
                  })
              : const SizedBox.shrink();
        }),
      ),
    );
  }
}
