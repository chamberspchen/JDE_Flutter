import 'package:flutter/material.dart';
import 'package:flutter_http_post_request/api/api_image.dart';
import 'package:flutter_http_post_request/model/JDE_model.dart';
import 'package:flutter_http_post_request/pages/buttomsheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class ShowAssetWidget extends StatelessWidget {
  JDERequestModel? _requestModel;
  ShowAssetWidget(this._requestModel);

  Widget _buildView() {
    return Consumer(builder: (
      BuildContext context,
      WidgetRef ref,
      Widget? widget,
    ) {
      ref.read(assetImageProvider.notifier).loadImage(_requestModel!);

      ;

      return Column(children: <Widget>[
        BottomImage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
