import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:toxicapp/components/sign_screen.dart';

class PreviewApp extends StatefulWidget {
  const PreviewApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PreviewApp();
  }
}

class _PreviewApp extends State<PreviewApp> {
  int _currentIndex = 0;
  final listSlide = [
    const Slide(text: "Welcome to Motos", start: false),
    const Slide(
      text: "Your moto service is here!",
      start: true,
    )
  ];
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 0),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.only(bottom: 20.0),
          child: CustomCarouselIndicator(
            itemCount: listSlide.length,
            currentIndex: _currentIndex,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              carouselController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: CarouselSlider(
            carouselController: carouselController,
            items: listSlide,
            options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                autoPlay: false,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                }),
          ),
        ),
      );
}

class Slide extends StatefulWidget {
  const Slide({super.key, required this.text, required this.start});
  final String text;
  const Slide.first({super.key, required this.text, required this.start});
  final bool start;

  @override
  State<StatefulWidget> createState() => _Slide();
}

class _Slide extends State<Slide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(_animation.value, 0),
                child: const Icon(Icons.motorcycle, weight: 100, size: 100),
              ),
              Text(
                widget.text,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              widget.start
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignScreen()),
                            );
                          },
                          child: const Text("Get start")),
                    )
                  : Container(),
            ]),
      ),
    );
  }
}

class CustomCarouselIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Function(int) onIndexChanged;
  final Color dotColor;
  final Color dotActiveColor;

  const CustomCarouselIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    required this.onIndexChanged,
    this.dotColor = Colors.grey,
    this.dotActiveColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                onIndexChanged(index);
              },
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
