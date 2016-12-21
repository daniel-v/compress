# compress

[![version 1.0.0](https://img.shields.io/badge/pub-v1.0.0-brightgreen.svg)](https://pub.dartlang.org/packages/angel_compress)
[![build status](https://travis-ci.org/angel-dart/compress.svg)](https://travis-ci.org/angel-dart/compress)

Angel hook to compress responses in a variety of formats.

```dart
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_compress/angel_compress.dart';

main() {
  var app = new Angel();
  
  // GZIP is the easiest to add
  app.responseFinalizers.add(gzip());
  
  // Support any other codec
  app.responseFinalizers.add(compress('lzw', LZW));
}
```
