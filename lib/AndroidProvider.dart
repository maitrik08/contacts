import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

int index = 1;
class AndroidProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  XFile? image;
  XFile? Profileimage;
  String? Date;
  String? time;
  Uint8List? uint8list;
  String? base64String;
  ImagePicker picker = ImagePicker();
  bool IsAndroid = true;
  bool profile = false;
  TextEditingController ProfileNamecontroller = TextEditingController();
  TextEditingController ProfileBiocontroller = TextEditingController();
  String? profileName = '';
  String? profileBio = '';
  void SwitchChange(bool value){
    IsAndroid = value;
    notifyListeners();
  }
  void GetIndex(int value){
    index = value;
    notifyListeners();
  }
  void ChangeProfile(bool value)async{
    profile = value;
    await saveProfileToPrefs(value);
    notifyListeners();
  }
  void profilePicture()async{
    image = await picker.pickImage(source: ImageSource.camera);
    notifyListeners();
  }
  void profilePicture2()async{
    Profileimage = await picker.pickImage(source: ImageSource.camera);
    notifyListeners();
  }
  void pickdate (DateTime picked ) async {
    selectedDate = picked;
    Date = await DateFormat('dd/MM/yyyy').format(selectedDate);
    notifyListeners();
  }
  void picktime(TimeOfDay picked) async{
    selectedTime = picked;
    final timeFormat = DateFormat('HH:mm a');
    time= timeFormat.format(DateTime(2023, 1, 1, selectedTime.hour, selectedTime.minute));
    notifyListeners();
  }
  void saveImge(){
    List<int> imageBytes = File(image!.path).readAsBytesSync();
    base64String = base64Encode(imageBytes);
    Image(base64String!);
    notifyListeners();
  }
  void saveProfileImge(){
    List<int> imageBytes = File(Profileimage!.path).readAsBytesSync();
    base64String = base64Encode(imageBytes);
    Image(base64String!);
    notifyListeners();
  }
  void Image(String base){
    uint8list = base64.decode(base);
    notifyListeners();
  }
  Future<void> loadProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    profile = prefs.getBool('profile') ?? false;
    notifyListeners();
  }

  Future<void> saveProfileToPrefs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    profile = value;
    prefs.setBool('profile', value);
    notifyListeners();
  }
  Future<void> loadProfileInfoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    profileName = prefs.getString('profileName') ?? null;
    profileBio = prefs.getString('profileBio') ?? null;
    notifyListeners();
  }

  Future<void> saveProfileInfoToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profileName', profileName ?? '');
    prefs.setString('profileBio', profileBio ?? '');
    notifyListeners();
  }
  void saveprofile(String name,String bio){
    profileName = name;
    profileBio = bio;
    notifyListeners();
  }
}