import 'package:flutter/material.dart';

class TopBar extends AppBar {

  TopBar({Key? key})
      : super(
          key: key,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: ThemeData.light().scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            Container(
                margin: const EdgeInsets.only(top: 32, left: 13),
                child: Image.asset('assets/images/large_healthspike.png',
                    width: 140, fit: BoxFit.cover)),
            const Spacer(),
          ],
        );
}