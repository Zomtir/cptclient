import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/json/session.dart';
import 'package:cptclient/material/widgets/LoadingWidget.dart';
import 'package:cptclient/pages/ConnectionPage.dart';
import 'package:cptclient/pages/EnrollPage.dart';
import 'package:cptclient/pages/LoginLandingPage.dart';
import 'package:cptclient/pages/MemberLandingPage.dart';
import 'package:cptclient/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Flutter triggers the route twice during cold start
// So i just block the 2nd call of the route change
// Otherwise the the route change is called during a route rebuild, which throws an error
// https://github.com/flutter/flutter/issues/137037
bool firstStart = true;

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/welcome',
    navigatorKey: navi.naviKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/welcome',
        builder: (BuildContext context, GoRouterState state) {
          return LoadingPage(onWait: () async {
            if (!firstStart) return;
            firstStart = false;

            if (await server.loadStatus() is Success) {
              gotoRoute(context, '/login');
            } else {
              gotoRoute(context, '/connect');
            }
          });
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => LoginLandingPage(),
      ),
      GoRoute(
        path: '/connect',
        builder: (BuildContext context, GoRouterState state) => ConnectionPage(),
      ),
      GoRoute(
        path: '/user',
        builder: (BuildContext context, GoRouterState state) {
          return MemberLandingPage(session: navi.userSession!);
        },
        redirect: (BuildContext context, GoRouterState state) {
          if (navi.userSession == null || navi.userSession?.user == null) {
            return '/login';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/event',
        builder: (BuildContext context, GoRouterState state) {
          if (navi.eventSession == null) {
            return LoginLandingPage();
          } else {
            return EnrollPage(session: navi.eventSession!);
          }
        },
      ),
      GoRoute(
        path: '/login_event',
        builder: (BuildContext context, GoRouterState state) {
          final String? key = state.uri.queryParameters['key'];
          final String? pwd = state.uri.queryParameters['pwd'];

          return LoadingPage(onWait: () async {
            await Future.delayed(const Duration(seconds: 2));
            if (key == null || key.isEmpty || pwd == null || pwd.isEmpty) {
              gotoRoute(context, '/login');
              return;
            }

            Result<EventSession> result_session = await server.loginEvent(key, pwd);

            if (result_session is! Success) {
              gotoRoute(context, '/login');
              return;
            }
            navi.addEventSession(result_session.unwrap());
            navi.loginEvent(context, result_session.unwrap());
          });
        },
      ),
    ],
  );
}

void gotoRoute(BuildContext context, String path) {
  GoRouter.of(context).go(path);
}

void gotoPage(BuildContext context,  {required Widget Function(BuildContext) builder, VoidCallback? postCall}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: builder,
    ),
  );

  postCall?.call();
}

class LoadingPage extends StatelessWidget {
  final Future<void> Function() onWait;

  LoadingPage({super.key, required this.onWait}) {
    wait();
  }

  void wait() async {
    // Simulate lag
    //await Future.delayed(const Duration(seconds: 5));
    onWait();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget();
  }
}
