import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/app_constants.dart';
import 'package:goshops/application/category/category_bloc.dart';
import 'package:goshops/infrastructure/model/response/categories_paginate_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class MainCategoryItem extends StatelessWidget {
  final CustomColorSet colors;

  const MainCategoryItem({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.categories.length < 2) {
          return const SizedBox.shrink();
        } else {
          CategoryData selectCategory = state.categories[1];
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
                            context: context,
                            category: selectCategory,
                          );
                        },
                      ),
                      24.verticalSpace,
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: (selectCategory.children?.length ?? 0) > 4? 4: (selectCategory.children?.length ?? 0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 168 / 200,
                          mainAxisSpacing: 10.r,
                          crossAxisSpacing: 9.r,
                          crossAxisCount: 2,
                          mainAxisExtent: 180.r,
                        ),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final subCategory = selectCategory.children?[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 92.r,
                                    margin: REdgeInsets.only(top: 40),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radius.r),
                                      color: colors.newBoxColor,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    left: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        AppRoute.goProductList(
                                          context: context,
                                          title:
                                              subCategory?.translation?.title,
                                          categoryId: subCategory?.id,
                                        );
                                      },
                                      child: CustomNetworkImage(
                                        url: subCategory?.img,
                                        width: 100,
                                        height: 120,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              16.verticalSpace,
                              Text(
                                subCategory?.translation?.title ??
                                    AppHelpers.getTranslation(TrKeys.noTitle),
                                style: CustomStyle.interNormal(
                                  color: colors.textBlack,
                                ),
                              ),
                            ],
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
