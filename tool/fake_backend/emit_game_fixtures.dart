import 'dart:convert';
import 'dart:io';

/// Writes game-details v1 fixtures. Run from the repository root.
void main() {
  const home = [
    'clash_of_clans',
    'sifu',
    'nine_kings',
    'dome_keeper',
    'oh_snack',
    'monopoly',
    'chess',
    'backgammon',
    'hokm',
    'poker',
  ];
  const like = ['railway_canyon', 'letter_burp', 'grabby_crab'];
  const supercell = ['clash_royal', 'brawl_stars', 'hay_day', 'boom_beach'];
  const extra = ['eight_ball_pool', 'minimal_sample'];
  final ids = [...home, ...like, ...supercell, ...extra];
  final art = {
    'clash_of_clans': 'featured_icon.png',
    'sifu': 'sifu.jpg',
    'nine_kings': 'nine_kings.jpg',
    'dome_keeper': 'dome_keeper.jpg',
    'oh_snack': 'oh_snack.jpg',
    'monopoly': 'monopoly_icon.png',
    'chess': 'chess.jpg',
    'backgammon': 'backgammon.jpg',
    'hokm': 'hokm.jpg',
    'poker': 'poker.jpg',
    'railway_canyon': 'backgammon.jpg',
    'letter_burp': 'oh_snack.jpg',
    'grabby_crab': 'hokm.jpg',
    'clash_royal': 'quest_icon_1.png',
    'brawl_stars': 'hero_object.png',
    'hay_day': 'quest_icon_2.png',
    'boom_beach': 'monopoly_banner.jpg',
    'eight_ball_pool': 'poker.jpg',
    'minimal_sample': 'chess.jpg',
  };
  final names = {
    'clash_of_clans': 'Clash of Clans',
    'sifu': 'Sifu',
    'nine_kings': '9 Kings',
    'dome_keeper': 'Dome Keeper',
    'oh_snack': 'Oh, Snack!',
    'monopoly': 'MONOPOLY',
    'chess': 'Chess',
    'backgammon': 'Backgammon',
    'hokm': 'Hokm',
    'poker': 'Poker',
    'railway_canyon': 'Railway Canyon',
    'letter_burp': 'Letter Burp',
    'grabby_crab': 'Grabby Crab',
    'clash_royal': 'Clash Royal',
    'brawl_stars': 'Brawl Stars',
    'hay_day': 'Hay Day',
    'boom_beach': 'Boom Beach',
    'eight_ball_pool': '8 Ball Pool',
    'minimal_sample': 'Sample',
  };
  final studios = {
    'clash_of_clans': ('supercell', 'Supercell', true),
    'clash_royal': ('supercell', 'Supercell', true),
    'brawl_stars': ('supercell', 'Supercell', true),
    'hay_day': ('supercell', 'Supercell', true),
    'boom_beach': ('supercell', 'Supercell', true),
    'sifu': ('kepler', 'Kepler Interactive', true),
    'nine_kings': ('playdigious', 'Playdigious', true),
    'dome_keeper': ('raw_fury', 'Raw Fury', true),
    'oh_snack': ('tepes', 'Tepes Ovidiu', true),
    'monopoly': ('marmalade', 'Marmalade Game', true),
    'chess': ('chess_com', 'Chess.com', true),
    'backgammon': ('board', 'Board Games', false),
    'hokm': ('local', 'Local Studio', false),
    'poker': ('card', 'Card Club', false),
    'railway_canyon': ('darkmater', 'Darkmater', true),
    'letter_burp': ('olivia', 'Olivia Can', true),
    'grabby_crab': ('tepes', 'Tepes Ovidiu', true),
    'eight_ball_pool': ('miniclip', 'Miniclip.com', true),
    'minimal_sample': ('sample_studio', 'Sample Studio', false),
  };
  Map<String, Object?> image(String file) => {
    'url': '{{media}}/home/$file',
    'width': 512,
    'height': 512,
    'alt': file,
  };
  Map<String, Object?> gameShot(String file, int width, int height) => {
    'url': '{{media}}/games/$file',
    'width': width,
    'height': height,
    'alt': file,
  };
  Map<String, Object?> related(String id) {
    final studio = studios[id]!;
    return {
      'id': id,
      'name': names[id],
      'studio': {'name': studio.$2, 'registeredMark': studio.$3},
      'cover': image(art[id]!),
      'rating': id == 'hay_day' ? 2.7 : 4.4,
      'rewardPoints': id == 'clash_royal' ? 550 : 50,
      'access': 'freeToPlay',
    };
  }

  final directory = Directory('tool/fake_backend/fixtures/games');
  directory.createSync(recursive: true);
  for (final id in ids) {
    final studio = studios[id]!;
    final siblings = [
      for (final other in ids)
        if (other != id && studios[other]!.$1 == studio.$1) other,
    ];
    final similar = [
      for (final other in ids)
        if (other != id && other != 'minimal_sample') other,
    ].take(3);
    final minimal = id == 'minimal_sample';
    final clash = id == 'clash_of_clans';
    final body = <String, Object?>{
      'schemaVersion': 1,
      'id': id,
      'kind': 'downloadable',
      'name': names[id],
      'icon': image(art[id]!),
      'access': clash ? 'inAppPurchases' : 'freeToPlay',
      'studio': {
        'id': studio.$1,
        'name': studio.$2,
        'registeredMark': studio.$3,
        'tagline': minimal ? 'Sample' : 'Mobile Game Development Company',
        'logo': image(art[id]!),
        'cover': image(clash ? 'hero_background.jpg' : art[id]!),
      },
      'rating': {
        'average': minimal ? 0 : (id == 'hay_day' ? 2.7 : 4.5),
        'count': minimal ? 0 : (clash ? 40000000 : 1200),
        'distribution': minimal
            ? {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0}
            : clash
            ? {
                '5': 25400000,
                '4': 10600000,
                '3': 2100000,
                '2': 1100000,
                '1': 800000,
              }
            : {'5': 700, '4': 300, '3': 100, '2': 60, '1': 40},
      },
      'downloads': minimal ? 0 : (clash ? 500000 : 20000),
      'installSizeBytes': clash ? 600833088 : 52428800,
      'install': {'method': 'external', 'url': 'https://example.com/games/$id'},
      'media': minimal
          ? []
          : clash
          ? [
              {
                'type': 'video',
                'thumbnail': gameShot('media_1.jpg', 1600, 739),
                'url': 'https://example.com/videos/clash-of-clans',
                'alt': 'Clash of Clans trailer',
              },
              {
                'type': 'image',
                'image': gameShot('media_2.jpg', 1024, 589),
                'alt': 'Screenshot 1',
              },
              {
                'type': 'image',
                'image': gameShot('media_3.jpg', 1024, 589),
                'alt': 'Screenshot 2',
              },
              {
                'type': 'image',
                'image': gameShot('media_4.jpg', 1024, 576),
                'alt': 'Screenshot 3',
              },
            ]
          : [
              {'type': 'image', 'image': image(art[id]!), 'alt': names[id]},
            ],
      'about': {
        'description': clash
            ? 'ALL FOR THE CROWN!\n\nBuild a formidable team, attack enemy towers, and use strategy skills to defend your own in multiplayer PvP card battles. Unlock 100+ unique cards, build an unrivalled battle deck, and defend your King’s Tower using strategy, wit, and Skeletons.\n\nClash Royale is free to download and play, however, some game items can also be purchased for real money (including random items). If you don\'t want to purchase game items for real money, please disable in-app purchases in your device\'s settings.'
            : '${names[id]} is ready to play.',
        'updatedOn': '2026-11-14',
        'platforms': minimal ? <String>[] : ['android'],
      },
      'events': clash
          ? [
              {
                'id': 'electro_wizard',
                'title': 'Hero Electro Wizard & Evolved Electro Giant',
                'description': 'Hero Electro Wizard is even more stunning than before! Activate his Hero ability to stun nearby enemies with twin beams of shocking proportions.',
                'banner': gameShot('event_electro.jpg', 1600, 900),
                'rewardPoints': 1500,
                'action': {
                  'type': 'external',
                  'url': 'https://example.com/events/electro-wizard',
                },
              },
              {
                'id': 'tenth_anniversary',
                'title': 'Clash of Clans 10th Anniversary',
                'description': 'Ten years of glory, one epic offer.',
                'banner': image('hero_object.png'),
                'rewardPoints': 2750,
                'action': {
                  'type': 'external',
                  'url': 'https://example.com/events/anniversary',
                },
              },
            ]
          : [],
      'reviews': {
        'aiSummary': clash
            ? {
                'text': 'Users are saying the strategy gameplay is endlessly fun, praising fast-paced base building and instant troop deployment.',
              }
            : null,
        'total': minimal ? 0 : (clash ? 3 : 1),
        'items': minimal
            ? []
            : clash
            ? [
                _review(
                  'ardeshir',
                  'Ardeshir Rashidi',
                  4.5,
                  '2026-10-05',
                  'Been playing for years. good game. Too much pay to win though imo.',
                ),
                _review(
                  'mohammad',
                  'Mohammad Hoserin Mozaffarian',
                  3.5,
                  '2026-09-16',
                  'I don\'t understand what happening in this game.',
                ),
                _review(
                  'mehdi',
                  'Mehdi Mohajeri Amiri',
                  4,
                  '2026-09-07',
                  'I enjoy this game a lot. At the moment I especially enjoy merge tactics.',
                ),
              ]
            : [
                _review(
                  'player',
                  'Player',
                  4,
                  '2026-10-01',
                  'A solid sample review.',
                ),
              ],
      },
      'similar': minimal ? [] : [for (final other in similar) related(other)],
      'moreByStudio': minimal
          ? []
          : [for (final other in siblings.take(4)) related(other)],
    };
    File('${directory.path}/$id.json').writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(body)}\n',
    );
  }
  stdout.writeln('wrote ${ids.length} game fixtures');
}

Map<String, Object?> _review(
  String id,
  String name,
  double rating,
  String date,
  String text,
) => {
  'id': id,
  'author': {'id': id, 'name': name, 'avatar': null},
  'rating': rating,
  'createdOn': date,
  'text': text,
};
