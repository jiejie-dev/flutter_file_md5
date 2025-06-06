import 'dart:html';

import 'package:crypto/crypto.dart' as crypto;
import 'package:file_md5/cancel_token.dart';

class FileMD5Web {
  static Future<crypto.Digest?> get(
    File file, {
    required int size,
    void Function(bool done, double progress)? onProgress,
    CancelToken? cancelToken,
  }) async {
    var innerSink = DigestSink();
    var outerSink = crypto.md5.startChunkedConversion(innerSink);

    final startTime = DateTime.now().millisecondsSinceEpoch;
    final reader = FileReader();
    const bufferSize = 4096 * 64;
    var start = 0;
    var readed = 0;

    try {
      while (!(cancelToken?.isCancelled ?? false) && start < size) {
        final end = start + bufferSize > size ? size : start + bufferSize;
        final blob = file.slice(start, end);
        reader.readAsArrayBuffer(blob);
        await reader.onLoad.first;
        outerSink.add(reader.result as List<int>);

        readed += end - start;
        start += bufferSize;

        if (null != onProgress) {
          onProgress(false, readed.toDouble() / size);
        }
      }

      final delta = DateTime.now().millisecondsSinceEpoch - startTime;
      print('MD5 time $delta');
    } finally {
      outerSink.close();
    }

    if (cancelToken?.isCancelled ?? false) {
      return null;
    }

    if (null != onProgress) {
      onProgress(true, 1.0);
    }

    return innerSink.value;
  }
}

/// A sink used to get a digest value out of `Hash.startChunkedConversion`.
class DigestSink extends Sink<crypto.Digest> {
  /// The value added to the sink.
  ///
  /// A value must have been added using [add] before reading the `value`.
  crypto.Digest get value => _value!;

  crypto.Digest? _value;

  /// Adds [value] to the sink.
  ///
  /// Unlike most sinks, this may only be called once.
  @override
  void add(crypto.Digest value) {
    if (_value != null) throw StateError('add may only be called once.');
    _value = value;
  }

  @override
  void close() {
    if (_value == null) throw StateError('add must be called once.');
  }
}
