import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:file_md5/file_md5.dart';

void main() {
  test('get file md5', () async {
    final file = File("test/file.txt");
    file.writeAsString("file_md5");
    final stream = file.openRead();
    final res = await FileMD5.get(stream: stream, size: await file.length());
    expect(res.toString(), "c9db55524c2e0a772f4658a90e1e433e");
  });
}
