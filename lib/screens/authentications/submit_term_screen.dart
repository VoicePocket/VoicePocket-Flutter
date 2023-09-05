import 'package:flutter/material.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';

import 'submit_info_screen.dart';

class SubmitTermScreen extends StatelessWidget {
  static const routeName = 'submitTerm';
  static const routeURL = '/submitTerm';

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
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 35,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v52,
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
            Text(
              '아래로 스크롤해서 동의',
              style: TextStyle(
                fontSize: Sizes.size24,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w900,
                fontFamily: "contents_font",
              ),
            ),
            Gaps.v52,
            Text(
              '개인정보 처리방침',
              style: TextStyle(
                fontSize: Sizes.size28,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w900,
                fontFamily: "contents_font",
              ),
            ),
            Gaps.v52,
            const Text(
              "< VoicePocket >\n('https://github.com/VoicePocket'이하 'VoicePocket')은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.\n\n○ 이 개인정보처리방침은 2023년 9월 20부터 적용됩니다.\n\n제1조(개인정보의 처리 목적)\n\n< VoicePocket >('https://github.com/VoicePocket'이하 'VoicePocket')은(는) 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n* 		1. 홈페이지 회원가입 및 관리회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리 목적으로 개인정보를 처리합니다.\n* 		2. 재화 또는 서비스 제공서비스 제공, 콘텐츠 제공, 맞춤서비스 제공을 목적으로 개인정보를 처리합니다.\n\n제2조(개인정보의 처리 및 보유 기간)\n\n① < VoicePocket >은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.\n\n② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.\n* 		1.<홈페이지 회원가입 및 관리>\n* 		<홈페이지 회원가입 및 관리>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<60일>까지 위 이용목적을 위하여 보유.이용됩니다.\n* 		보유근거 : 회원 식별 및 서비스 제공\n\n제3조(처리하는 개인정보의 항목)\n\n① < VoicePocket >은(는) 다음의 개인정보 항목을 처리하고 있습니다.\n* 		1< 홈페이지 회원가입 및 관리 >\n* 		필수항목 : 이름, 로그인ID, 비밀번호, 접속 로그, 서비스 이용 기록\n\n제4조(개인정보의 제3자 제공에 관한 사항)\n\n① < VoicePocket >은(는) 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 「개인정보 보호법」 제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.\n② < VoicePocket >은(는) 다음과 같이 개인정보를 제3자에게 제공하고 있습니다.\n* 		1. < Google >\n* 		개인정보를 제공받는 자 : Google\n* 		제공받는 자의 개인정보 이용목적 : 이름, 서비스 이용 기록\n* 		제공받는 자의 보유.이용기간: 60일\n\n제5조(개인정보의 파기절차 및 파기방법)\n\n① < VoicePocket > 은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n\n② 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.\n1. 법령 근거 :\n2. 보존하는 개인정보 항목 : 계좌정보, 거래날짜\n③ 개인정보 파기의 절차 및 방법은 다음과 같습니다.\n1. 파기절차< VoicePocket > 은(는) 파기 사유가 발생한 개인정보를 선정하고, < VoicePocket > 의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.\n2. 파기방법 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다\n\n제6조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)\n\n① 정보주체는 VoicePocket에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.\n② 제1항에 따른 권리 행사는VoicePocket에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 VoicePocket은(는) 이에 대해 지체 없이 조치하겠습니다.\n③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다.이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.\n④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.\n⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.\n⑥ VoicePocket은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.\n\n제7조(개인정보의 안전성 확보조치에 관한 사항)\n\n< VoicePocket >은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.\n1. 개인정보에 대한 접근 제한개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.\n2. 개인정보의 암호화이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.\n\n제8조(개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)\n\nVoicePocket 은(는) 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용하지 않습니다.\n\n제9조(가명정보를 처리하는 경우 가명정보 처리에 관한 사항)\n\n< VoicePocket > 은(는) 다음과 같은 목적으로 가명정보를 처리하고 있습니다.\n\n▶ 가명정보의 처리 목적\n- 회원 식별\n\n▶ 가명정보의 처리 및 보유기간\n- 60일\n\n▶ 가명처리하는 개인정보의 항목\n- 닉네임\n\n제10조 (개인정보 보호책임자에 관한 사항)\n\n① VoicePocket 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n* 		▶ 개인정보 보호책임자\n* 		성명 :VoicePocket\n\n제12조(정보주체의 권익침해에 대한 구제방법)\n\n정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.\n\n1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)\n2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)\n3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)\n4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)\n\n「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.\n\n※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회(www.simpan.go.kr) 홈페이지를 참고하시기 바랍니다.\n\n제13조(개인정보 처리방침 변경)\n\n① 이 개인정보처리방침은 2023년 9월 20부터 적용됩니다.",
              style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w900,
                  fontFamily: "contents_font"),
            ),
            Gaps.v52,
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
    );
  }
}
