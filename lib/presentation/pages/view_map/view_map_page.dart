import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goshops/application/shop/shop_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/themes/map_themes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'shop_bottom_sheet.dart';

class ViewMapPage extends StatefulWidget {
  const ViewMapPage({super.key});

  @override
  State<ViewMapPage> createState() => _ViewMapPageState();
}

class _ViewMapPageState extends State<ViewMapPage> {
  late RefreshController shopsRefresh;

  @override
  void initState() {
    super.initState();
    shopsRefresh = RefreshController();
  }

  @override
  void dispose() {
    shopsRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: (colors) => Stack(
        children: [
          BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              return Padding(
                padding: REdgeInsets.only(bottom: 100),
                child: Stack(
                  children: [
                    GoogleMap(
                      padding: REdgeInsets.only(bottom: 15),
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        bearing: 0,
                        target: LatLng(
                          AppHelpers.getInitialLatitude(),
                          AppHelpers.getInitialLongitude(),
                        ),
                        tilt: 0,
                        zoom: 12,
                      ),
                      style: AppMapThemes.getTheme(),
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      markers: Set<Marker>.of(state.shopMarkers.values),
                    ),
                  ],
                ),
              );
            },
          ),
          ShopBottomSheet(
            shopsRefresh: shopsRefresh,
            colors: colors,
          ),
        ],
      ),
    );
  }
}
