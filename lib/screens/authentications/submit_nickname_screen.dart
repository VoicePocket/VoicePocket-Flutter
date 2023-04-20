import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/main_screen.dart';
import 'package:voicepocket/services/signup_post.dart';

class SubmitNicknameScreen extends StatefulWidget {
  const SubmitNicknameScreen({
    super.key,
  });

  @override
  State<SubmitNicknameScreen> createState() => _SubmitNicknameScreenState();
}

class _SubmitNicknameScreenState extends State<SubmitNicknameScreen> {
  late final SharedPreferences _pref;

  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _nickName = "", _name = "";

  void setToken(String name, String nickName) {
    _pref.setString('name', name);
    _pref.setString('nickName', nickName);
  }

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
    setToken(_name, _nickName);
    await signUpPost(_pref.getString("email")!, _pref.getString("password")!,
        _pref.getString("name")!, _pref.getString("nickName")!);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
      (route) => false,
    );
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
    SharedPreferences.getInstance().then((pref) => _pref = pref);
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
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
                        color:
                            _name.isEmpty ? Colors.red : Colors.grey.shade300,
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
                        color: _nickName.isEmpty
                            ? Colors.red
                            : Colors.grey.shade300,
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
                  onTap: _onSubmit,
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
      ),
    );
  }
}
