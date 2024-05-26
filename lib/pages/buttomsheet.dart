import 'package:flutter/material.dart';
import 'package:flutter_http_post_request/model/JDE_model.dart';
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
      AsyncData(:final value) =>
        value.length == 0 ? SizedBox(height: 30) : Carousel(value),
      AsyncError() => const Text('Oops, something unexpected happened'),
      _ => const CircularProgressIndicator(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildList(context, ref);
  }
}

// ignore: must_be_immutable
class Carousel extends StatefulWidget {
  var imageValue;

  Carousel(this.imageValue);

  @override
  State<Carousel> createState() => CarouselState(this.imageValue);
}

class CarouselState extends State<Carousel> {
  late PageController _pageController;
  List<ImageValue> images = [];
  int activePage = 1;

  CarouselState(this.images);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: PageView.builder(
              itemCount: images.length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                bool active = pagePosition == activePage;
                return slider(images, pagePosition, active);
              }),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(images.length, activePage))
      ],
    );
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 10 : 20;

    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.all(margin),
        child: Column(children: [
          Expanded(
              child: Stack(
            children: <Widget>[
              images[pagePosition].image,
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    '${images[pagePosition].assetName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
          Text(
            'Price:\$${images[pagePosition].amount}',
            style: TextStyle(
              color: Color.fromARGB(255, 59, 19, 134),
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]));
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }
}
