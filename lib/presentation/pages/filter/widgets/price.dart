import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/filter/filter_bloc.dart';
import 'package:goshops/infrastructure/service/currency_formatter.dart';
import 'package:goshops/infrastructure/service/extensions.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class PriceFilter extends StatelessWidget {
  final CustomColorSet colors;
  final Delayed delayed;
  final TextEditingController from;
  final TextEditingController to;
  final FilterState state;
  final int? categoryId;

  const PriceFilter({
    super.key,
    required this.colors,
    required this.delayed,
    required this.from,
    required this.state,
    required this.to,
    this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    final event = context.read<FilterBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 4),
          child: Text(
            AppHelpers.getTranslation(TrKeys.priceRange),
            style: CustomStyle.interNoSemi(
              size: 16,
              color: colors.textBlack,
            ),
          ),
        ),
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 6),
          child: Text(
            "${AppHelpers.numberFormat(
              decimalDigits: 0,
              state.filterPrices?.min,
            )} ${AppHelpers.getTranslation(TrKeys.to).toLowerCase()} ${AppHelpers.numberFormat(state.filterPrices?.max, decimalDigits: 0)}",
            style: CustomStyle.interNormal(
              size: 12,
              color: colors.textHint,
            ),
          ),
        ),
        8.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                hint: AppHelpers.numberFormat(state.filterPrices?.min),
                controller: from,
                inputType: TextInputType.number,
                onChanged: (s) {
                  delayed.run(() {
                    double? start;
                    double end = state.rangeValues?.end ??
                        state.filterPrices?.max?.toDouble() ??
                        0;
                    double v = s.toDouble ?? 0;
                    double max = (state.rangeValues?.end ?? 0);
                    double min = (state.filterPrices?.min?.toDouble() ?? 0);
                    debugPrint("\nmin: $min \nmax: $max \nv: $v");
                    if (v > max) {
                      start = max;
                      from.text = "${max.toInt()}";
                    }
                    // else if (v < min) {
                    //   start = min;
                    //   from.text = "${min.toInt()}";
                    // }
                    else {
                      start = v;
                    }
                    event
                      ..add(
                        FilterEvent.setRangePrice(
                          price: RangeValues(start, end),
                        ),
                      )
                      ..add(FilterEvent.fetchExtras(
                          context: context,
                          isPrice: false,
                          categoryId: categoryId));
                  });
                },
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.from).toLowerCase(),
                      style: CustomStyle.interNormal(
                          color: colors.textHint, size: 14),
                    ),
                  ],
                ),
                fillColor: colors.newBoxColor,
                inputFormatters: [CurrencyTextInputFormatter.simpleCurrency()],
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: CustomTextFormField(
                hint: AppHelpers.numberFormat(state.filterPrices?.max),
                controller: to,
                inputType: TextInputType.number,
                onChanged: (s) {
                  double v = s.toDouble ?? 0;
                  delayed.run(() {
                    double start = state.rangeValues?.start ??
                        state.filterPrices?.min?.toDouble() ??
                        0;
                    double? end;
                    double max = (state.filterPrices?.max?.toDouble() ?? 0);
                    double min = (state.rangeValues?.start ?? 0);
                    debugPrint("\nmin: $min \nmax: $max \nv: $v");
                    if (v > max) {
                      end = max;
                      to.text = "${max.toInt()}";
                    } else if (v < min) {
                      end = min;
                      to.text = "${min.toInt()}";
                    } else {
                      end = v;
                    }
                    event
                      ..add(
                        FilterEvent.setRangePrice(
                          price: RangeValues(start, end),
                        ),
                      )
                      ..add(FilterEvent.fetchExtras(
                        context: context,
                        isPrice: false,
                      ));
                  });
                },
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.to).toLowerCase(),
                      style: CustomStyle.interNormal(
                          color: colors.textHint, size: 14),
                    ),
                  ],
                ),
                fillColor: colors.newBoxColor,
                inputFormatters: [CurrencyTextInputFormatter.simpleCurrency()],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
