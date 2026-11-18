import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyek_mobile2/main.dart';
import 'package:proyek_mobile2/models/video.dart';
import 'package:proyek_mobile2/widgets/youtube_logo.dart';

// 1x1 transparent PNG bytes for mocking NetworkImage in widget tests
final Uint8List _transparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
]);

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FakeHttpClient();
  }
}

class _FakeHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}
  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {}
  @override
  void close({bool force = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _FakeHttpHeaders();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();
}

class _FakeHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _FakeHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _transparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  final HttpHeaders headers = _FakeHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_transparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  group('Video Model Tests', () {
    test('creates Video instance with correct thumbnail URL and defaults', () {
      const video = Video(
        id: 'dQw4w9WgXcQ',
        title: 'Test Title',
        channel: 'Test Channel',
      );

      expect(video.id, equals('dQw4w9WgXcQ'));
      expect(video.title, equals('Test Title'));
      expect(video.channel, equals('Test Channel'));
      expect(video.views, isEmpty);
      expect(video.timeAgo, isEmpty);
      expect(video.duration, isEmpty);
      expect(
        video.thumbnail,
        equals('https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg'),
      );
    });

    test('thumbnail uses thumbnailUrl when provided', () {
      const video = Video(
        id: 'dQw4w9WgXcQ',
        title: 'Test',
        channel: 'Ch',
        thumbnailUrl: 'https://example.com/thumb.jpg',
      );

      expect(video.thumbnail, equals('https://example.com/thumb.jpg'));
    });
  });

  group('Widget Tests', () {
    testWidgets('YoutubeLogo renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: YoutubeLogo(),
          ),
        ),
      );

      expect(find.text('YouTube'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('YoutubeUiApp mounts successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const YoutubeUiApp());

      expect(find.byType(YoutubeUiApp), findsOneWidget);
      expect(find.text('YouTube'), findsOneWidget);
      expect(find.text('Home'), findsWidgets);
    });
  });
}
