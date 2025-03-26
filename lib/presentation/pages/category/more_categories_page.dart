import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/category/category_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:goshops/presentation/style/style.dart';

class MoreCategoriesPage extends StatelessWidget {
  const MoreCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return CustomScaffold(
          appBar: (colors) => CustomAppBar(
            colors: colors,
            context: context,
            title: state.selectCategory?.translation?.title ??
               TrKeys.categories,
          ),
          body: (colors) => Column(
            children: [
              Divider(thickness: 1.r, height: 1.r, color: colors.icon),
              Expanded(
                child: state.isLoadingCategory
                    ? const Loading()
                    : ((state.selectCategory?.children?.isEmpty ?? false)
                        ? const SizedBox.shrink()
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: state.selectCategory?.children?.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 168 / 180,
                              mainAxisSpacing: 10.r,
                              crossAxisSpacing: 9.r,
                              crossAxisCount: 2,
                              mainAxisExtent: 180.r,
                            ),
                            padding: REdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            itemBuilder: (context, index) {
                              final subCategory =
                                  state.selectCategory?.children?[index];
                              return GestureDetector(
                                onTap: () {
                                  AppRoute.goProductList(
                                    context: context,
                                    title: subCategory?.translation?.title,
                                    categoryId: subCategory?.id,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 92.r,
                                          margin: REdgeInsets.only(top: 40),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            color: colors.newBoxColor,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 4,
                                          left: 8,
                                          right: 8,
                                          child: CustomNetworkImage(
                                            url: subCategory?.img,
                                            width: 100,
                                            height: 120,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                    16.verticalSpace,
                                    Text(
                                      subCategory?.translation?.title ??
                                          AppHelpers.getTranslation(
                                              TrKeys.noTitle),
                                      style: CustomStyle.interNormal(
                                        color: colors.textBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
              ),
            ],
          ),
        );
      },
    );
  }
}
