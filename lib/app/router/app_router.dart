import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p2e_design_system/design_system.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../features/auth/auth.dart';
import '../../features/legal/legal.dart';
import '../../features/onboarding/onboarding.dart';
import '../../features/games/games.dart';
import '../../features/home/home.dart';
import '../../shared/navigation/app_locations.dart';
import '../shell/app_shell.dart';
import '../shell/shell_placeholders.dart';
import '../startup/startup_controller.dart';
import 'auth_transition.dart';
import 'onboarding_transition.dart';
import 'game_detail_transition.dart';
part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final gate = ValueNotifier(ref.read(startupControllerProvider));
  ref.listen(startupControllerProvider, (_, next) => gate.value = next);
  final router = GoRouter(
    initialLocation: '/startup',
    refreshListenable: gate,
    redirect: (_, state) {
      if (state.uri.path.startsWith('/legal')) return null;
      if (gate.value == StartupState.entry &&
          state.uri.path.startsWith('/entry/')) {
        final flow = ref.read(authFlowProvider);
        if (flow == null) return '/entry';
        final required = authStepPath(flow.step);
        return state.uri.path == required ? null : required;
      }
      final path = state.uri.path;
      final location = switch (gate.value) {
        StartupState.initializing || StartupState.sessionCheck => '/startup',
        StartupState.onboarding => '/entry/onboarding',
        StartupState.entry => '/entry',
        // A signed-in session may visit any product location.
        StartupState.ready =>
          path == '/' ||
                  path == '/startup' ||
                  path == '/entry' ||
                  path.startsWith('/entry/')
              ? AppLocations.home
              : path,
      };
      return path == location ? null : location;
    },
    routes: [
      GoRoute(
        path: '/entry',
        pageBuilder: (_, state) => AuthTransitionPage(
          key: state.pageKey,
          child: const UiIdentityScope(
            routeName: 'auth.entry',
            child: AuthEntryScreen(),
          ),
        ),
        routes: [
          GoRoute(
            path: 'onboarding',
            pageBuilder: (_, state) => OnboardingTransitionPage(
              key: state.pageKey,
              child: const UiIdentityScope(
                routeName: 'onboarding',
                child: OnboardingScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'verify',
            pageBuilder: (_, state) => AuthTransitionPage(
              key: state.pageKey,
              child: const UiIdentityScope(
                routeName: 'auth.verify',
                child: AuthOtpScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'username',
            pageBuilder: (_, state) => AuthTransitionPage(
              key: state.pageKey,
              child: const UiIdentityScope(
                routeName: 'auth.username',
                child: UsernameScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'avatar',
            pageBuilder: (_, state) => AuthTransitionPage(
              key: state.pageKey,
              child: const UiIdentityScope(
                routeName: 'auth.avatar',
                child: AvatarScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'notifications',
            pageBuilder: (_, state) => AuthTransitionPage(
              key: state.pageKey,
              child: const UiIdentityScope(
                routeName: 'auth.notifications',
                child: NotificationsScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'all-set',
            pageBuilder: (_, state) => AuthTransitionPage(
              key: state.pageKey,
              child: const UiIdentityScope(
                routeName: 'auth.all-set',
                child: AllSetScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'welcome-back',
            pageBuilder: (_, state) => AuthTransitionPage(
              key: state.pageKey,
              child: const UiIdentityScope(
                routeName: 'auth.welcome-back',
                child: WelcomeBackScreen(),
              ),
            ),
          ),
          for (final step in [
            'otp',
            'password',
            'create-password',
            'forgot-password',
          ])
            GoRoute(
              path: step,
              pageBuilder: (_, state) => AuthTransitionPage(
                key: state.pageKey,
                child: UiIdentityScope(
                  routeName: 'auth.${step.replaceAll('-', '.')}',
                  child: switch (step) {
                    'otp' || 'forgot-password' => const AuthOtpScreen(),
                    'password' => const AuthPasswordScreen(),
                    'create-password' => const AuthCreatePasswordScreen(),
                    _ => _AuthPlaceholder(step: step),
                  },
                ),
              ),
            ),
        ],
      ),
      GoRoute(
        path: '/startup',
        pageBuilder: (_, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const UiIdentityScope(
            routeName: 'startup',
            child: _Placeholder(),
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (_, state, shell) => AuthTransitionPage(
          key: state.pageKey,
          wholePage: true,
          child: UiIdentityScope(
            routeName: 'shell',
            child: AppShell(shell: shell),
          ),
        ),
        branches: [
          for (var i = 0; i < appTabIds.length; i++)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppLocations.tabs[i],
                  builder: (_, _) => UiIdentityScope(
                    routeName: appTabIds[i],
                    child: i == 0
                        ? const HomeScreen()
                        : TabPlaceholder(tab: appTabIds[i]),
                  ),
                  routes: [
                    GoRoute(
                      path: 'game/:id',
                      pageBuilder: (_, state) => GameDetailTransitionPage(
                        key: state.pageKey,
                        child: UiIdentityScope(
                          routeName: 'game.detail',
                          child: GameDetailsScreen(
                            id: state.pathParameters['id']!,
                          ),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: 'reviews',
                          builder: (context, _) => UiIdentityScope(
                            routeName: 'game.reviews',
                            child: GameRoutePlaceholder(
                              elementId: 'game.reviews.page',
                              title: AppLocalizations.of(context).gameRatings,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: 'studio/:studioId',
                      builder: (context, _) => UiIdentityScope(
                        routeName: 'game.studio',
                        child: GameRoutePlaceholder(
                          elementId: 'game.studio.page',
                          title: AppLocalizations.of(context).gameStudioTitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
      GoRoute(
        path: '/game/:id',
        redirect: (_, state) =>
            AppLocations.gameOn(AppLocations.home, state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/legal/:doc',
        pageBuilder: (_, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: HtmlJourneyTokens.legalEnter,
          reverseTransitionDuration: HtmlJourneyTokens.legalExit,
          child: UiIdentityScope(
            routeName: 'legal.reader',
            child: LegalReaderScreen(
              doc: state.pathParameters['doc'] ?? 'terms',
            ),
          ),
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: '/quest/:id',
        builder: (_, _) => const UiIdentityScope(
          routeName: 'quest.detail',
          child: DetailPlaceholder(kind: DetailKind.quest),
        ),
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    gate.dispose();
  });
  return router;
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();
  @override
  Widget build(BuildContext context) =>
      const PageScaffold(elementId: 'startup.page', child: SizedBox.shrink());
}

class _AuthPlaceholder extends StatelessWidget {
  const _AuthPlaceholder({required this.step});
  final String step;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PageScaffold(
      elementId: 'auth.placeholder.page',
      child: Column(
        children: [
          Text(switch (step) {
            'otp' => strings.authOtpPlaceholder,
            'password' => strings.authPasswordPlaceholder,
            'create-password' => strings.authCreatePasswordPlaceholder,
            _ => strings.authForgotPlaceholder,
          }),
          AppButton(
            elementId: 'auth.placeholder.back',
            label: strings.authBack,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
