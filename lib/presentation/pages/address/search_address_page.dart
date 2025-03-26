import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/application/address/address_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/components/components.dart';
import 'package:goshops/presentation/style/style.dart';

class SearchAddressPage extends StatelessWidget {
  const SearchAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: (colors) => SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      PopButton(color: colors.textBlack),
                      8.horizontalSpace,
                      Text(
                        AppHelpers.getTranslation(TrKeys.searchLocation),
                        style: CustomStyle.interNoSemi(
                            color: colors.textBlack, size: 18),
                      ),
                    ],
                  ),
                  24.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.r,
                          child: CustomTextFormField(
                            autoFocus: true,
                            onTap: () {},
                            onChanged: (s) {
                              Delayed(milliseconds: 700).run(() {
                                context.read<AddressBloc>().add(
                                    AddressEvent.searchAddress(
                                        context: context, search: s));
                              });
                            },
                            radius: 100,
                            prefixIcon: const Icon(
                              FlutterRemix.search_2_line,
                              color: CustomStyle.textHint,
                            ),
                            hint: AppHelpers.getTranslation(TrKeys.search),
                          ),
                        ),
                        24.verticalSpace,
                        BlocBuilder<AddressBloc, AddressState>(
                          builder: (context, state) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.autoTitles.length,
                                itemBuilder: (context, index) {
                                  return ButtonEffectAnimation(
                                    onTap: () async {},
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                state.autoTitles[index]
                                                        .description ??
                                                    "",
                                                style: CustomStyle.interNormal(
                                                    color: colors.textBlack),
                                              ),
                                            ),
                                            16.horizontalSpace,
                                            Icon(FlutterRemix.road_map_line,
                                                color: colors.textBlack)
                                          ],
                                        ),
                                        const Divider(),
                                        16.verticalSpace,
                                      ],
                                    ),
                                  );
                                });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
