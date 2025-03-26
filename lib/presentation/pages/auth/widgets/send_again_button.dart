import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goshops/application/auth/auth_bloc.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/firebase/firebase_service.dart';
import 'package:goshops/presentation/components/components.dart';

import 'package:goshops/presentation/style/theme/theme.dart';

class SendAgainButton extends StatefulWidget {
  final bool isLoading;
  final CustomColorSet colors;
  final String phone;
  final String? email;
  final bool isReset;

  const SendAgainButton({
    super.key,
    required this.isLoading,
    required this.colors,
    required this.phone,
    this.email,
    this.isReset = false,
  });

  @override
  State<SendAgainButton> createState() => _SendAgainButtonState();
}

class _SendAgainButtonState extends State<SendAgainButton> {
  Timer? timer;
  int initialTime = 120;
  String timerText = "02:00";

  startTime() {
    timer?.cancel();
    initialTime = 120;
    if (timer != null) {
      initialTime = 120;
      timer?.cancel();
    }
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (initialTime < 1) {
          timer.cancel();
          timerText = "0";
          setState(() {});
        } else {
          initialTime--;
          timerText = AppHelpers.formatHHMMSS(initialTime);
          setState(() {});
        }
      },
    );
  }

  @override
  void initState() {
    startTime();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        title: timerText != "0"
            ? timerText
            : AppHelpers.getTranslation(TrKeys.send),
        bgColor: timerText != "0"
            ? widget.colors.newBoxColor
            : widget.colors.textBlack,
        titleColor: timerText != "0"
            ? widget.colors.textBlack.withOpacity(0.5)
            : widget.colors.textWhite,
        onTap: () {
          final event = context.read<AuthBloc>();
          if (timerText == "0") {
            if (widget.isReset) {
              if (widget.email != null) {
                event.add(AuthEvent.forgotPassword(
                    context: context,
                    email: widget.email ?? '',
                    onSuccess: () {
                      event.add(AuthEvent.setVerificationId(id: "id"));
                    }));
                return;
              }
            }
            if (widget.email != null) {
              event.add(AuthEvent.signUpEmail(
                  context: context, email: widget.email ?? ""));
            }
            FirebaseService.sendCode(
                phone: widget.phone,
                onSuccess: (id) {
                  event.add(AuthEvent.setVerificationId(id: id));
                  startTime();
                },
                onError: (e) {
                  AppHelpers.errorSnackBar(context: context, message: e);
                });
          }
        });
  }
}
