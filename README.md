
# file_md5

[![Pub Version (including pre-releases)](https://img.shields.io/pub/v/file_md5?include_prereleases)](https://pub.flutter-io.cn/packages/file_md5) [![GitHub license](https://img.shields.io/github/license/jiejie-dev/flutter_file_md5)](https://github.com/jiejie-dev/flutter_file_md5/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/jiejie-dev/flutter_file_md5?style=social)](https://github.com/jiejie-dev/flutter_file_md5/stargazers)

A Flutter package with streamed MD5 calculation.

## Usage

```dart
final file = File("test/file.txt");
file.writeAsString("file_md5");
final stream = file.openRead();
final res = await FileMD5.get(stream: stream, size: await file.length());
expect(res.toString(), "c9db55524c2e0a772f4658a90e1e433e");
```

