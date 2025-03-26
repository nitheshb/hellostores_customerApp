import 'package:goshops/infrastructure/model/model/product_model.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/application/compare/compare_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goshops/app_constants.dart';
import 'package:flutter/material.dart';
import 'widgets/additional_info.dart';
import 'widgets/review_compare.dart';
import 'widgets/price_compare.dart';
import 'widgets/title_compare.dart';
import 'widgets/extras_info.dart';
import 'widgets/main_info.dart';

class CompareProductPage extends StatelessWidget {
  final List<ProductData> list;

  const CompareProductPage({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: list.first.category?.translation?.title ?? "",
      ),
      body: (colors) => BlocBuilder<CompareBloc, CompareState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(vertical: 16.r),
              child: Table(
                border: TableBorder.all(
                  color: colors.newBoxColor,
                  borderRadius: BorderRadius.circular(AppConstants.radius.r),
                ),
                defaultColumnWidth: FixedColumnWidth(
                  (MediaQuery.sizeOf(context).width - 90.r) / 2,
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                children: [
                  TableRow(children: [
                    ...list.map(
                      (e) {
                        return TitleCompare(colors: colors, product: e);
                      },
                    ),
                  ]),
                  TableRow(children: [
                    ...list.map(
                      (e) {
                        return ReviewCompare(colors: colors, product: e);
                      },
                    ),
                  ]),
                  TableRow(children: [
                    ...list.map(
                      (e) {
                        return PriceCompare(colors: colors, product: e);
                      },
                    ),
                  ]),
                  TableRow(children: [
                    ...list.map(
                      (e) {
                        return CategoryInfo(colors: colors, product: e);
                      },
                    ),
                  ]),
                  TableRow(children: [
                    ...list.map(
                      (e) {
                        return BrandInfo(colors: colors, product: e);
                      },
                    ),
                  ]),
                  ...state.extraGroup.map((properties) {
                    return TableRow(children: [
                      ...list.map(
                        (e) {
                          return ExtrasInfo(
                            colors: colors,
                            properties: properties,
                            product: e,
                          );
                        },
                      ),
                    ]);
                  }),
                  ...state.propertyGroup.map((properties) {
                    return TableRow(children: [
                      ...list.map(
                        (e) {
                          return AdditionalInfo(
                            colors: colors,
                            properties: properties,
                            product: e,
                          );
                        },
                      ),
                    ]);
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
