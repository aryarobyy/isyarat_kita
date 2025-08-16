import 'package:flutter/material.dart';
import 'package:isyarat_kita/util/color.dart';
import 'package:isyarat_kita/pages/auth/auth.dart';

class Launch extends StatefulWidget {
  const Launch({super.key});

  @override
  State<Launch> createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  final List<Map<String, dynamic>> pageData = [
    {
      "page": "1",
      "image": "assets/images/launch1.png",
      "title": "Terjemahkan bahasa isyarat",
      "content": "dengan mudah lewat video.",
      "next": "NEXTT"
    },
    {
      "page": "2",
      "image": "assets/images/launch2.png",
      "title": "Isyarat Kita!",
      "content":
      "Bahasa isyarat lebih dekat dari yang kamu bayangkan, bergabunglah dengan komunitas",
      "next": "Lets go"
    }
  ];

  int _currentIndex = 0;

  void _onNextPage() {
    if (_currentIndex < pageData.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.push(
        context,
        PageRouteBuilder( //Kasih animasi
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) {
            return Authentication();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation =
            animation.drive(CurveTween(curve: Curves.easeInOut));
            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _buildPage(pageData[_currentIndex]),
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page) {
    return Stack(
      key: ValueKey<int>(_currentIndex),
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [secondaryColor, whiteColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.2, 0.8],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.62,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.elliptical(200, 90),
                bottomRight: Radius.elliptical(200, 90),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          page['title'],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: whiteColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          page['content'],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, 25),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          page['image'],
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: MediaQuery.of(context).size.width / 2 - 150,
          child: GestureDetector(
            onTap: _onNextPage,
            child: Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150),
                  topRight: Radius.circular(150),
                ),
              ),
              width: 300,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Center(
                  child: Text(
                    page['next'],
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
