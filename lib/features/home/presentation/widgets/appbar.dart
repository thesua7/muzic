import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  const MyAppBar(String s, {super.key,this.title});

  final String? title;


  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  Text(title!),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
