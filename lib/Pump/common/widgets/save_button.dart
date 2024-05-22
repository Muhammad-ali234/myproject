import 'package:flutter/material.dart';
import 'package:myproject/Common/constant.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const SaveButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.dashbordWhiteColor,
              backgroundColor: AppColor.dashbordBlueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }
}
