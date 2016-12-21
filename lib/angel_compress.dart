library angel_compress;

import 'dart:convert';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';

/// When `Accept-Encoding` contains '*' or [contentEncoding], compresses the
/// response buffer with the given [codec]. Any [headers] will be sent as well.
///
/// The `Content-Encoding` header will be set to [contentEncoding] as well.
RequestHandler compress(
    String contentEncoding, Codec<List<int>, List<int>> codec,
    {Map<String, String> headers: const {}}) {
  return (RequestContext req, ResponseContext res) async {
    print('Incoming: ${req.headers}');
    
    List<String> allowedEncodings =
        req.headers.value(HttpHeaders.ACCEPT_ENCODING) != null
            ? req.headers
                .value(HttpHeaders.ACCEPT_ENCODING)
                .split(',')
                .map((str) => str.trim().toLowerCase())
                .toList()
            : ['*'];

    for (String encoding in allowedEncodings) {
      if (encoding == '*' || encoding == contentEncoding) {
        res.headers.addAll(headers ?? {});
        res.headers[HttpHeaders.CONTENT_ENCODING] = contentEncoding;
        var bytes = res.buffer.takeBytes();
        var encoded = codec.encode(bytes);
        res.buffer.add(encoded);
        break;
      }
    }

    return true;
  };
}
