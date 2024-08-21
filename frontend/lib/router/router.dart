import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../exports.dart";

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

class RouteLocations {
  const RouteLocations._();

  static String get homeScreen => "/";
  static String get settingsScreen => "/settingsScreen";
  static String get gameScreen => "/gameScreen";

  static String get guidebookScreen => "/guidebookScreen";
  static String get guideScreen => "/guideScreen";
  static String get partyHistoryScreen => "/partyHistory";
}

final router = GoRouter(
  initialLocation: RouteLocations.homeScreen,
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
            child: BaseScreen(
          child: child,
        ));
      },
      routes: shellRoutes,
    ),
    GoRoute(
      path: RouteLocations.guidebookScreen,
      parentNavigatorKey: rootNavigatorKey,
      builder: GuideChoseView.builder
    ),
    GoRoute(
      path: RouteLocations.guideScreen,
      parentNavigatorKey: rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return GuideView(index: state.extra as int);
      },
    ),
    GoRoute(
      path: RouteLocations.partyHistoryScreen,
      parentNavigatorKey: rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return const PartyHistoryMainView();
      },
    ),
  ],
);

final shellRoutes = [
  GoRoute(
    path: RouteLocations.homeScreen,
    parentNavigatorKey: shellNavigatorKey,
    builder: MyMenuView.builder
  ),
  GoRoute(
    path: RouteLocations.settingsScreen,
    parentNavigatorKey: shellNavigatorKey,
    builder: (BuildContext context, GoRouterState state) {
      return GameSettingsView(state.extra as GameModel);
    },
  ),
  GoRoute(
    path: RouteLocations.gameScreen,
    parentNavigatorKey: shellNavigatorKey,
    builder: (BuildContext context, GoRouterState state) {
      return GameView(state.extra as GameModel);
    },
  ),
];
