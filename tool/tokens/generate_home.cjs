// Generates Home and collection tokens from the read-only Home snapshot evidence.
// Engineering-only values (paging motion, non-product fallback roles) come from
// design/engineering/home.json.
const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '../..');
const evidenceDir = path.join(root, 'docs/snapshots/2026-10-24_home/evidence');
const read = (file) =>
  JSON.parse(fs.readFileSync(path.join(evidenceDir, file), 'utf8'));
const engineering = JSON.parse(
  fs.readFileSync(path.join(root, 'design/engineering/home.json'), 'utf8'),
);
const generatedDir = path.join(
  root,
  'packages/design_system/lib/src/tokens/generated',
);

// Provisional mappings from palette primitives to existing skin roles (E-103).
const paletteRoles = { 'Sky/500': 'Action/Accent' };
// Fallback roles for unbound source paints when a non-product skin is active.
const rawRoles = { '#000000': 'Alpha/Black', '#ffffff': 'Alpha/White' };
const weights = { Regular: 400, Medium: 500, SemiBold: 600, Bold: 700 };
const curves = { easeOut: 'Curves.easeOut', easeInOut: 'Curves.easeInOut' };
const sourcePaint =
  '(?:(?:Dark Mode|Light Mode|Base Color|Color Palette|Supportin Colors):.+|RAW=.+)';

function paint(text) {
  if (text === 'IMAGE') return { image: true };
  let match = /^RAW=(#[0-9a-f]{6})(?:@(\d+))?$/.exec(text);
  if (match) {
    return { raw: true, hex: match[1], opacity: match[2] ? +match[2] / 100 : 1 };
  }
  match = /^(.+?):(.+)=(#[0-9a-f]{6})(?:@(\d+))?$/.exec(text);
  if (!match) throw new Error(`Unparsed paint: ${text}`);
  return {
    collection: match[1],
    name: match[2],
    hex: match[3],
    opacity: match[4] ? +match[4] / 100 : 1,
  };
}

function effect(text) {
  const match =
    /^([A-Z_]+)\(r?([\d.]+)(?:,s([\d.-]+))?(?:,x([\d.-]+),y([\d.-]+))?\)(?:(#[0-9a-f]{6})@(\d+))?$/.exec(
      text,
    );
  if (!match) throw new Error(`Unparsed effect: ${text}`);
  return {
    type: match[1],
    radius: +match[2],
    spread: match[3] === undefined ? 0 : +match[3],
    x: match[4] === undefined ? 0 : +match[4],
    y: match[5] === undefined ? 0 : +match[5],
    hex: match[6],
    opacity: match[7] === undefined ? 1 : +match[7] / 100,
  };
}

function parse(line) {
  const parts = line.split(' | ');
  const [nodePath, type, size] = parts;
  const [w, h] = size.split('x').map(Number);
  const node = { path: nodePath, type, w, h, fills: [], effects: [] };
  for (const part of parts.slice(3)) {
    let match;
    if (
      (match =
        /^([HV]) gap([\d.]+) pad([\d.]+),([\d.]+),([\d.]+),([\d.]+)$/.exec(part))
    ) {
      node.layout = {
        gap: +match[2],
        top: +match[3],
        right: +match[4],
        bottom: +match[5],
        left: +match[6],
      };
    } else if ((match = /^r([\d.]+)$/.exec(part))) {
      node.radius = +match[1];
    } else if (part.startsWith('fill:')) {
      node.fills = part.slice(5).split('|').map(paint);
    } else if (part.startsWith('stroke:')) {
      const stroke = /^stroke:(.+?=#[0-9a-f]{6}(?:@\d+)?) w([\d.,]+) ?(\w*)$/.exec(part);
      if (!stroke) throw new Error(`Unparsed stroke: ${part}`);
      node.stroke = {
        paint: paint(stroke[1]),
        weights: stroke[2].split(',').map(Number),
        align: stroke[3],
      };
    } else if (part.startsWith('fx:')) {
      node.effects = (part.slice(3).match(/[A-Z_]+\([^)]*\)(?:#[0-9a-f]{6}@\d+)?/g) || [])
        .map(effect);
    } else if (part.startsWith('ts:')) {
      node.textStyle = part.slice(3);
    }
  }
  return node;
}

function tree(lines) {
  return lines.map(parse);
}

function all(nodes, nodePath) {
  const found = nodes.filter((node) => node.path === nodePath);
  if (!found.length) throw new Error(`Missing evidence path: ${nodePath}`);
  return found;
}

function at(nodes, nodePath, index = 0) {
  const found = all(nodes, nodePath)[index];
  if (!found) throw new Error(`Missing evidence path: ${nodePath} #${index}`);
  return found;
}

function firstText(nodes, prefix) {
  const found = nodes.find(
    (node) => node.type === 'TEXT' && node.path.startsWith(`${prefix}/`),
  );
  if (!found) throw new Error(`Missing text under: ${prefix}`);
  return found;
}

function role(fill, where) {
  if (!fill || fill.raw || fill.image) {
    throw new Error(`Expected a role-bound paint at ${where}`);
  }
  if (fill.collection === 'Color Palette') {
    const mapped = paletteRoles[fill.name];
    if (!mapped) throw new Error(`Palette ${fill.name} at ${where} has no approved role`);
    return mapped;
  }
  return fill.name;
}

function fillRole(node) {
  return role(node.fills[0], node.path);
}

function same(values, label) {
  if (new Set(values.map((value) => JSON.stringify(value))).size !== 1) {
    throw new Error(`Inconsistent source values for ${label}: ${JSON.stringify(values)}`);
  }
  return values[0];
}

function color(hex, opacity = 1) {
  const alpha = Math.round(opacity * 255).toString(16).padStart(2, '0');
  return `Color(0x${alpha}${hex.slice(1)})`.replace(
    /0x([0-9a-f]{8})/,
    (_, digits) => `0x${digits.toUpperCase()}`,
  );
}

function themed(name, dark, light) {
  return `  static const ${name} = ThemedRole(dark: '${dark}', light: '${light}');\n`;
}

/// A role when the paint is bound (or an approved palette mapping), otherwise
/// the raw source color with a fallback role for non-product skins.
function paintSpec(fill, where, fallback) {
  if (!fill || fill.image) throw new Error(`Expected a paint at ${where}`);
  const raw = () => {
    const fallbackRole = fallback ?? rawRoles[fill.hex];
    return `RawPaint(${color(fill.hex, fill.opacity)}${fallbackRole ? `, fallbackRole: '${fallbackRole}'` : ''})`;
  };
  if (fill.raw) return raw();
  if (fill.collection === 'Color Palette' && !paletteRoles[fill.name]) return raw();
  if (fill.opacity !== 1) throw new Error(`Role paint with opacity at ${where}`);
  return `RolePaint('${role(fill, where)}')`;
}

function themedPaint(name, dark, light) {
  return `  static const ${name} = ThemedPaint(\n    dark: ${dark},\n    light: ${light},\n  );\n`;
}

function strokeSpec(node) {
  if (!node.stroke) return 'null';
  if (node.stroke.align !== 'INSIDE') {
    throw new Error(`Unsupported stroke alignment at ${node.path}`);
  }
  const width = same(node.stroke.weights, `${node.path} stroke weights`);
  return `SourceStroke(${paintSpec(node.stroke.paint, node.path)}, ${width})`;
}

function numbers(entries) {
  return entries
    .map(([key, value]) => `  static const double ${key} = ${value};\n`)
    .join('');
}

const textStyles = read('text_styles.json');

function textStyle(spec) {
  const height =
    spec.lineHeight.unit === 'PIXELS'
      ? `        height: ${spec.lineHeight.value} / ${spec.fontSize},\n`
      : '';
  const spacing =
    spec.letterSpacing.unit === 'PERCENT'
      ? +((spec.fontSize * spec.letterSpacing.value) / 100).toFixed(4)
      : spec.letterSpacing.value;
  const weight = weights[spec.style];
  if (!weight) throw new Error(`Unknown font style ${spec.style}`);
  return `BundledTypography.resolve(
      const TextStyle(
        fontFamily: '${spec.family}',
        package: 'p2e_design_system',
        fontSize: ${spec.fontSize},
        fontWeight: FontWeight.w${weight},
${height}        letterSpacing: ${spacing},
      ),
    )`;
}

function namedStyle(name) {
  const spec = textStyles.styles[name];
  if (!spec) throw new Error(`Missing text style evidence: ${name}`);
  return textStyle(spec);
}

const themes = ['dark', 'light'];

// ---------------------------------------------------------------- collections
const collections = read('collections.json');
const details = read('details.json');
const header = (theme) => tree(collections.out[`${theme}.sectionHeader`].lines);
const pages = (theme) => tree(collections.out[`${theme}.pagination`].lines);

const action = at(header('dark'), 'Section Header/Text Button');
const actionPadding = same(
  [action.layout.top, action.layout.right, action.layout.bottom, action.layout.left],
  'section action padding',
);
const titleFrame = at(header('dark'), 'Section Header/Section Title');
const sectionTitle = (theme) => firstText(header(theme), 'Section Header/Section Title');
const sectionAction = (theme) =>
  firstText(header(theme), 'Section Header/Text Button/Text Label');
for (const theme of themes) {
  same(
    [
      role(paint(details.chevronArtwork[theme]), `${theme} chevron`),
      fillRole(sectionAction(theme)),
    ],
    `${theme} section action and chevron`,
  );
}
const regularGap = same(
  [
    collections.sliders['dark.compactSlider'].gap,
    collections.sliders['dark.pagedSlider'].gap,
    collections.sliders['light.compactSlider'].gap,
    collections.sliders['light.pagedSlider'].gap,
  ],
  'regular shelf gap',
);
const sectionFrame = collections.sectionFrame;
if (details.layout.sliders.clips !== false || details.layout.section.clips !== true) {
  throw new Error('Shelves are full-bleed only when sliders do not clip and sections do');
}
const curve = curves[engineering.shelfPageCurve];
if (!curve) throw new Error(`Unknown curve ${engineering.shelfPageCurve}`);
function unitFactor(name) {
  const value = engineering[name];
  if (typeof value !== 'number' || value < 0 || value > 1) {
    throw new Error(`${name} must be between 0 and 1`);
  }
  return value;
}
const parallaxBackground = unitFactor('heroParallaxBackground');
const parallaxForeground = unitFactor('heroParallaxForeground');
const parallaxMax = engineering.heroParallaxMax;
if (typeof parallaxMax !== 'number' || parallaxMax <= 0) {
  throw new Error('heroParallaxMax must be positive');
}

const collectionOutput = `// GENERATED from docs/snapshots/2026-10-24_home/evidence and
// design/engineering/home.json by tool/tokens/generate_home.cjs. Do not edit.
// Provisional collection primitives (D-101, D-102, R-100, R-101).
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

abstract final class CollectionTokens {
${numbers([
  ['sectionHeaderHeight', at(header('dark'), 'Section Header').h],
  ['sectionGap', at(header('dark'), 'Section Header').layout.gap],
  ['sectionTitleInsetStart', titleFrame.layout.left],
  ['sectionTitleInsetEnd', titleFrame.layout.right],
  ['sectionActionPadding', actionPadding],
  ['sectionActionGap', action.layout.gap],
  ['sectionActionRadius', action.radius],
  ['sectionActionIcon', at(header('dark'), 'Section Header/Text Button/Icon (Optional)').w],
  ['sectionPadding', same(sectionFrame.pad, 'section padding')],
  ['sectionContentGap', sectionFrame.gap],
  ['pageIndicatorActive', at(pages('dark'), 'Pagination/Active Indicator').w],
  ['pageIndicatorInactive', at(pages('dark'), 'Pagination/Indicator').w],
  ['pageIndicatorGap', at(pages('dark'), 'Pagination').layout.gap],
  ['shelfGapRegular', regularGap],
  ['shelfGapRelaxed', collections.sliders['dark.questSlider'].gap],
  // D-121: two-tone section titles on Game Details. Home keeps one title.
  ['sectionTitlePartGap', 6],
  ['sectionMarkGap', 2],
])}}

abstract final class CollectionRoles {
${themed('sectionTitle', fillRole(sectionTitle('dark')), fillRole(sectionTitle('light')))}  // D-121: lead is Base in Dark and Muted in Light (Game Details 18526:12062 / 18533:9377).
  static const sectionLead = ThemedRole(dark: 'On Surface/Base', light: 'On Surface/Muted');
${themed('sectionAction', fillRole(sectionAction('dark')), fillRole(sectionAction('light')))}${themed('pageActive', fillRole(at(pages('dark'), 'Pagination/Active Indicator')), fillRole(at(pages('light'), 'Pagination/Active Indicator')))}${themed('pageInactive', fillRole(at(pages('dark'), 'Pagination/Indicator')), fillRole(at(pages('light'), 'Pagination/Indicator')))}}

abstract final class CollectionText {
  static final sectionTitle = ${namedStyle(same([sectionTitle('dark').textStyle, sectionTitle('light').textStyle], 'section title style'))};
  static final sectionAction = ${namedStyle(same([sectionAction('dark').textStyle, sectionAction('light').textStyle], 'section action style'))};
}

/// Engineering motion. Figma defines none (R-101, D-102, D-104).
abstract final class CollectionMotion {
  static const pageDuration = Duration(milliseconds: ${engineering.shelfPageDurationMs});
  static const pageCurve = ${curve};
  static const double heroParallaxBackground = ${parallaxBackground};
  static const double heroParallaxForeground = ${parallaxForeground};
  static const double heroParallaxMax = ${parallaxMax};
}
`;

// ----------------------------------------------------------------------- home
const cards = read('game_cards.json');
const quest = read('quest_card.json');
const featured = (theme) => tree(collections.out[`${theme}.featuredRow`].lines);
const hero = (theme) => tree(collections.out[`${theme}.heroBanner`].lines);
const expand = (theme) => tree(cards.masters[`expand.${theme}`].lines);
const compact = (theme) => tree(cards.masters[`compact.detailed.${theme}`].lines);
const simple = (theme) => tree(cards.masters[`compact.simple.${theme}`].lines);
const questCard = (theme) => tree(quest[theme].lines);

const featuredRow = at(featured('dark'), 'Game Card');
const cardRow = at(expand('dark'), 'Game/Game Card');
const questRow = at(questCard('dark'), 'Header');
const overlay = (theme) => at(compact(theme), 'Game Icon/Reward');
const overlayPlate = (theme) => at(compact(theme), 'Game Icon/Reward/Icon');
const overlayAmount = (theme) => firstText(compact(theme), 'Game Icon/Reward/Points Amount');
const overlayUnit = (theme) => at(compact(theme), 'Game Icon/Reward/Points Amount/pts');
const step = (theme) => at(questCard(theme), 'Body/Quest Card/Header/Progress Bar/Mission/Reward');
const stepActive = (theme) =>
  at(questCard(theme), 'Body/Quest Card/Header/Progress Bar/Mission/Reward/Points Amount/+250');
const stepUpcoming = (theme) =>
  at(questCard(theme), 'Body/Quest Card/Header/Progress Bar/Mission/Reward/Points Amount/1,000');
const stepUnit = (theme) =>
  at(questCard(theme), 'Body/Quest Card/Header/Progress Bar/Mission/Reward/Points Amount/pts');
const total = (theme) => at(questCard(theme), 'Body/Quest Card/Details/Reward');
const totalPlate = (theme) => at(questCard(theme), 'Body/Quest Card/Details/Reward/Icon');
const totalAmount = (theme) =>
  at(questCard(theme), 'Body/Quest Card/Details/Reward/Points Amount/Total/750');
const totalSlash = (theme) =>
  at(questCard(theme), 'Body/Quest Card/Details/Reward/Points Amount/Divider//');
const totalSecondary = (theme) =>
  at(questCard(theme), 'Body/Quest Card/Details/Reward/Points Amount/Total/1,750');
const totalUnit = (theme) =>
  at(questCard(theme), 'Body/Quest Card/Details/Reward/Points Amount/Total/pts');
const creator = (nodes, prefix) => firstText(nodes, prefix);
const artwork = (list, prefix) => {
  const entry = list.find((item) => item.startsWith(prefix));
  if (!entry) throw new Error(`Missing artwork evidence ${prefix}`);
  return paint(entry.split(' ').slice(2).join(' '));
};

const overlayPadding = overlay('dark').layout;
const stepPadding = step('dark').layout;
const totalPadding = total('dark').layout;
const blur = same(
  [overlay('dark'), overlay('light')].map((node) => {
    const found = node.effects.find((item) => item.type === 'BACKGROUND_BLUR');
    if (!found) throw new Error('Missing reward blur');
    return found.radius;
  }),
  'reward blur',
);
const shadows = (theme) =>
  at(featured(theme), 'Game Card')
    .effects.filter((item) => item.type === 'DROP_SHADOW')
    .map(
      (item) =>
        `BoxShadow(color: ${color(item.hex, item.opacity)}, blurRadius: ${item.radius}, spreadRadius: ${item.spread}, offset: Offset(${item.x}, ${item.y}))`,
    );

// Reward overlay placement: absolute, pinned to the top end of the artwork.
const rewardPlacements = [details.positions.compactReward, details.positions.expandReward];
for (const placement of rewardPlacements) {
  if (
    placement.positioning !== 'ABSOLUTE' ||
    placement.constraints.horizontal !== 'MAX' ||
    placement.constraints.vertical !== 'MIN'
  ) {
    throw new Error(`Reward ${placement.id} is not pinned to the top end`);
  }
}
const rewardInsetTop = same(rewardPlacements.map((item) => item.y), 'reward top inset');
const rewardInsetEnd = same(
  rewardPlacements.map((item) => item.parentW - item.x - item.w),
  'reward end inset',
);

// Compact and expand cards.
const compactImage = at(compact('dark'), 'Game Icon');
const compactInfo = at(compact('dark'), 'Game Information');
const simpleInfo = at(simple('dark'), 'Game Information');
const rateBadge = at(compact('dark'), 'Game Information/Rate Badge');
const rate = at(compact('dark'), 'Game Information/Rate Badge/Rate');
const simpleRate = at(simple('dark'), 'Game Information/Rate');
const detailedRate = (theme) => at(compact(theme), 'Game Information/Rate Badge/Rate');
const detailedRateValue = (theme) =>
  at(compact(theme), 'Game Information/Rate Badge/Rate/Text Label/4.4');
const simpleRateFrame = (theme) => at(simple(theme), 'Game Information/Rate');
const simpleRateValue = (theme) => at(simple(theme), 'Game Information/Rate/Text Label/4.4');
for (const theme of themes) {
  same(
    [
      fillRole(firstText(compact(theme), 'Game Information/Game Name')),
      fillRole(firstText(simple(theme), 'Game Information/Game Name')),
      fillRole(firstText(expand(theme), 'Game/Game Card/Game Information/Game Name')),
    ],
    `${theme} card name role`,
  );
  same(
    [
      fillRole(firstText(compact(theme), 'Game Information/Game Creator')),
      fillRole(creator(expand(theme), 'Game/Game Card/Game Information/Game Creator')),
    ],
    `${theme} card creator role`,
  );
}
same(
  [
    firstText(compact('dark'), 'Game Information/Game Name').textStyle,
    firstText(expand('dark'), 'Game/Game Card/Game Information/Game Name').textStyle,
  ],
  'card name style',
);
const expandFrame = (theme) => at(expand(theme), 'Game');

// Quest card, progress and countdown.
function notStartedMarkers(theme) {
  const pattern = new RegExp(
    `^FRAM Mission Status (${sourcePaint.replace('.+', '.+?')}) icon:Icon=(.+?) (${sourcePaint})$`,
  );
  return details.notStarted[theme].lines
    .filter((line) => line.startsWith('FRAM Mission Status '))
    .map((line) => {
      const match = pattern.exec(line);
      if (!match) throw new Error(`Unparsed marker: ${line}`);
      return { plate: paint(match[1]), icon: match[2], artwork: paint(match[3]) };
    });
}
function notStartedBars(theme) {
  return details.notStarted[theme].lines
    .filter((line) => line.startsWith('RECT Bar '))
    .map((line) => {
      const match = /^RECT Bar (\S+) w([\d.]+) sizing:(\w+)$/.exec(line);
      if (!match) throw new Error(`Unparsed bar: ${line}`);
      return { fill: paint(match[1]), w: +match[2], sizing: match[3] };
    });
}
function notStartedTexts(theme, prefix) {
  return details.notStarted[theme].lines
    .filter((line) => line.startsWith(prefix))
    .map((line) => paint(new RegExp(`(${sourcePaint})$`).exec(line.slice(prefix.length))[1]));
}
const markerPath = 'Body/Quest Card/Header/Progress Bar/Mission/Mission Status';
const startedMarkers = (theme) => all(questCard(theme), markerPath);
const startedBars = (theme) => all(questCard(theme), 'Body/Quest Card/Header/Progress Bar/Bar');
const startedArtwork = (theme) =>
  quest.artwork[theme].filter((item) => / 20 /.test(item)).map((item) => paint(item.split(' ').slice(2).join(' ')));
const fills = (nodes) => nodes.map((node) => node.fills[0]);

if (
  JSON.stringify(details.layout.questTrackBars.slice(0, -1).map(() => 'FIXED')) !==
    JSON.stringify(details.layout.questTrackBars.slice(0, -1)) ||
  details.layout.questTrackBars.at(-1) !== 'FILL'
) {
  throw new Error('Progress segments must be fixed except the last, which fills');
}
const segmentWidth = same(
  notStartedBars('dark')
    .filter((bar) => bar.sizing === 'FIXED')
    .map((bar) => bar.w),
  'fixed progress segment',
);

const progress = {};
for (const theme of themes) {
  const markers = startedMarkers(theme);
  const art = startedArtwork(theme);
  const idle = notStartedMarkers(theme);
  const bars = startedBars(theme);
  progress[theme] = {
    segmentDone: same(fills(bars.slice(0, 2)), `${theme} done segments`),
    segmentPending: same(
      [bars[2].fills[0], ...notStartedBars(theme).map((bar) => bar.fill)],
      `${theme} pending segments`,
    ),
    markerDone: same(fills(markers.slice(0, 3)), `${theme} done markers`),
    markerIdle: same(
      [markers[3].fills[0], ...idle.map((marker) => marker.plate)],
      `${theme} idle markers`,
    ),
    doneIcon: same(art.slice(0, 3), `${theme} done marker artwork`),
    startIdleIcon: idle[0].artwork,
    waitingIcon: same(
      [art[3], ...idle.slice(1).map((marker) => marker.artwork)],
      `${theme} waiting marker artwork`,
    ),
  };
  same(
    [fillRole(step(theme)), ...notStartedTexts(theme, 'FRAM Reward ').slice(0, 3).map((fill) => role(fill, 'step'))],
    `${theme} step surfaces`,
  );
  same(
    [fillRole(stepUpcoming(theme)), ...['TEXT 250 ', 'TEXT 500 ', 'TEXT 1,000 '].map((prefix) => role(notStartedTexts(theme, prefix)[0], prefix))],
    `${theme} upcoming step amounts`,
  );
  same(
    [fillRole(at(questCard(theme), 'Body/Quest Card/Details/Quest Step/Text Label/Completed')), role(notStartedTexts(theme, 'TEXT Not Started Yet! ')[0], 'status')],
    `${theme} quest status`,
  );
}
const markerFrame = at(questCard('dark'), markerPath);
const questFrame = (theme) => at(questCard(theme), '.');
const panel = (theme) => at(questCard(theme), 'Body/Quest Card');
const trackFrame = at(questCard('dark'), 'Body/Quest Card/Header');
const dividerWeights = trackFrame.stroke.weights;
if (dividerWeights[0] || dividerWeights[1] || dividerWeights[3] || trackFrame.stroke.align !== 'CENTER') {
  throw new Error('Quest divider must be a centered bottom stroke');
}
// The track row is 12 high; markers overflow it equally and step rewards sit
// above the markers. Flow layout keeps the source total at text scale 1.0.
const trackHeight = at(questCard('dark'), 'Body/Quest Card/Header/Progress Bar').h;
const markerOverflow = (markerFrame.h - trackHeight) / 2;
const rewardGap = at(questCard('dark'), 'Body/Quest Card/Header/Progress Bar/Mission', 1).layout.gap;
const trackInsetTop = trackFrame.layout.top - step('dark').h - rewardGap - markerOverflow;
const trackInsetBottom = trackFrame.layout.bottom - markerOverflow;
if (trackInsetTop < 0 || trackInsetBottom < 0) throw new Error('Quest track overflows');
if (
  trackInsetTop + step('dark').h + rewardGap + markerFrame.h + trackInsetBottom !==
  trackFrame.h
) {
  throw new Error('Quest track flow layout does not reproduce the source height');
}
const detailsFrame = at(questCard('dark'), 'Body/Quest Card/Details');
const footer = at(questCard('dark'), 'Footer');
const counter = at(questCard('dark'), 'Footer/Counter');
const unit = at(questCard('dark'), 'Footer/Counter/Day');
const digitRow = at(questCard('dark'), 'Footer/Counter/Day/Counter');
const digit = at(questCard('dark'), 'Footer/Counter/Day/Counter/Number');
const label = at(questCard('dark'), 'Footer/Counter/Day/Label');
const divider = at(questCard('dark'), 'Footer/Counter/Divider');
const countdownValue = (theme) =>
  same(
    [
      fillRole(at(questCard(theme), 'Footer/Counter/Day/Counter/Number/0')),
      fillRole(at(questCard(theme), 'Footer/Counter/Day/Label/Day')),
      fillRole(at(questCard(theme), 'Footer/Counter/Divider/Vector')),
    ],
    `${theme} countdown value`,
  );

// Hero banner.
// E-102: Figma AUTO line height is the font's own; Flutter's differs for
// Outfit. Every source caption box measures the same height, so use it.
if (textStyles.unstyledCaption.lineHeight.unit !== 'AUTO') {
  throw new Error('The unstyled caption gained a line height; drop this rule');
}
const captionHeight = same(
  [
    firstText(featured('dark'), 'Game Card/CTA Section/Label'),
    firstText(featured('light'), 'Game Card/CTA Section/Label'),
    firstText(expand('dark'), 'Game/Game Card/CTA Section/Label'),
    firstText(expand('light'), 'Game/Game Card/CTA Section/Label'),
    firstText(questCard('dark'), 'Header/CTA Section/Label'),
    firstText(questCard('light'), 'Header/CTA Section/Label'),
  ].map((node) => node.h),
  'caption box height',
);
const captionStyle = {
  ...textStyles.unstyledCaption,
  lineHeight: { unit: 'PIXELS', value: captionHeight },
};

const positions = details.positions;
const vignette = (theme) => {
  const effects = at(hero(theme), 'Hero Section Banner/Parallax/Parallax  Background').effects;
  const fallbacks = engineering.heroVignetteFallbackRoles[theme];
  if (effects.length !== fallbacks.length) {
    throw new Error(`Hero ${theme} vignette needs one fallback role per shadow`);
  }
  return effects.map((item, index) => {
    if (item.type !== 'INNER_SHADOW' || item.spread || item.x || item.y) {
      throw new Error(`Unsupported hero effect ${JSON.stringify(item)}`);
    }
    return `SourceInnerShadow(${paintSpec({ raw: true, hex: item.hex, opacity: item.opacity }, 'hero vignette', fallbacks[index])}, ${item.radius})`;
  });
};
if (positions.heroRow.h !== featuredRow.h) throw new Error('Hero row height mismatch');
if (positions.heroBanner.y + positions.heroBanner.h !== positions.heroRow.y) {
  throw new Error('Hero banner must end where the featured row starts');
}

const homeOutput = `// GENERATED from docs/snapshots/2026-10-24_home/evidence and
// design/engineering/home.json by tool/tokens/generate_home.cjs. Do not edit.
// Product Home measurements, roles and text styles (D-101, D-102).
import 'package:flutter/painting.dart';

import '../../theme/bundled_typography.dart';
import '../../theme/themed_role.dart';

abstract final class HomeTokens {
${numbers([
  ['infoIconRadius', same([at(featured('dark'), 'Game Card/Game Icon').radius, at(expand('dark'), 'Game/Game Card/Game Icon').radius, at(questCard('dark'), 'Header/Game Icon').radius], 'info icon radius')],
  ['infoFeaturedIcon', at(featured('dark'), 'Game Card/Game Icon').w],
  ['infoFeaturedPadding', same([featuredRow.layout.top, featuredRow.layout.right, featuredRow.layout.bottom, featuredRow.layout.left], 'featured padding')],
  ['infoFeaturedGap', featuredRow.layout.gap],
  ['infoFeaturedRadius', featuredRow.radius],
  ['infoFeaturedHeight', featuredRow.h],
  ['infoFeaturedTextGap', at(featured('dark'), 'Game Card/Game Information').layout.gap],
  ['infoCardIcon', at(expand('dark'), 'Game/Game Card/Game Icon').w],
  ['infoCardPadding', same([cardRow.layout.top, cardRow.layout.right, cardRow.layout.bottom, cardRow.layout.left], 'card padding')],
  ['infoCardGap', cardRow.layout.gap],
  ['infoCardTextGap', at(expand('dark'), 'Game/Game Card/Game Information').layout.gap],
  ['infoQuestIcon', at(questCard('dark'), 'Header/Game Icon').w],
  ['infoQuestPadding', same([questRow.layout.top, questRow.layout.right, questRow.layout.bottom, questRow.layout.left], 'quest padding')],
  ['infoQuestGap', questRow.layout.gap],
  ['infoQuestHeight', questRow.h],
  ['infoQuestTextGap', at(questCard('dark'), 'Header/Game Information').layout.gap],
  ['infoMarkGap', at(featured('dark'), 'Game Card/Game Information/Game Creator').layout.gap],
  ['infoActionGap', at(featured('dark'), 'Game Card/CTA Section').layout.gap],
  ['rewardRadius', same([overlay('dark').radius, step('dark').radius, total('dark').radius], 'reward radius')],
  ['rewardOverlayPadTop', overlayPadding.top],
  ['rewardOverlayPadEnd', overlayPadding.right],
  ['rewardOverlayPadBottom', overlayPadding.bottom],
  ['rewardOverlayPadStart', overlayPadding.left],
  ['rewardOverlayGap', overlay('dark').layout.gap],
  ['rewardOverlayInsetTop', rewardInsetTop],
  ['rewardOverlayInsetEnd', rewardInsetEnd],
  ['rewardPlate', overlayPlate('dark').w],
  ['rewardArtwork', at(compact('dark'), 'Game Icon/Reward/Icon/Fill').w],
  ['rewardAmountUnitGap', at(compact('dark'), 'Game Icon/Reward/Points Amount').layout.gap],
  ['rewardBlur', blur],
  ['rewardStepPadVertical', same([stepPadding.top, stepPadding.bottom], 'step vertical padding')],
  ['rewardStepPadHorizontal', same([stepPadding.left, stepPadding.right], 'step horizontal padding')],
  ['rewardTotalPadTop', totalPadding.top],
  ['rewardTotalPadEnd', totalPadding.right],
  ['rewardTotalPadBottom', totalPadding.bottom],
  ['rewardTotalPadStart', totalPadding.left],
  ['rewardTotalGap', total('dark').layout.gap],
  ['rewardTotalSegmentGap', at(questCard('dark'), 'Body/Quest Card/Details/Reward/Points Amount').layout.gap],
  ['rewardTotalUnitGap', at(questCard('dark'), 'Body/Quest Card/Details/Reward/Points Amount/Total', 1).layout.gap],
  ['compactWidth', same([at(compact('dark'), '.').w, at(simple('dark'), '.').w, compactImage.w, compactImage.h], 'compact width')],
  ['compactImageRadius', compactImage.radius],
  ['compactGap', same([at(compact('dark'), '.').layout.gap, at(simple('dark'), '.').layout.gap], 'compact gap')],
  ['compactInfoPadHorizontal', same([compactInfo.layout.left, compactInfo.layout.right, simpleInfo.layout.left, simpleInfo.layout.right], 'compact info padding')],
  ['compactDetailedInfoGap', compactInfo.layout.gap],
  ['compactSimpleInfoGap', simpleInfo.layout.gap],
  ['ratingInsetVertical', same([rateBadge.layout.top, rateBadge.layout.bottom], 'rating inset')],
  ['ratingPadHorizontal', same([rate.layout.left, rate.layout.right, simpleRate.layout.left, simpleRate.layout.right], 'rating horizontal padding')],
  ['ratingPadVertical', same([rate.layout.top, rate.layout.bottom, simpleRate.layout.top, simpleRate.layout.bottom], 'rating vertical padding')],
  ['ratingGap', same([rate.layout.gap, simpleRate.layout.gap], 'rating gap')],
  ['ratingRadius', same([rate.radius, simpleRate.radius], 'rating radius')],
  ['ratingStar', at(compact('dark'), 'Game Information/Rate Badge/Rate/Icon').w],
  ['expandRadius', expandFrame('dark').radius],
  ['expandBannerHeight', at(expand('dark'), 'Game/Game Icon').h],
  ['questRadius', questFrame('dark').radius],
  ['questBodyPadHorizontal', same([at(questCard('dark'), 'Body').layout.left, at(questCard('dark'), 'Body').layout.right], 'quest body padding')],
  ['questPanelRadius', panel('dark').radius],
  ['questTrackInsetTop', trackInsetTop],
  ['questTrackPadHorizontal', same([trackFrame.layout.left, trackFrame.layout.right], 'quest track padding')],
  ['questTrackInsetBottom', trackInsetBottom],
  ['questDividerWidth', dividerWeights[2]],
  ['questDetailsPadding', same([detailsFrame.layout.top, detailsFrame.layout.right, detailsFrame.layout.bottom, detailsFrame.layout.left], 'quest details padding')],
  ['questDetailsGap', detailsFrame.layout.gap],
  ['questStatusGap', at(questCard('dark'), 'Body/Quest Card/Details/Quest Step').layout.gap],
  ['questFooterPadding', same([footer.layout.top, footer.layout.right, footer.layout.bottom, footer.layout.left], 'quest footer padding')],
  ['progressTrackHeight', at(questCard('dark'), 'Body/Quest Card/Header/Progress Bar').h],
  ['progressMarker', same([markerFrame.w, markerFrame.h], 'progress marker')],
  ['progressMarkerRadius', markerFrame.radius],
  ['progressMarkerPadding', same([markerFrame.layout.top, markerFrame.layout.right, markerFrame.layout.bottom, markerFrame.layout.left], 'progress marker padding')],
  ['progressIcon', at(questCard('dark'), markerPath + '/Fill').w],
  ['progressSegment', segmentWidth],
  ['progressRewardGap', rewardGap],
  ['countdownGap', counter.layout.gap],
  ['countdownUnitGap', unit.layout.gap],
  ['countdownDigitGap', digitRow.layout.gap],
  ['countdownDigitWidth', details.layout.questDigit.w],
  ['countdownDigitPadding', same([digit.layout.top, digit.layout.right, digit.layout.bottom, digit.layout.left], 'countdown digit padding')],
  ['countdownDigitRadius', digit.radius],
  ['countdownLabelPadHorizontal', same([label.layout.left, label.layout.right], 'countdown label padding')],
  ['countdownDot', same([at(questCard('dark'), 'Footer/Counter/Divider/Vector').w, at(questCard('dark'), 'Footer/Counter/Divider/Vector').h], 'countdown dot')],
  ['countdownDotGap', divider.layout.gap],
  ['countdownDotInsetBottom', divider.layout.bottom],
  ['heroReferenceWidth', positions.heroBanner.w],
  ['heroReferenceHeight', positions.heroBanner.h],
  ['heroRowTop', positions.heroRow.y],
  ['heroRowInset', (positions.heroBanner.w - featuredRow.w) / 2],
  ['heroCardHeight', positions.heroCard.h],
])}}

abstract final class HomeRoles {
${themed('featuredSurface', fillRole(featuredRow), fillRole(at(featured('light'), 'Game Card')))}${themed('featuredName', fillRole(firstText(featured('dark'), 'Game Card/Game Information/Game Name')), fillRole(firstText(featured('light'), 'Game Card/Game Information/Game Name')))}${themed('cardName', fillRole(firstText(expand('dark'), 'Game/Game Card/Game Information/Game Name')), fillRole(firstText(expand('light'), 'Game/Game Card/Game Information/Game Name')))}${themed('questName', fillRole(firstText(questCard('dark'), 'Header/Game Information/Game Name')), fillRole(firstText(questCard('light'), 'Header/Game Information/Game Name')))}${themed('infoSupporting', same([fillRole(creator(featured('dark'), 'Game Card/Game Information/Game Creator')), fillRole(creator(expand('dark'), 'Game/Game Card/Game Information/Game Creator')), fillRole(creator(questCard('dark'), 'Header/Game Information/Game Creator')), fillRole(firstText(featured('dark'), 'Game Card/CTA Section/Label'))], 'dark supporting role'), same([fillRole(creator(featured('light'), 'Game Card/Game Information/Game Creator')), fillRole(creator(expand('light'), 'Game/Game Card/Game Information/Game Creator')), fillRole(creator(questCard('light'), 'Header/Game Information/Game Creator')), fillRole(firstText(featured('light'), 'Game Card/CTA Section/Label'))], 'light supporting role'))}${themed('overlayPlate', fillRole(overlayPlate('dark')), fillRole(overlayPlate('light')))}${themed('overlayArtwork', role(paint(cards.crownArtwork['compact.detailed.dark']), 'overlay crown dark'), role(paint(cards.crownArtwork['compact.detailed.light']), 'overlay crown light'))}${themed('overlayAmount', fillRole(overlayAmount('dark')), fillRole(overlayAmount('light')))}${themed('overlayUnit', fillRole(overlayUnit('dark')), fillRole(overlayUnit('light')))}${themed('stepSurface', fillRole(step('dark')), fillRole(step('light')))}${themed('stepAmountActive', fillRole(stepActive('dark')), fillRole(stepActive('light')))}${themed('stepAmountUpcoming', fillRole(stepUpcoming('dark')), fillRole(stepUpcoming('light')))}${themed('stepUnit', fillRole(stepUnit('dark')), fillRole(stepUnit('light')))}${themed('totalSurface', fillRole(total('dark')), fillRole(total('light')))}${themed('totalPlate', fillRole(totalPlate('dark')), fillRole(totalPlate('light')))}${themed('totalArtwork', role(artwork(quest.artwork.dark, 'Icon=Crown 14'), 'total crown dark'), role(artwork(quest.artwork.light, 'Icon=Crown 14'), 'total crown light'))}${themed('totalAmount', fillRole(totalAmount('dark')), fillRole(totalAmount('light')))}${themed('totalSlash', fillRole(totalSlash('dark')), fillRole(totalSlash('light')))}${themed('totalSecondary', fillRole(totalSecondary('dark')), fillRole(totalSecondary('light')))}${themed('totalUnit', fillRole(totalUnit('dark')), fillRole(totalUnit('light')))}${themed('ratingDetailedSurface', fillRole(detailedRate('dark')), fillRole(detailedRate('light')))}${themed('ratingDetailedValue', fillRole(detailedRateValue('dark')), fillRole(detailedRateValue('light')))}${themed('ratingSimpleSurface', fillRole(simpleRateFrame('dark')), fillRole(simpleRateFrame('light')))}${themed('ratingSimpleValue', fillRole(simpleRateValue('dark')), fillRole(simpleRateValue('light')))}${themed('expandSurface', fillRole(expandFrame('dark')), fillRole(expandFrame('light')))}${themed('questSurface', fillRole(questFrame('dark')), fillRole(questFrame('light')))}${themed('questPanel', fillRole(panel('dark')), fillRole(panel('light')))}${themed('questDivider', role(at(questCard('dark'), 'Body/Quest Card/Header').stroke.paint, 'dark divider'), role(at(questCard('light'), 'Body/Quest Card/Header').stroke.paint, 'light divider'))}${themed('questStatus', fillRole(at(questCard('dark'), 'Body/Quest Card/Details/Quest Step/Text Label/Completed')), fillRole(at(questCard('light'), 'Body/Quest Card/Details/Quest Step/Text Label/Completed')))}${themed('countdownSurface', fillRole(at(questCard('dark'), 'Footer/Counter/Day/Counter/Number')), fillRole(at(questCard('light'), 'Footer/Counter/Day/Counter/Number')))}${themed('countdownValue', countdownValue('dark'), countdownValue('light'))}}

/// Source paints that may be unbound in one theme (E-103, E-105, E-109).
abstract final class HomePaints {
${themedPaint('overlayScrim', paintSpec(overlay('dark').fills[0], 'dark scrim'), paintSpec(overlay('light').fills[0], 'light scrim'))}${themedPaint('ratingStarDetailed', paintSpec(paint(details.starArtwork['detailed.dark']), 'detailed star dark'), paintSpec(paint(details.starArtwork['detailed.light']), 'detailed star light'))}${themedPaint('ratingStarSimple', paintSpec(paint(details.starArtwork['simple.dark']), 'simple star dark'), paintSpec(paint(details.starArtwork['simple.light']), 'simple star light'))}${['segmentDone', 'segmentPending', 'markerDone', 'markerIdle', 'doneIcon', 'startIdleIcon', 'waitingIcon'].map((key) => themedPaint(`progress${key[0].toUpperCase()}${key.slice(1)}`, paintSpec(progress.dark[key], `dark ${key}`), paintSpec(progress.light[key], `light ${key}`))).join('')}}

abstract final class HomeStrokes {
  static const expand = ThemedStroke(
    dark: ${strokeSpec(expandFrame('dark'))},
    light: ${strokeSpec(expandFrame('light'))},
  );
  static const quest = ThemedStroke(
    dark: ${strokeSpec(questFrame('dark'))},
    light: ${strokeSpec(questFrame('light'))},
  );
}

abstract final class HomeShadows {
  static const featured = ThemedShadows(
    dark: [${shadows('dark').join(', ')}],
    light: [${shadows('light').join(', ')}],
  );

  /// E-108: raw vignette colors; fallback roles are engineering choices.
  static const heroVignette = ThemedInnerShadows(
    dark: [${vignette('dark').join(', ')}],
    light: [${vignette('light').join(', ')}],
  );
}

abstract final class HomeText {
  static final featuredName = ${namedStyle(firstText(featured('dark'), 'Game Card/Game Information/Game Name').textStyle)};
  static final cardName = ${namedStyle(firstText(expand('dark'), 'Game/Game Card/Game Information/Game Name').textStyle)};
  static final questName = ${namedStyle(firstText(questCard('dark'), 'Header/Game Information/Game Name').textStyle)};
  static final creator = ${namedStyle(creator(featured('dark'), 'Game Card/Game Information/Game Creator').textStyle)};
  static final rewardAmount = ${namedStyle(overlayAmount('dark').textStyle)};
  static final rewardUnit = ${namedStyle(overlayUnit('dark').textStyle)};
  static final rewardTotal = ${namedStyle(totalAmount('dark').textStyle)};
  static final rating = ${namedStyle(same([detailedRateValue('dark').textStyle, simpleRateValue('dark').textStyle], 'rating style'))};
  static final questStatus = ${namedStyle(at(questCard('dark'), 'Body/Quest Card/Details/Quest Step/Text Label/Completed').textStyle)};
  static final questStatusNumber = ${namedStyle(at(questCard('dark'), 'Body/Quest Card/Details/Quest Step/Step/2').textStyle)};
  static final countdownDigit = ${namedStyle(at(questCard('dark'), 'Footer/Counter/Day/Counter/Number/0').textStyle)};
  static final countdownLabel = ${namedStyle(at(questCard('dark'), 'Footer/Counter/Day/Label/Day').textStyle)};

  /// E-102: the source caption has no text style; measured from node ${textStyles.unstyledCaption.id}.
  /// Its AUTO line height is the measured caption box height.
  static final caption = ${textStyle(captionStyle)};
}
`;

const outputs = {
  'collection_tokens.g.dart': collectionOutput,
  'home_tokens.g.dart': homeOutput,
};
if (process.argv.includes('--check')) {
  for (const [file, content] of Object.entries(outputs)) {
    const target = path.join(generatedDir, file);
    if (
      !fs.existsSync(target) ||
      fs.readFileSync(target, 'utf8').replace(/\r\n/g, '\n') !== content
    ) {
      console.error(`Home tokens are stale: ${file}`);
      process.exit(1);
    }
  }
} else {
  for (const [file, content] of Object.entries(outputs)) {
    fs.writeFileSync(path.join(generatedDir, file), content);
  }
}
