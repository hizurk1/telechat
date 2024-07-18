import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telechat/app/themes/themes.dart';
import 'package:telechat/app/widgets/border_text_field.dart';
import 'package:telechat/app/widgets/gap.dart';
import 'package:telechat/app/widgets/loading_indicator.dart';
import 'package:telechat/app/widgets/primary_button.dart';
import 'package:telechat/app/widgets/unfocus.dart';
import 'package:telechat/features/authentication/controllers/auth_controller.dart';

class SignInPage extends ConsumerStatefulWidget {
  static const String route = "/sign-in";

  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final phoneController = TextEditingController();
  final ValueNotifier<bool> logingInNotifier = ValueNotifier(false);
  String? countryCode;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: UnfocusArea(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Enter your phone number",
                          style: AppTextStyle.headingL,
                        ),
                        const Gap.extra(),
                        BorderTextField(
                          controller: phoneController,
                          autofocus: true,
                          inputType: TextInputType.phone,
                          maxLength: 12,
                          textStyle: AppTextStyle.bodyL.copyWith(
                            letterSpacing: 1.5,
                          ),
                          prefix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CountryCodePicker(
                                showFlag: false,
                                showFlagDialog: true,
                                initialSelection: "+0",
                                textStyle: AppTextStyle.bodyS.white.copyWith(
                                  letterSpacing: 1.5,
                                ),
                                dialogItemPadding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                  horizontal: 24.w,
                                ),
                                searchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                dialogBackgroundColor: AppColors.background,
                                barrierColor: Colors.black.withOpacity(.5),
                                showDropDownButton: true,
                                onChanged: (code) {
                                  countryCode = code.dialCode;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //* Button
                PrimaryButton(
                  onPressed: () {
                    if (!logingInNotifier.value) {
                      logingInNotifier.value = true;
                      ref.read(authControllerProvider).sendCodeToPhoneNumber(
                            countryCode: countryCode,
                            phoneNumber: phoneController.text.trim(),
                            onCompleted: () => logingInNotifier.value = false,
                          );
                    }
                  },
                  child: ValueListenableBuilder(
                    valueListenable: logingInNotifier,
                    builder: (context, bool isLoging, _) {
                      return isLoging
                          ? const LoadingIndicatorWidget(
                              color: AppColors.background,
                            )
                          : Text(
                              "Send code",
                              style: AppTextStyle.bodyS.bg,
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
