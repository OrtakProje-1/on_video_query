import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:on_video_query/on_video_query.dart';

void main() {
  const MethodChannel channel = MethodChannel('on_video_query');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OnVideoQuery.platformVersion, '42');
  });
}
