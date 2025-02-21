import 'package:flutter/material.dart';
import 'package:isyarat_kita/component/color.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final void Function(int)? onTapped;

  const Navbar({
    Key? key,
    required this.currentIndex,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(color: primaryColor),
          ),
          BottomNavigationBar(
            currentIndex: currentIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            onTap: onTapped,
            type: BottomNavigationBarType.fixed,
            iconSize: 0,
            selectedItemColor: secondaryColor,
            unselectedItemColor: whiteColor,
            items: List.generate(5, (index) {
              String iconPath = 'assets/icons/${_getIconName(index)}.png';
              return BottomNavigationBarItem(
                icon: _buildNavItem(index, iconPath),
                label: '',
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getIconName(int index) {
    switch (index) {
      case 0: return 'home';
      case 1: return 'hand';
      case 2: return 'mid';
      case 3: return 'msg';
      case 4: return 'setting';
      default: return 'home';
    }
  }

  Widget _buildNavItem(int index, String iconPath) {
    final bool isSelected = (currentIndex == index);

    //container animasinya
    return AnimatedContainer(
      duration: Duration(milliseconds: 300), //brp lama animasi
      width: 80,
      height: isSelected ? 30 : 55,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (isSelected)
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut, //jenis animasi
              top: -40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: isSelected ? 1.0 : 0.0,
                    child: Image.asset(
                      'assets/images/nav.png',
                      width: 140,
                      height: 70,
                    ),
                  ),
                  TweenAnimationBuilder<double>( //animasi masuk
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    tween: Tween(begin: 1.0, end: isSelected ? 1.0 : 0.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedScale(
                    duration: Duration(milliseconds: 300),
                    scale: isSelected ? 1.0 : 0.8,
                    child: ImageIcon(
                      AssetImage(iconPath),
                      size: 55,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            )
          else
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: isSelected ? 0.0 : 1.0,
              child: ImageIcon(
                AssetImage(iconPath),
                size: 55,
                color: whiteColor,
              ),
            ),
        ],
      ),
    );
  }
}