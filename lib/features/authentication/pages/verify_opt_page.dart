import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:telechat/app/configs/remote_config.dart';
import 'package:telechat/core/extensions/string.dart';
import 'package:telechat/features/authentication/widgets/auth_body_frame_widget.dart';

import '../../../app/themes/themes.dart';
import '../../../app/widgets/widgets.dart';
import '../controllers/auth_controller.dart';

class VerifyOTPPage extends ConsumerStatefulWidget {
  static const String route = "/verify-otp";
  const VerifyOTPPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  final String verificationId;
  final String phoneNumber;

  @override
  ConsumerState<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends ConsumerState<VerifyOTPPage> {
  final otpController = TextEditingController();
  final ValueNotifier<bool> confirmNotifier = ValueNotifier(false);
  final ValueNotifier<bool> resendNotifier = ValueNotifier(false);
  final ValueNotifier<int> timerNotifier = ValueNotifier(RemoteConfig.otpTimeOutInSeconds);
  Timer? _timer;
  String? verificationId;

  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId;
    WidgetsBinding.instance.addPostFrameCallback((_) => runCountDownTimer());
  }

  void runCountDownTimer() {
    timerNotifier.value = RemoteConfig.otpTimeOutInSeconds;
    _timer ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (timerNotifier.value > 0) {
          timerNotifier.value = timerNotifier.value - 1;
        } else {
          _timer?.cancel();
          _timer = null;
        }
      },
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBodyFrameWidget(
      title: "Enter your OTP",
      body: Column(
        children: [
          Pinput(
            controller: otpController,
            showCursor: true,
            length: 6,
            defaultPinTheme: PinTheme(
              width: 54.r,
              height: 54.r,
              textStyle: AppTextStyle.titleS.bold,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            separatorBuilder: (_) => const Gap.small(),
            hapticFeedbackType: HapticFeedbackType.mediumImpact,
          ),
          const Gap.extra(),
          ValueListenableBuilder(
            valueListenable: timerNotifier,
            child: ValueListenableBuilder(
              valueListenable: resendNotifier,
              builder: (context, bool isResending, _) {
                return isResending
                    ? const LoadingIndicatorWidget()
                    : PrimaryButton.text(
                        text: "Resend OTP",
                        onPressed: () {
                          if (!isResending) {
                            resendNotifier.value = true;
                            ref.read(authControllerProvider).resendOTP(
                                  phoneNumber: widget.phoneNumber,
                                  onCompleted: (id) {
                                    resendNotifier.value = false;
                                    if (id.isNotNullOrEmpty) {
                                      verificationId = id;
                                      runCountDownTimer();
                                    }
                                  },
                                );
                          }
                        },
                        backgroundColor: AppColors.background,
                        textColor: AppColors.primary,
                        width: 0,
                        height: 40.h,
                      );
              },
            ),
            builder: (context, int time, child) {
              return time > 0
                  ? Text(
                      "Resend after: ${time}s",
                      style: AppTextStyle.bodyS.white,
                    )
                  : child!;
            },
          )
        ],
      ),
      bottom: PrimaryButton(
        onPressed: () async {
          if (!confirmNotifier.value) {
            confirmNotifier.value = true;
            await ref.read(authControllerProvider).verifyOTP(
                  verificationId: verificationId!,
                  userOTP: otpController.text.trim(),
                );
            confirmNotifier.value = false;
          }
        },
        child: ValueListenableBuilder(
          valueListenable: confirmNotifier,
          builder: (context, bool isVerifing, _) {
            return isVerifing
                ? const LoadingIndicatorWidget(
                    color: AppColors.background,
                  )
                : Text(
                    "Verify OTP",
                    style: AppTextStyle.bodyS.bg,
                  );
          },
        ),
      ),
    );
  }
}
