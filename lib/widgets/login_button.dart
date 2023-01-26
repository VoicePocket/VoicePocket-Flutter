import 'package:flutter/material.dart';
import 'package:voicepocket/constants/sizes.dart';

class LoginButton extends StatelessWidget {
  final bool disabled;

  const LoginButton({
    required this.disabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.only(bottom: Sizes.size10),
        decoration: BoxDecoration(
          color:
              disabled ? Colors.grey.shade200 : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Sizes.size32),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            color: disabled ? Colors.grey.shade600 : Colors.white,
            fontSize: Sizes.size20,
            fontWeight: FontWeight.w600,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "로그인",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
