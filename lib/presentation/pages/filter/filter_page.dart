import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/filter/filter_bloc.dart';
import 'package:goshops/application/products/product_bloc.dart';
import 'package:goshops/infrastructure/service/currency_formatter.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/route/filter_route.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'widgets/filter_item.dart';
import 'widgets/layout.dart';
import 'widgets/price.dart';

class FilterPage extends StatefulWidget {
  final int? categoryId;

  const FilterPage({super.key, required this.categoryId});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final delayed = Delayed(milliseconds: 60 * 30);
  late TextEditingController from;
  late TextEditingController to;
  final CurrencyTextInputFormatter formatter =
      CurrencyTextInputFormatter.currency();

  @override
  void initState() {
    final state = context.read<FilterBloc>().state;
    from = TextEditingController(
      text: formatter.formatDouble(state.rangeValues?.start.toDouble() ?? 0.0),
    );
    to = TextEditingController(
      text: formatter.formatDouble(state.rangeValues?.end.toDouble() ?? 0.0),
    );
    super.initState();
  }

  @override
  void dispose() {
    from.dispose();
    to.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: TrKeys.filter,
        actions: [
          InkWell(
            onTap: () {
              context.read<FilterBloc>()
                ..add(const FilterEvent.clearFilter())
                ..add(FilterEvent.fetchExtras(context: context, isPrice: true));
            },
            child: Row(
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.clearAll),
                  style: CustomStyle.interNormal(
                    color: CustomStyle.red,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
          16.horizontalSpace,
        ],
      ),
      body: (colors) => BlocConsumer<FilterBloc, FilterState>(
        listenWhen: (p, n) {
          return p.filterPrices?.max != n.filterPrices?.max ||
              p.filterPrices?.min != n.filterPrices?.min;
        },
        listener: (context, state) {
          if (state.rangeValues == null) {
            from.clear();
            to.clear();
          } else {
            // from = TextEditingController(
            //   text: formatter.formatString("${state.filterPrices?.min ?? 0}"),
            // );
            // to = TextEditingController(
            //   text: formatter.formatString("${state.filterPrices?.max ?? 0}"),
            // );
          }
        },
        builder: (context, state) {
          return BlocBuilder<FilterBloc, FilterState>(
            builder: (context, state) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom + 8.r,
                      left: 16.r,
                      right: 16.r,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.verticalSpace,
                        if (widget.categoryId == null)
                          FilterItem(
                            colors: colors,
                            title: AppHelpers.getTranslation(TrKeys.categories),
                            subTitle: state.category?.translation?.title == null
                                ? null
                                : [state.category?.translation?.title ?? ''],
                            onTap: () {
                              FilterRoute.goCategoryPage(context);
                            },
                          ),
                        FilterItem(
                          colors: colors,
                          title: AppHelpers.getTranslation(TrKeys.sorting),
                          subTitle: [
                            AppHelpers.getTranslation(
                                AppHelpers.getFilterType(state.type))
                          ],
                          onTap: () {
                            FilterRoute.goSortingPage(colors, context);
                          },
                        ),
                        LayoutScreen(
                            colors: colors, selectType: state.selectType),
                        Divider(thickness: 2.r, color: colors.icon),
                        12.verticalSpace,
                        PriceFilter(
                          colors: colors,
                          delayed: delayed,
                          from: from,
                          state: state,
                          to: to,
                          categoryId: state.category?.id,
                        ),
                        8.verticalSpace,
                        if (state.filter?.brands?.isNotEmpty ?? false)
                          FilterItem(
                            colors: colors,
                            color: true,
                            subTitle: state.filter?.brands
                                ?.where((e) => state.brands.contains(e.id))
                                .map((e) => e.title)
                                .toList(),
                            title: AppHelpers.getTranslation(TrKeys.brandes),
                            onTap: () {
                              FilterRoute.goBrandPage(
                                colors,
                                state.filter?.brands,
                                state.brands,
                                context,
                              );
                            },
                          ),
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.filter?.group?.length ?? 0,
                            itemBuilder: (context, index) {
                              final selectedExtras = state
                                  .filter?.group?[index].extras
                                  ?.where((e) => state.extras.contains(e.id));
                              return FilterItem(
                                colors: colors,
                                color:
                                    state.filter?.group?[index].type == 'color',
                                title: state.filter?.group?[index].title,
                                subTitle: selectedExtras
                                    ?.map((e) => e.value)
                                    .toList(),
                                onTap: () {
                                  FilterRoute.goExtrasPage(
                                    colors,
                                    state.filter?.group?[index],
                                    state.extras,
                                    context,
                                  );
                                },
                              );
                            }),
                        // if (state.filterPrices?.max != state.filterPrices?.min &&
                        //     state.rangeValues != null)
                        // RangePrice(
                        //   colors: colors,
                        //   state: state,
                        // ),
                        16.verticalSpace,
                        CustomButton(
                            title:
                                "${AppHelpers.getTranslation(TrKeys.view)} ${state.filter?.count ?? 0} ${AppHelpers.getTranslation(TrKeys.products)}",
                            bgColor: colors.primary,
                            titleColor: CustomStyle.white,
                            onTap: () {
                              context
                                  .read<ProductBloc>()
                                  .add(ProductEvent.fetchProducts(
                                    isRefresh: true,
                                    context: context,
                                    brandId: state.brands,
                                    categoryId:
                                        widget.categoryId ?? state.category?.id,
                                    extrasId: state.extras,
                                    priceFrom: state.rangeValues?.start,
                                    priceTo: state.rangeValues?.end,
                                    isMostSale:
                                        state.type == FilterType.mostSold,
                                    isPopular: state.type == FilterType.popular,
                                    isNew: state.type == FilterType.news,
                                    minPrice: state.type == FilterType.priceMin,
                                    maxPrice: state.type == FilterType.priceMax,
                                  ));
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ),
                  if (state.isLoading) _customLoading(colors),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _customLoading(CustomColorSet colors) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: colors.backgroundColor.withOpacity(0.3),
        ),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: const Loading(),
        ),
      ),
    );
  }
}
