import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygame_p2e/core/errors/app_failure.dart';
import 'package:mygame_p2e/core/errors/retry_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile.g.dart';

/// Which picture a player wears (D-140).
enum PlayerAvatarMode { initial, character }

/// Theme index matches [HtmlJourneyTokens.avatarThemes]. Stored as data, not paint.
final class PlayerAvatarSelection {
  const PlayerAvatarSelection.initial({this.theme = 0})
    : mode = PlayerAvatarMode.initial,
      character = 0;

  const PlayerAvatarSelection.character(this.character, {this.theme = 0})
    : mode = PlayerAvatarMode.character;

  final PlayerAvatarMode mode;
  final int theme;
  final int character;

  Map<String, Object?> toJson() => {
    'mode': mode.name,
    'theme': theme,
    'character': character,
  };

  factory PlayerAvatarSelection.fromJson(Map<String, Object?> json) {
    final mode = json['mode'] == 'character'
        ? PlayerAvatarMode.character
        : PlayerAvatarMode.initial;
    final theme = json['theme'];
    final character = json['character'];
    return mode == PlayerAvatarMode.character
        ? PlayerAvatarSelection.character(
            character is int ? character : 0,
            theme: theme is int ? theme : 0,
          )
        : PlayerAvatarSelection.initial(theme: theme is int ? theme : 0);
  }
}

/// The signed-in player's public identity.
final class Profile {
  const Profile({
    required this.displayName,
    this.username = '',
    this.avatar = const PlayerAvatarSelection.initial(),
  });

  final String displayName;
  final String username;
  final PlayerAvatarSelection avatar;

  Profile copyWith({
    String? displayName,
    String? username,
    PlayerAvatarSelection? avatar,
  }) => Profile(
    displayName: displayName ?? this.displayName,
    username: username ?? this.username,
    avatar: avatar ?? this.avatar,
  );
}

abstract interface class ProfileRepository {
  Future<Result<Profile>> current();
}

/// OD-2: no endpoint is invented until the backend contract exists.
final class RemoteProfileRepository implements ProfileRepository {
  const RemoteProfileRepository();
  @override
  Future<Result<Profile>> current() async =>
      const Failure(BusinessFailure('not_configured'));
}

@riverpod
ProfileRepository profileRepository(Ref ref) =>
    throw StateError('Profile composition missing');

/// Avatar chosen during account setup, before a profile endpoint exists (D-140).
class ProfileSelection extends Notifier<Profile?> {
  @override
  Profile? build() => null;
  void apply(Profile value) => state = value;
  void clear() => state = null;
}

final profileSelectionProvider = NotifierProvider<ProfileSelection, Profile?>(
  ProfileSelection.new,
);

@Riverpod(retry: retryTransient)
Future<Profile> profile(Ref ref) async {
  final selected = ref.watch(profileSelectionProvider);
  if (selected != null) return selected;
  return switch (await ref.watch(profileRepositoryProvider).current()) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}
