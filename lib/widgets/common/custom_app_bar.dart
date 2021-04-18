import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Solar Warehouse System'),
      // TODO: Insert logo
      // title: SizedBox(
      //   child: Image.asset(
      //     'assets/logos/outthere_logo_white.png',
      //     fit: BoxFit.contain,
      //     alignment: Alignment.centerLeft,
      //   ),
      //   height: kToolbarHeight,
      // ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_none,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {},
        ),
      ],
    );
  }
}
