import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:async/async.dart';
import 'package:file_md5/cancel_token.dart';

class FileMD5 {
  static Future<Digest?> get({
    required Stream<List<int>> stream,
    required int size,
    int chunkSize = 4096 * 64,
    void Function(bool done, double progress)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final reader = ChunkedStreamReader(stream);
    // const chunkSize = 4096 * 64;
    var output = AccumulatorSink<Digest>();
    var input = md5.startChunkedConversion(output);

    var readed = 0;

    try {
      while (!(cancelToken?.isCancelled ?? false)) {
        final chunk = await reader.readChunk(chunkSize);
        if (chunk.isEmpty) {
          break;
        }

        input.add(chunk);

        readed += chunk.length;

        if (null != onProgress) {
          onProgress(false, readed.toDouble() / size);
        }
      }
    } finally {
      reader.cancel();
      input.close();
    }

    if (cancelToken?.isCancelled ?? false) {
      return null;
    }

    if (null != onProgress) {
      onProgress(true, 1.0);
    }

    return output.events.single;
  }
}
