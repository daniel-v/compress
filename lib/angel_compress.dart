library angel_compress;

import 'dart:convert';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';

/// Calls [compress] with `'gzip'` and the [GZIP] codec.
RequestHandler gzip({bool recompress: false, Map<String, String> headers: const {}}) =>
    compress('gzip', GZIP, recompress: recompress, headers: headers);

/// When `Accept-Encoding` contains '*' or [contentEncoding], compresses the
/// response buffer with the given [codec]. Any [headers] will be sent as well.
///
/// The `Content-Encoding` header will be set to [contentEncoding] as well.
///
/// If `Content-Encoding` was already set and [recompress] is not true, no
/// additional compression will be added.
RequestHandler compress(
    String contentEncoding, Codec<List<int>, List<int>> codec,
    {bool recompress: false, Map<String, String> headers: const {}}) {
  return (RequestContext req, ResponseContext res) async {
    if (!res.headers.containsKey(HttpHeaders.CONTENT_ENCODING) || recompress) {
        List<String> allowedEncodings =
            req.headers.value(HttpHeaders.ACCEPT_ENCODING) != null
                || req.headers.value(HttpHeaders.ACCEPT_ENCODING).isEmpty
                ? req.headers
                    .value(HttpHeaders.ACCEPT_ENCODING)
                    .split(',')
                    .map((str) => str.trim().toLowerCase())
                    .toList()
                : ['*'];
        
        if (allowedEncodings.isEmpty)
            allowedEncodings.add('*');

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
    }

    return true;
  };
}
