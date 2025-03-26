import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/category/category_bloc.dart';
import 'package:goshops/infrastructure/model/response/categories_paginate_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class MainCategoryCircleItem extends StatelessWidget {
  final CustomColorSet colors;

  const MainCategoryCircleItem({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.categories.length < 3) {
          return const SizedBox.shrink();
        } else {
          CategoryData selectCategory = state.categories[2];
          return Container(
            padding: REdgeInsets.symmetric(vertical: 16),
            margin: REdgeInsets.symmetric(horizontal: 16),
            color: colors.backgroundColor,
            width: 1.sw,
            child: state.isLoadingCategory
                ? const Loading()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      4.verticalSpace,
                      TitleWidget(
                        title: selectCategory.translation?.title ?? '',
                        titleColor: colors.textBlack,
                        titleSize: 20,
                        rightTitle: TrKeys.seeAll,
                        onTap: () {
                          AppRoute.goMoreCategoriesPage(
                              context: context, category: selectCategory);
                        },
                      ),
                      24.verticalSpace,
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: (selectCategory.children?.length ?? 0) > 4
                            ? 4
                            : (selectCategory.children?.length ?? 0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 20.r,
                          mainAxisExtent: 208.r,
                          mainAxisSpacing: 40.r,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          final subCategory = selectCategory.children?[index];
                          return InkWell(
                            onTap: () {
                              AppRoute.goProductList(
                                context: context,
                                title: subCategory?.translation?.title,
                                categoryId: subCategory?.id,
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 170.r,
                                  decoration: BoxDecoration(
                                    color: colors.newBoxColor,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: REdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  alignment: Alignment.center,
                                  child: CustomNetworkImage(
                                    fit: BoxFit.contain,
                                    url: subCategory?.img,
                                    width: 100,
                                    height: 130,
                                    radius: 0,
                                    shimmerRadius: 100,
                                  ),
                                ),
                                12.verticalSpace,
                                SizedBox(
                                  width: 84.w,
                                  child: Text(
                                    subCategory?.translation?.title ?? '',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomStyle.interNormal(
                                      color: colors.textBlack,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          );
        }
      },
    );
  }
}
