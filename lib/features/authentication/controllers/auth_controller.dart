import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telechat/app/pages/home/home_page.dart';
import 'package:telechat/app/pages/splash/splash_page.dart';
import 'package:telechat/app/utils/navigator.dart';
import 'package:telechat/app/utils/util_function.dart';
import 'package:telechat/core/config/app_log.dart';
import 'package:telechat/core/extensions/string.dart';
import 'package:telechat/features/authentication/pages/fill_user_info_page.dart';
import 'package:telechat/features/authentication/repository/auth_repository.dart';

import '../pages/verify_opt_page.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  //* Verify OTP

  Future<void> resendOTP({
    required String phoneNumber,
    required void Function(String? verificationId) onCompleted,
  }) async {
    try {
      await authRepository.signInWithPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, resendToken) {
          AppNavigator.showMessage(
            "Resent OTP successful!",
            type: SnackbarType.success,
          );
          onCompleted.call(verificationId);
        },
        timeOut: (verificationId) {
          logger.e("resendOTP: timeOut($verificationId)");
          onCompleted.call(null);
        },
      );
    } catch (e) {
      logger.e(e.toString());
      onCompleted.call(null);
    }
  }

  Future<void> verifyOTP({
    required String verificationId,
    required String userOTP,
  }) async {
    final result = await authRepository.verifyOTP(
      verificationId: verificationId,
      userOTP: userOTP,
    );
    result.fold(
      (error) {
        logger.e(error.message);
        AppNavigator.showMessage(
          "Please check and enter the correct verification code again.",
          type: SnackbarType.error,
        );
      },
      (userCredential) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          AppNavigator.pushNamedAndRemoveUntil(FillUserInfoPage.route);
        } else {
          AppNavigator.pushNamedAndRemoveUntil(HomePage.route);
        }
      },
    );
  }

  //* Sign In

  Future<void> sendCodeToPhoneNumber({
    required String? countryCode,
    required String phoneNumber,
    required VoidCallback onCompleted,
  }) async {
    void showErrorMessage(String msg) {
      AppNavigator.showMessage(
        msg,
        type: SnackbarType.error,
      );
      onCompleted();
    }

    UtilsFunction.unfocusTextField();
    if (phoneNumber.isEmpty) {
      showErrorMessage("Please enter your phone number");
      return;
    }
    if (countryCode.isNullOrEmpty) {
      showErrorMessage("Please select country code");
      return;
    }
    if (phoneNumber.length < 6) {
      showErrorMessage("Invalid phone number");
      return;
    }
    await _signInWithPhoneNumber("$countryCode$phoneNumber", onCompleted);
  }

  Future<void> _signInWithPhoneNumber(String phoneNumber, VoidCallback onCompleted) async {
    try {
      await authRepository.signInWithPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, resendToken) {
          onCompleted.call();
          AppNavigator.pushNamed(VerifyOTPPage.route, arguments: {
            "verificationId": verificationId,
            "phoneNumber": phoneNumber,
          });
        },
        timeOut: (verificationId) {
          logger.e("_signInWithPhoneNumber: timeOut($verificationId)");
          onCompleted.call();
        },
      );
    } catch (e) {
      logger.e(e.toString());
      onCompleted.call();
    }
  }

  //* Sign out / Logout
  Future<void> signOut() async {
    try {
      await authRepository.signOut();
      await AppNavigator.pushReplacementNamed(SplashPage.route);
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
