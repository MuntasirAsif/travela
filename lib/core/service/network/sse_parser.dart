import 'dart:convert';

class SseFrame {
  const SseFrame({required this.event, required this.data});

  final String event;
  final String data;
}

class _SseDecoder {
  String event = '';
  final StringBuffer data = StringBuffer();
  bool hasData = false;
  String buffer = '';

  List<SseFrame> feed(String text) {
    buffer += text;
    final frames = <SseFrame>[];
    while (true) {
      final newline = buffer.indexOf('\n');
      if (newline == -1) break;
      final line = buffer.substring(0, newline);
      buffer = buffer.substring(newline + 1);
      final frame = _handleLine(line);
      if (frame != null) frames.add(frame);
    }
    return frames;
  }

  SseFrame? finish() {
    if (buffer.isNotEmpty) {
      _handleLine(buffer);
      buffer = '';
    }
    if (hasData) {
      return _dispatch();
    }
    return null;
  }

  SseFrame? _handleLine(String rawLine) {
    final line = rawLine.endsWith('\r')
        ? rawLine.substring(0, rawLine.length - 1)
        : rawLine;
    if (line.isEmpty) {
      return hasData ? _dispatch() : null;
    }
    if (line.startsWith(':')) return null;
    final colon = line.indexOf(':');
    final field = colon == -1 ? line : line.substring(0, colon);
    var value = colon == -1 ? '' : line.substring(colon + 1);
    if (value.startsWith(' ')) value = value.substring(1);
    switch (field) {
      case 'event':
        event = value;
      case 'data':
        if (hasData) data.write('\n');
        data.write(value);
        hasData = true;
    }
    return null;
  }

  SseFrame _dispatch() {
    final frame = SseFrame(
      event: event.isEmpty ? 'message' : event,
      data: data.toString(),
    );
    event = '';
    data.clear();
    hasData = false;
    return frame;
  }
}

Stream<SseFrame> parseSseStream(Stream<List<int>> byteStream) async* {
  final decoder = _SseDecoder();
  await for (final text in utf8.decoder.bind(byteStream)) {
    for (final frame in decoder.feed(text)) {
      yield frame;
    }
  }
  final last = decoder.finish();
  if (last != null) yield last;
}
