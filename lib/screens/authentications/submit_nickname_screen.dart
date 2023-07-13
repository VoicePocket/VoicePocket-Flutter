import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';
import 'package:voicepocket/screens/authentications/submit_info_screen.dart';
import 'package:voicepocket/services/signup_post.dart';

class SubmitNicknameScreen extends StatefulWidget {
  static const routeName = 'submitNickname';
  static const routeURL = '/submitNickname';
  final String email, password;
  const SubmitNicknameScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<SubmitNicknameScreen> createState() => _SubmitNicknameScreenState();
}

class _SubmitNicknameScreenState extends State<SubmitNicknameScreen> {
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _nickName = "", _name = "";

  void _onScaffoldTab() => FocusScope.of(context).unfocus();

  bool _isNicknameValid() {
    if (_nickName.length < 3 || _nickName.length > 10) {
      return false;
    } else {
      return true;
    }
  }

  void _onSubmit() async {
    if (!_isNicknameValid()) return;
    final signUpModel =
        await signUpPost(widget.email, widget.password, _name, _nickName);
    if (!mounted) return;
    if (signUpModel.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("회원 가입 성공했습니다."),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFFA594F9),
        ),
      );
      context.pushReplacementNamed(HomeScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(signUpModel.message),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red.shade500,
        ),
      );
      context.pop(SubmitInfoScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
    _nickNameController.addListener(() {
      setState(() {
        _nickName = _nickNameController.text;
      });
    });
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTab,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                '닉네임과 이름을\n입력해주세요',
                style: TextStyle(
                  fontSize: Sizes.size32,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Gaps.v52,
              const Text(
                '이름',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w900,
                  color: Color(0XFF929292),
                ),
              ),
              TextField(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: Sizes.size16 + Sizes.size2,
                ),
                controller: _nameController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      Sizes.size32,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _name.isEmpty ? Colors.red : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      Sizes.size32,
                    ),
                  ),
                ),
              ),
              Gaps.v10,
              const Text(
                '닉네임',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w900,
                  color: Color(0XFF929292),
                ),
              ),
              TextField(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: Sizes.size16 + Sizes.size2,
                ),
                controller: _nickNameController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      Sizes.size32,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          _nickName.isEmpty ? Colors.red : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      Sizes.size32,
                    ),
                  ),
                ),
              ),
              const Text(
                'Your nickname must have:',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w900,
                  color: Color(0XFF929292),
                ),
              ),
              Gaps.v10,
              Row(
                children: [
                  FaIcon(
                    _isNicknameValid()
                        ? FontAwesomeIcons.circleCheck
                        : FontAwesomeIcons.circleXmark,
                    color: _isNicknameValid() ? Colors.green : Colors.red,
                    size: Sizes.size20,
                  ),
                  Gaps.h5,
                  const Text(
                    '3 to 10 characters',
                    style: TextStyle(
                      fontSize: Sizes.size14,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF929292),
                    ),
                  ),
                ],
              ),
              Gaps.v96,
              Gaps.v96,
              GestureDetector(
                onTap: () => _onSubmit(),
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
                        "시작하기",
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
