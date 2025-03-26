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

class SubCategoryList extends StatelessWidget {
  final CustomColorSet colors;
  final CategoryData category;
  final bool isLoading;

  const SubCategoryList({
    super.key,
    required this.colors,
    required this.category,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: REdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: colors.newBoxColor,
          borderRadius: BorderRadius.circular(AppConstants.radius.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 10,
            )
          ]),
      padding: EdgeInsets.symmetric(vertical: 16.r),
      child: isLoading
          ? const Loading()
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          4.verticalSpace,
          TitleWidget(
            title: category.translation?.title ?? '',
            titleColor: colors.textBlack,
            titleSize: 20,
            rightTitle: TrKeys.seeAll,
            onTap: () {
              context.read<CategoryBloc>().add(
                CategoryEvent.selectCategory(
                  context: context,
                  category: category,
                ),
              );
              AppRoute.goMoreCategoriesPage(context: context);
            },
          ),
          24.verticalSpace,
          SizedBox(
            height: 120.h,
            child: ListView.builder(
                padding: REdgeInsets.symmetric(horizontal: 16),
                itemCount: category.children?.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _categoryItem(
                    context,
                    category.children?[index],
                  );
                }),
          )
        ],
      ),
    );
  }

  _categoryItem(BuildContext context, CategoryData? subCategory) {
    return Container(
      margin: EdgeInsets.only(right: 20.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () {
          AppRoute.goProductList(
            context: context,
            title: subCategory?.translation?.title,
            categoryId: subCategory?.id,
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radius.r),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.newBoxColor,
                ),
                alignment: Alignment.center,
                child: CustomNetworkImage(
                  fit: BoxFit.contain,
                  url: subCategory?.img,
                  width: 84.r,
                  height: 72.r,
                  radius: 0,
                ),
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
                style:
                    CustomStyle.interNormal(color: colors.textBlack, size: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
