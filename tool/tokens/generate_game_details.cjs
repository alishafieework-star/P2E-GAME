// Generates Game Details tokens from the read-only 2026-10-25 snapshot.
// Engineering-only values come from design/engineering/game_details.json.
const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '../..');
const evidence = JSON.parse(
  fs.readFileSync(
    path.join(root, 'docs/snapshots/2026-10-25_game-details/evidence/tokens.json'),
    'utf8',
  ),
);
const engineering = JSON.parse(
  fs.readFileSync(path.join(root, 'design/engineering/game_details.json'), 'utf8'),
);
const target = path.join(
  root,
  'packages/design_system/lib/src/tokens/generated/game_details_tokens.g.dart',
);

function required(value, where) {
  if (value === undefined || value === null || value === '') {
    throw new Error(`Missing ${where}`);
  }
  return value;
}

function number(value, where) {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    throw new Error(`${where} must be a finite number`);
  }
  return value;
}

function role(pair, where) {
  return {
    dark: required(pair && pair.dark, `${where}.dark`),
    light: required(pair && pair.light, `${where}.light`),
  };
}

function argb(paint, where) {
  const hex = required(paint.hex, `${where}.hex`);
  const match = /^#([0-9a-fA-F]{6})$/.exec(hex);
  if (!match) throw new Error(`${where}.hex must be #RRGGBB`);
  const opacity = paint.opacity === undefined ? 1 : number(paint.opacity, `${where}.opacity`);
  if (opacity < 0 || opacity > 1) throw new Error(`${where}.opacity out of range`);
  const alpha = Math.round(opacity * 255)
    .toString(16)
    .padStart(2, '0');
  const fallback = required(paint.fallback, `${where}.fallback`);
  return `RawPaint(Color(0x${alpha.toUpperCase()}${match[1].toUpperCase()}), fallbackRole: '${fallback}')`;
}

if (!Number.isInteger(engineering.aboutCollapsedLines) || engineering.aboutCollapsedLines < 1) {
  throw new Error('aboutCollapsedLines must be a positive integer');
}
if (
  !Number.isInteger(engineering.requestTimeoutSeconds) ||
  engineering.requestTimeoutSeconds < 1
) {
  throw new Error('requestTimeoutSeconds must be a positive integer');
}
if (
  !Number.isInteger(engineering.viewerTransitionMilliseconds) ||
  engineering.viewerTransitionMilliseconds < 1
) {
  throw new Error('viewerTransitionMilliseconds must be a positive integer');
}

const metrics = Object.entries(evidence.metrics)
  .map(([name, value]) => `  static const double ${name} = ${number(value, name)};`)
  .join('\n');
const roles = Object.entries(evidence.roles)
  .map(([name, value]) => {
    const pair = role(value, name);
    return `  static const ${name} = ThemedRole(dark: '${pair.dark}', light: '${pair.light}');`;
  })
  .join('\n');
const paints = Object.entries(evidence.paints)
  .map(([name, value]) => {
    return `  static const ${name} = ThemedPaint(\n    dark: ${argb(value.dark, `${name}.dark`)},\n    light: ${argb(value.light, `${name}.light`)},\n  );`;
  })
  .join('\n');
const strokes = Object.entries(evidence.strokes)
  .map(([name, value]) => {
    const side = (paint, where) =>
      paint == null
        ? 'null'
        : `SourceStroke(RolePaint('${required(paint.role, `${where}.role`)}'), ${number(paint.width, `${where}.width`)})`;
    return `  static const ${name} = ThemedStroke(\n    dark: ${side(value.dark, `${name}.dark`)},\n    light: ${side(value.light, `${name}.light`)},\n  );`;
  })
  .join('\n');
const text = Object.entries(evidence.text)
  .map(([name, value]) => {
    const size = number(value.size, `${name}.size`);
    const height = number(value.height, `${name}.height`);
    const weight = number(value.weight, `${name}.weight`);
    const tracking = number(value.tracking, `${name}.tracking`);
    if (![400, 500, 600, 700].includes(weight)) throw new Error(`${name}.weight`);
    return `  static final ${name} = BundledTypography.resolve(\n    const TextStyle(\n      fontFamily: 'Outfit',\n      package: 'p2e_design_system',\n      fontSize: ${size},\n      fontWeight: FontWeight.w${weight},\n      height: ${height} / ${size},\n      letterSpacing: ${tracking},\n    ),\n  );`;
  })
  .join('\n');

const output = `// GENERATED from docs/snapshots/2026-10-25_game-details/evidence/tokens.json
// and design/engineering/game_details.json by tool/tokens/generate_game_details.cjs.
// Do not edit. Game Details measurements, roles and text styles (D-121).
import 'package:flutter/painting.dart';

import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

abstract final class GameDetailsTokens {
${metrics}
}

abstract final class GameDetailsRoles {
${roles}
}

/// Unbound source paints (E-113). Product skin keeps them; other skins use the fallback.
abstract final class GameDetailsPaints {
${paints}
}

abstract final class GameDetailsStrokes {
${strokes}
}

abstract final class GameDetailsText {
${text}
}

/// Values Figma does not define (D-121).
abstract final class GameDetailsEngineering {
  static const int aboutCollapsedLines = ${engineering.aboutCollapsedLines};
  static const requestTimeout = Duration(seconds: ${engineering.requestTimeoutSeconds});
  static const viewerTransition = Duration(milliseconds: ${engineering.viewerTransitionMilliseconds});
}
`;

if (process.argv.includes('--check')) {
  const current = fs.existsSync(target)
    ? fs.readFileSync(target, 'utf8').replace(/\r\n/g, '\n')
    : '';
  if (current !== output) {
    console.error('Game Details tokens are stale.');
    process.exit(1);
  }
} else {
  fs.writeFileSync(target, output);
}
