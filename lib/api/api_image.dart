import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:transparent_image/transparent_image.dart';
import '../model/JDE_model.dart';

part 'api_image.g.dart';

@riverpod
class AssetImage extends _$AssetImage {
  static JDERequestModel? _requestModel;
  static Image _image = Image.memory(Uint8List.fromList(kTransparentImage));

  // set requestModel(JDERequestModel? requestModel) =>
  //    _requestModel = requestModel;

  Future<Image> build() async {
    return _image;
  }

  Future<void> loadImage(JDERequestModel requestModel) async {
    _requestModel = requestModel;

    final uri = Uri.parse(
        'http://192.168.12.128:8305/jderest/orchestrator/GetImageFile');

    http.Response? response;
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/octet-stream'
          },
          body: _requestModel!.toJson('asset'));
    } on FormatException catch (e) {
      print(e);
    }
    if (response!.statusCode == 200 || response.statusCode == 400) {
      _image = Image.memory(response.bodyBytes);
      ref.invalidateSelf();
    } else {
      ref.invalidateSelf();
      throw Exception('Failed to load data!');
    }
  }
}
