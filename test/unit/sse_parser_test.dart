import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:travela/core/service/network/sse_parser.dart';

void main() {
  Stream<SseFrame> parse(String raw) =>
      parseSseStream(Stream.value(utf8.encode(raw)));

  test('parses meta, item and done frames separated by blank lines', () async {
    final raw =
        'event: meta\n'
        'data: {"total_count": 42}\n'
        '\n'
        'event: item\n'
        'data: {"id": 501, "title": "Sea View Studio"}\n'
        '\n'
        'event: done\n'
        'data: {}\n'
        '\n';
    final frames = await parse(raw).toList();

    expect(frames, hasLength(3));
    expect(frames[0].event, 'meta');
    expect(frames[0].data, '{"total_count": 42}');
    expect(frames[1].event, 'item');
    expect(frames[1].data, '{"id": 501, "title": "Sea View Studio"}');
    expect(frames[2].event, 'done');
    expect(frames[2].data, '{}');
  });

  test('handles \\r\\n line endings', () async {
    final raw =
        'event: meta\r\n'
        'data: {"total_count": 1}\r\n'
        '\r\n';
    final frames = await parse(raw).toList();

    expect(frames.single.event, 'meta');
    expect(frames.single.data, '{"total_count": 1}');
  });

  test('handles data split across byte chunks', () async {
    final bytes = utf8.encode('event: item\ndata: {"a": 1}\n\n');
    final stream = Stream.fromIterable([
      bytes.sublist(0, 7),
      bytes.sublist(7, 14),
      bytes.sublist(14),
    ]);
    final frames = await parseSseStream(stream).toList();

    expect(frames.single.event, 'item');
    expect(frames.single.data, '{"a": 1}');
  });

  test('ignores comments and defaults event to message', () async {
    final raw =
        ': keep-alive\n'
        'data: hello\n'
        '\n';
    final frames = await parse(raw).toList();

    expect(frames.single.event, 'message');
    expect(frames.single.data, 'hello');
  });

  test('joins multiple data lines into one payload', () async {
    final raw =
        'data: {"a":\n'
        'data: 1}\n'
        '\n';
    final frames = await parse(raw).toList();

    expect(frames.single.event, 'message');
    expect(frames.single.data, '{"a":\n1}');
  });
}
