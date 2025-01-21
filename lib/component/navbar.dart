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
            clipper: CustomNavBarClipper(currentIndex),
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
              icon: ImageIcon(
                AssetImage('assets/icons/home.png'),
                size: 40,
                color: currentIndex == 0 ? secondaryColor : whiteColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/hand.png'),
                size: 40,
                color: currentIndex == 1 ? secondaryColor : whiteColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/mid.png'),
                size: 40,
                color: currentIndex == 2 ? secondaryColor : primaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/msg.png'),
                size: 40,
                color: currentIndex == 3 ? secondaryColor : whiteColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/setting.png'),
                size: 40,
                color: currentIndex == 4 ? secondaryColor : whiteColor,
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

  CustomNavBarClipper(this.currentIndex);

  @override
  Path getClip(Size size) {
    final double itemWidth = size.width / 5;
    final double centerX = (currentIndex + 0.5) * itemWidth;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(centerX - itemWidth * 0.15, 0);

    path.quadraticBezierTo(
      centerX,
      -30,
      centerX + itemWidth * 0.15,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}