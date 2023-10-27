import 'package:contacts/AndroidProvider.dart';
import 'package:contacts/ContactProvider.dart';
import 'package:contacts/HomeScreen.dart';
import 'package:contacts/IOSProvider.dart';
import 'package:contacts/IOSscreen.dart';
import 'package:contacts/Themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  final themeProvider = ThemeProvider();
  final contactListProvider = ContactListProvider();
  final androidProvider = AndroidProvider();
  final iosProvider = ISOProvider();
  await contactListProvider.loadContacts();
  await themeProvider.loadThemePreference();
  await themeProvider.loadThemevalue();
  await androidProvider.loadProfileFromPrefs();
  await androidProvider.loadProfileInfoFromPrefs();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<AndroidProvider>.value(value: androidProvider),
        ChangeNotifierProvider<ContactListProvider>.value(value: contactListProvider),
        ChangeNotifierProvider<ISOProvider>.value(value: iosProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final androidProvider = Provider.of<AndroidProvider>(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          routes: {
            // '/addContact': (context) => AddContactScreen(),
            // '/editContact': (context) => EditContactScreen(index: 0),
          },
          home: androidProvider.IsAndroid?IOSscreen():HomeScreen(),
        );
      },
    );
  }
}
