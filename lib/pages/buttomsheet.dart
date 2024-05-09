import 'package:flutter/material.dart';
//import 'package:flutter_http_post_request/model/JDE_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:transparent_image/transparent_image.dart';
//mport 'dart:typed_data';

import '../api/api_image.dart';

// ignore: must_be_immutable
class BottomImage extends ConsumerWidget {
  const BottomImage({super.key});

  Widget _buildList(context, ref) {
    var image = ref.watch(assetImageProvider);

    return switch (image) {
      AsyncData(:final value) => value,
      AsyncError() => const Text('Oops, something unexpected happened'),
      _ => const CircularProgressIndicator(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildList(context, ref);
  }
}
