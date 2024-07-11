
import 'package:flutter/material.dart';
import 'package:muzic/config/theme/dark_mode.dart';
import 'package:muzic/config/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier{

  // default light mode
  ThemeData _themeData = lightMode;

  // get theme data
  ThemeData get themeData => _themeData;

  // is dark mode
  bool get isDarkMode => _themeData == darkMode;

  // set theme

set themeData(ThemeData themeData){
  _themeData = themeData;
  notifyListeners();
}

void toggleTheme(){
  if(_themeData == lightMode){
    themeData = darkMode;
  }else{
    themeData = lightMode;
  }

}




}
