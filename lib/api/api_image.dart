import 'dart:async';
import 'dart:convert';
//import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
//import 'package:transparent_image/transparent_image.dart';
import '../model/JDE_model.dart';

part 'api_image.g.dart';

@riverpod
class AssetImage extends _$AssetImage {
  static JDERequestModel? _requestModel;
  Image? _image;
  static List<ImageValue> imageValueList = [];

  // set requestModel(JDERequestModel? requestModel) =>
  //    _requestModel = requestModel;

  Future<List<ImageValue>> build() async {
    return imageValueList;
  }

  Future<void> loadImage(JDERequestModel requestModel) async {
    _requestModel = requestModel;
    http.Response? response;
    imageValueList.clear();

    Uri uri = Uri.parse(
        'http://192.168.12.128:8305/jderest/orchestrator/GetAllAssetByEEID');

    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: _requestModel!.toJson('asset'));
      if (response.statusCode == 200 || response.statusCode == 400) {
        imageValueList = ImageResponseModel.fromJson(
          json.decode(response.body),
        ).getImageData();

        //Get Image
        for (int i = 0; i < imageValueList.length; i++) {
          uri = Uri.parse(
              'http://192.168.12.128:8305/jderest/orchestrator/GetImageFile');

          var body = jsonEncode({
            "token": requestModel.token,
            "AssetID": imageValueList[i].assetID,
            "eeID": requestModel.key!.trim(),
            "SeqID": "1",
          });

          response = await http.post(uri,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/octet-stream'
              },
              body: body);

          if (response.statusCode == 200 || response.statusCode == 400) {
            _image = Image.memory(response.bodyBytes);
          } else {
            //       _image = Image.memory(Uint8List.fromList(kTransparentImage));
          }
          imageValueList[i].image = _image;
        }
      }
    } on FormatException catch (e) {
      print(e); //
    }
    ref.invalidateSelf();
  }
}
