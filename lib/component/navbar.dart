import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final void Function(int)? onTapped;
  const Navbar({
    super.key,
    required this.onTapped,
    required this.currentIndex
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: CustomNavBarClipper(currentIndex: currentIndex),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
            ),
          ),
        ),
        BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: onTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: secondaryColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: currentIndex == 0 ? secondaryColor : Colors.transparent,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: currentIndex == 0 ? secondaryColor : Colors.transparent,
                  ),
                  child: ImageIcon(
                    AssetImage('assets/icons/home.png'),
                    size: 55,
                    color: whiteColor,
                  ),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: currentIndex == 1 ? secondaryColor : Colors.transparent,
                ),
                child: ImageIcon(
                  AssetImage('assets/icons/hand.png'),
                  size: 55,
                  color: whiteColor,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 55,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.transparent,
                ),
                child: ImageIcon(
                  AssetImage('assets/icons/mid.png'),
                  size: 55,
                  color: currentIndex == 2 ? primaryColor : whiteColor,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: currentIndex == 3 ? secondaryColor : Colors.transparent,
                ),
                child: ImageIcon(
                  AssetImage('assets/icons/msg.png'),
                  size: 55,
                  color: whiteColor,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: currentIndex == 4 ? secondaryColor : Colors.transparent,
                ),
                child: ImageIcon(
                  AssetImage('assets/icons/setting.png'),
                  size: 55,
                  color: whiteColor,
                ),
              ),
              label: '',
            ),
          ],
        ),
      ],
    );
  }
}

class CustomNavBarClipper extends CustomClipper<Path> {
  final int currentIndex;

  CustomNavBarClipper({required this.currentIndex});

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);

    double curveCenter = size.width * ((2 * currentIndex + 1) / 10);
    double curveWidth = size.width * 0.27;
    double curveHeight = 160;

    path.lineTo(curveCenter - curveWidth / 1.9, 0);

    path.quadraticBezierTo(
      curveCenter,
      curveHeight,
      curveCenter + curveWidth / 2,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}