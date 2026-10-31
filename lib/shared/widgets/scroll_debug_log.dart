import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// This run hides the hero vignette so the next scroll can show whether
/// that blur is the raster cost. Removed with the other debug logs.
const scrollDebugOmitVignette = false;

/// Temporary scroll timings for the debug session. Removed after the lag is proven.
void scrollDebugLog(
  String hypothesisId,
  String location,
  String message,
  Map<String, Object?> data,
) {
  // #region agent log
  final line = jsonEncode({
    'sessionId': '3881ce',
    'runId': kProfileMode ? 'profile' : 'pre-fix',
    'hypothesisId': hypothesisId,
    'location': location,
    'message': message,
    'data': data,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  });
  for (final host in ['10.0.2.2', '127.0.0.1']) {
    final client = HttpClient()
      ..connectionTimeout = const Duration(milliseconds: 300);
    client
        .postUrl(
          Uri.parse(
            'http://$host:7720/ingest/c0b039f1-007e-4921-8e17-0d2997b3a341',
          ),
        )
        .then((request) {
          request.headers
            ..set(HttpHeaders.contentTypeHeader, 'application/json')
            ..set('X-Debug-Session-Id', '3881ce');
          request.add(utf8.encode(line));
          return request.close();
        })
        .then((response) {
          response.drain();
          client.close();
        })
        .catchError((_) {
          client.close(force: true);
        });
  }
  // #endregion
}

var _scrollFramesInstalled = false;

/// One process-wide frame sampler. Slow frames only, so logging is not the lag.
void installScrollFrameLog() {
  // #region agent log
  if (_scrollFramesInstalled) return;
  _scrollFramesInstalled = true;
  var slow = 0;
  SchedulerBinding.instance.addTimingsCallback((timings) {
    for (final timing in timings) {
      final buildMs = timing.buildDuration.inMicroseconds / 1000;
      final rasterMs = timing.rasterDuration.inMicroseconds / 1000;
      if (buildMs < 16 && rasterMs < 16) continue;
      slow++;
      if (slow > 240) return;
      scrollDebugLog(
        buildMs >= rasterMs ? 'B' : 'A',
        'scheduler.frame',
        'slow frame',
        {
          'buildMs': buildMs.toStringAsFixed(1),
          'rasterMs': rasterMs.toStringAsFixed(1),
          'slowCount': slow,
        },
      );
    }
  });
  // #endregion
}
