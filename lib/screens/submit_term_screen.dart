import 'package:flutter/material.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/submit_info_screen.dart';

class SubmitTermScreen extends StatelessWidget {
  const SubmitTermScreen({super.key});

  void _onAgreeTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubmitInfoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 35,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Voice Pocket과\n추억을 쌓아봐요!',
                style: TextStyle(
                  fontSize: Sizes.size32,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w900,
                  fontFamily: "contents_font",
                ),
              ),
              Gaps.v52,
              const Text(
                '약관 내용\n약관 내용\n약관 내용\n약관 내용',
                style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w900,
                    fontFamily: "contents_font"),
              ),
              Gaps.v96,
              Gaps.v96,
              Gaps.v96,
              GestureDetector(
                onTap: () => _onAgreeTab(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Sizes.size32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "동의함",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
