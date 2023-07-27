import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';
import 'package:voicepocket/screens/authentications/main_screen.dart';
import 'package:voicepocket/screens/authentications/submit_info_screen.dart';
import 'package:voicepocket/screens/authentications/submit_nickname_screen.dart';
import 'package:voicepocket/screens/authentications/submit_term_screen.dart';
import 'package:voicepocket/screens/friend/friend_main_screen.dart';
import 'package:voicepocket/services/notification_provider.dart';

final routeProvider = Provider((ref) {
  bool isAuth = false;
  SharedPreferences.getInstance().then((value) {
    isAuth = value.containsKey('accessToken');
  });
  return GoRouter(
    initialLocation: isAuth ? HomeScreen.routeURL : MainScreen.routeURL,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          ref.read(notificationProvider(context));
          return child;
        },
        routes: [
          GoRoute(
            name: MainScreen.routeName,
            path: MainScreen.routeURL,
            builder: (context, state) => const MainScreen(),
          ),
          GoRoute(
            name: HomeScreen.routeName,
            path: HomeScreen.routeURL,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            name: SubmitInfoScreen.routeName,
            path: SubmitInfoScreen.routeURL,
            builder: (context, state) => const SubmitInfoScreen(),
          ),
          GoRoute(
              name: SubmitNicknameScreen.routeName,
              path: SubmitNicknameScreen.routeURL,
              builder: (context, state) {
                final email = state.queryParameters['email']!;
                final password = state.queryParameters['password']!;
                return SubmitNicknameScreen(
                  email: email,
                  password: password,
                );
              }),
          GoRoute(
            name: SubmitTermScreen.routeName,
            path: SubmitTermScreen.routeURL,
            builder: (context, state) => const SubmitTermScreen(),
          ),
          GoRoute(
              name: FriendMainScreen.routeName,
              path: FriendMainScreen.routeURL,
              builder: (context, state) {
                final index = int.parse(state.queryParameters['index']!);
                return FriendMainScreen(
                  index: index,
                );
              }),
        ],
      ),
    ],
  );
});
