import 'package:cptclient/api/login.dart' as server;
import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/pages/ConnectionPage.dart';
import 'package:cptclient/pages/EnrollPage.dart';
import 'package:cptclient/pages/LoginLandingPage.dart';
import 'package:cptclient/pages/MemberLandingPage.dart';
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
    routes: <RouteBase>[
      GoRoute(
        path: '/welcome',
        builder: (BuildContext context, GoRouterState state) {
          return LoadingPage(onWait: () async {
            if (!firstStart) return;
            firstStart = false;

            if (await server.loadStatus()) {
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
          return MemberLandingPage(session: navi.uSession!);
        },
        redirect: (BuildContext context, GoRouterState state) {
          if (navi.uSession == null || navi.uSession?.user == null) {
            return '/login';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/event',
        builder: (BuildContext context, GoRouterState state) {
          if (navi.eSession == null) {
            return LoginLandingPage();
          } else {
            return EnrollPage(session: navi.eSession!);
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

            String? token = await server.loginEvent(key, pwd);

            if (token == null) {
              gotoRoute(context, '/login');
              return;
            }

            navi.loginEvent(context, token);
          });
        },
      ),
    ],
  );
}

void gotoRoute(BuildContext context, String path) {
  GoRouter.of(context).go(path);
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
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          value: null,
          strokeWidth: 5,
        ),
      ),
    );
  }
}

