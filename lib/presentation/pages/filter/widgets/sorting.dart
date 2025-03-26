import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/filter/filter_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class SortingScreen extends StatelessWidget {
  final CustomColorSet colors;

  const SortingScreen({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: TrKeys.sorting,
      ),
      body: (colors) {
        return BlocBuilder<FilterBloc, FilterState>(
          builder: (context, state) {
            return Padding(
              padding: REdgeInsets.only(bottom: 78),
              child: ListView(
                padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: FilterType.values
                    .map((e) => InkWell(
                          onTap: () {
                            context.read<FilterBloc>()
                              .add(FilterEvent.selectSort(type: e));
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              4.verticalSpace,
                              Row(
                                children: [
                                  Icon(
                                    state.type == e
                                        ? FlutterRemix.checkbox_circle_fill
                                        : FlutterRemix
                                            .checkbox_blank_circle_line,
                                    color: state.type == e
                                        ? colors.primary
                                        : colors.textBlack,
                                  ),
                                  10.horizontalSpace,
                                  Text(
                                    AppHelpers.getTranslation(AppHelpers.getFilterType(e)),
                                    style: CustomStyle.interNormal(
                                      size: 14,
                                      color: colors.textBlack,
                                    ),
                                  ),
                                ],
                              ),
                              4.verticalSpace,
                              Divider(color: colors.icon),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            );
          },
        );
      },
    );
  }
}
