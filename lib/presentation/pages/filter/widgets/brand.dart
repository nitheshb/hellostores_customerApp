import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/filter/filter_bloc.dart';
import 'package:goshops/application/select/select_bloc.dart';
import 'package:goshops/infrastructure/model/response/filter_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class BrandScreen extends StatelessWidget {
  final CustomColorSet colors;
  final List<Brand>? brandes;

  const BrandScreen({
    super.key,
    required this.colors,
    required this.brandes,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: TrKeys.brandes,
      ),
      body: (colors) {
        return BlocBuilder<SelectBloc, SelectState>(
          builder: (context, state) {
            return Padding(
              padding: REdgeInsets.only(bottom: 78),
              child: ListView(
                padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: brandes
                        ?.map((e) => InkWell(
                              onTap: () {
                                context
                                    .read<SelectBloc>()
                                    .add(SelectEvent.selectId(id: e.id));
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        state.selectIds.contains(e.id)
                                            ? FlutterRemix.checkbox_fill
                                            : FlutterRemix.checkbox_blank_line,
                                        color: state.selectIds.contains(e.id)
                                            ? colors.primary
                                            : colors.textBlack,
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        e.title ?? '',
                                        style: CustomStyle.interNormal(
                                          size: 14,
                                          color: colors.textBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(color: colors.icon),
                                ],
                              ),
                            ))
                        .toList() ??
                    [],
              ),
            );
          },
        );
      },
      floatingButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingButton: (colors) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<SelectBloc, SelectState>(
              builder: (context, state) {
                return CustomButton(
                    title: AppHelpers.getTranslation(TrKeys.show),
                    bgColor: colors.primary,
                    titleColor: colors.textWhite,
                    onTap: () {
                      context.read<FilterBloc>()
                        ..add(FilterEvent.setBrands(ids: state.selectIds))
                        ..add(FilterEvent.fetchExtras(
                          context: context,
                          isPrice: true,
                        ));
                      Navigator.pop(context);
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
