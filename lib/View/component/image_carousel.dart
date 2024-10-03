import 'dart:async';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  const ImageCarousel({Key? key, required this.images}) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            widget.images[index],
            fit: BoxFit.fill, // Ensure the image covers the entire container
            width: double.infinity, // Optional: Set width to fill the container
            height: double.infinity, // Optional: Set height to fill the container
          ),
        );
      },
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }
}
