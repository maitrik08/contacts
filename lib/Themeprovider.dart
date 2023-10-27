import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String selected = 'light';
  bool _isLightTheme = true; // Default to light theme

  bool get isLightTheme => _isLightTheme;
  late ThemeData _currentTheme = _isLightTheme?lighttheme():darktheme();
  ThemeData get currentTheme => _currentTheme;
  void setTheme(bool isLight) async{
    print(isLight);
    _isLightTheme = isLight;
    _currentTheme = isLight ? lighttheme() : darktheme();
    saveThemePreference(isLight);
    notifyListeners();
    ;
  }
  void Changetheme(String Value){
    selected = Value;
    notifyListeners();
  }
  void saveThemePreference(bool is_light_theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_light_theme', is_light_theme);
  }

  Future<bool> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isLightTheme = prefs.getBool('is_light_theme');
    _isLightTheme = isLightTheme ?? true;
    _currentTheme = _isLightTheme ? lighttheme() : darktheme();
    return _isLightTheme;
    notifyListeners();
  }
  void saveThemevalue(bool selected) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('selected', selected);
  }
  Future<bool?> loadThemevalue() async {
    final prefs = await SharedPreferences.getInstance();
    final Selection = prefs.getBool('selected');
    return Selection;
  }
}
ThemeData lighttheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade100,
      iconTheme: IconThemeData(color: Colors.black, size: 25),
      primarySwatch: Colors.purple,
      focusColor: Colors.black,
      textTheme: TextTheme(
          bodyMedium: TextStyle(
              color: Colors.black, fontSize: 15,fontWeight: FontWeight.w500
          )
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.black), //<-- SEE HERE
      )
  );
}

ThemeData darktheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white, size: 25),
      primarySwatch: Colors.purple,
      focusColor: Colors.white,
      textTheme: TextTheme(
          bodyMedium: TextStyle(
              color: Colors.white, fontSize: 15,fontWeight: FontWeight.w500
          )
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.white), //<-- SEE HERE
      )
  );
}