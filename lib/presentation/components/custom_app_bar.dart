import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/presentation/style/style.dart';
import 'package:goshops/presentation/style/theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CustomColorSet colors;
  final BuildContext context;
  final String? title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.colors,
    required this.context,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.1,
      backgroundColor: colors.backgroundColor,
      leading: IconButton(
        splashRadius: 20.r,
        icon: Icon(
          LocalStorage.getLangLtr()
              ? FlutterRemix.arrow_left_s_line
              : FlutterRemix.arrow_right_s_line,
          size: 24.r,
          color: colors.textBlack,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: actions,
      title: Row(
        children: [
          Expanded(
            child: Text(
              AppHelpers.getTranslation(title ?? ''),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CustomStyle.interNormal(color: colors.textBlack),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(54.r);
}
