import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goshops/application/category/category_bloc.dart';
import 'package:goshops/application/filter/filter_bloc.dart';
import 'package:goshops/application/select/select_bloc.dart';
import 'package:goshops/infrastructure/model/response/filter_response.dart';
import 'package:goshops/presentation/pages/filter/widgets/brand.dart';
import 'package:goshops/presentation/pages/filter/widgets/category.dart';
import 'package:goshops/presentation/pages/filter/widgets/extras.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

import '../pages/filter/widgets/sorting.dart';

abstract class FilterRoute {
  FilterRoute._();

  static goBrandPage(
    final CustomColorSet colors,
    final List<Brand>? brandes,
    final List<int> list,
    final BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<FilterBloc>()),
            BlocProvider(
                create: (context) =>
                    SelectBloc()..add(SelectEvent.selectIds(ids: list)))
          ],
          child: BrandScreen(colors: colors, brandes: brandes),
        ),
      ),
    );
  }

  static goSortingPage(
    final CustomColorSet colors,
    final BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<FilterBloc>()),
          ],
          child: SortingScreen(colors: colors),
        ),
      ),
    );
  }

  static goExtrasPage(
    final CustomColorSet colors,
    final Group? group,
    final List<int> list,
    final BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<FilterBloc>()),
            BlocProvider(
                create: (context) =>
                    SelectBloc()..add(SelectEvent.selectIds(ids: list)))
          ],
          child: ExtrasScreen(colors: colors, group: group),
        ),
      ),
    );
  }

  static goCategoryPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<FilterBloc>()),
            BlocProvider.value(value: context.read<CategoryBloc>()),
          ],
          child: const FilterCategoryPage(),
        ),
      ),
    );
  }
}
