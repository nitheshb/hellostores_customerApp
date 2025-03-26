import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/filter/filter_bloc.dart';
import 'package:goshops/application/select/select_bloc.dart';
import 'package:goshops/infrastructure/model/response/filter_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/theme/theme.dart';
import 'extras_item.dart';

class ExtrasScreen extends StatelessWidget {
  final CustomColorSet colors;
  final Group? group;

  const ExtrasScreen({
    super.key,
    required this.colors,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: (colors) => CustomAppBar(
        colors: colors,
        context: context,
        title: group?.title,
      ),
      body: (colors) {
        return BlocBuilder<SelectBloc, SelectState>(
          builder: (context, state) {
            return Padding(
              padding: REdgeInsets.only(bottom: 78),
              child: ListView(
                padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: group?.extras
                        ?.map(
                          (e) => InkWell(
                            onTap: () {
                              context
                                  .read<SelectBloc>()
                                  .add(SelectEvent.selectId(id: e.id));
                            },
                            child: ExtrasItem(
                              list: state.selectIds,
                              type: group?.type ?? "",
                              extra: e,
                              colors: colors,
                            ),
                          ),
                        ).toList() ?? [],
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
                        ..add(FilterEvent.setExtras(ids: state.selectIds))
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
