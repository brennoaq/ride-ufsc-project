import 'package:boilerplate_flutter/config/theme.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({required int currentIndex, required Function(int) onTap})
      : _currentIndex = currentIndex,
        _onTap = onTap,
        super();

  final int _currentIndex;
  final Function(int) _onTap;

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      currentIndex: widget._currentIndex,
      onTap: widget._onTap,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_box,
            color: RideColors.white[64],
          ),
          activeIcon: Icon(
            Icons.add_box,
            color: Theme.of(context).primaryColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_box,
            color: RideColors.white[64],
          ),
          activeIcon: Icon(
            Icons.add_box,
            color: Theme.of(context).primaryColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_box,
            color: RideColors.white[64],
          ),
          activeIcon: Icon(
            Icons.add_box,
            color: Theme.of(context).primaryColor,
          ),
          label: '',
        ),
      ],
    );
  }
}
