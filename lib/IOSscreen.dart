import 'dart:convert';
import 'dart:io';

import 'package:contacts/AndroidProvider.dart';
import 'package:contacts/ContactModel.dart';
import 'package:contacts/ContactProvider.dart';
import 'package:contacts/IOSProvider.dart';
import 'package:contacts/Themeprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class IOSscreen extends StatefulWidget {
  const IOSscreen({super.key});

  @override
  State<IOSscreen> createState() => _IOSscreenState();
}

class _IOSscreenState extends State<IOSscreen> with SingleTickerProviderStateMixin{
  late TabController controller;
  Color color = Colors.blue;
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController Phoncontroller = TextEditingController();
  TextEditingController chatcontroller = TextEditingController();
  TextEditingController ProfileNamecontroller = TextEditingController();
  TextEditingController ProfileBiocontroller = TextEditingController();
  @override
  void initState() {
    controller = TabController(vsync: this, length: 4,initialIndex: 1);
    super.initState();
  }
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final androidProvider = Provider.of<AndroidProvider>(context);
    final contactListProvider = Provider.of<ContactListProvider>(context);
    final isoProvider = Provider.of<ISOProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
        title: Text(
          'Platform Converter',
          style: TextStyle(
              color: themeProvider.currentTheme.focusColor
          ),
        ),
        actions: [
          CupertinoSwitch(
            value: androidProvider.IsAndroid,
            onChanged: (value) {
              androidProvider.SwitchChange(value);
            },
          )
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center ,
                children: [
                  Consumer<AndroidProvider>(
                    builder: (context, androidProvider, child) {
                      return InkWell(
                        onTap: () async{
                          androidProvider.profilePicture();
                        },
                        child: androidProvider.image != null?Center(
                          child: CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(File(androidProvider.image!.path))
                          ),
                        ):CircleAvatar(
                          radius: 50,
                          backgroundColor: themeProvider.isLightTheme?Colors.grey:color ,
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo_outlined,color: themeProvider.currentTheme.focusColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: fullnamecontroller,
                    style: TextStyle(
                        color: themeProvider.currentTheme.focusColor
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_sharp,color: themeProvider.currentTheme.focusColor,),
                        // icon: Icon(Icons.person_outline_sharp,color: themeProvider.currentTheme.focusColor,),
                        hintText: 'Full Name',
                        hintStyle: TextStyle(
                            color: themeProvider.currentTheme.focusColor
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.currentTheme.focusColor
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.currentTheme.focusColor
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: Phoncontroller,
                    style: TextStyle(
                        color: themeProvider.currentTheme.focusColor
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.call,color: themeProvider.currentTheme.focusColor,),
                        //icon: Icon(Icons.call,color: themeProvider.currentTheme.focusColor,),
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(
                            color: themeProvider.currentTheme.focusColor
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.currentTheme.focusColor
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.currentTheme.focusColor
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: chatcontroller,
                    style: TextStyle(
                        color: themeProvider.currentTheme.focusColor
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chat_outlined,color: themeProvider.currentTheme.focusColor,) ,
                        //icon: Icon(Icons.chat,color: themeProvider.currentTheme.focusColor,),
                        hintText: 'Chat Conversation ',
                        hintStyle: TextStyle(
                            color: themeProvider.currentTheme.focusColor
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.currentTheme.focusColor
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.currentTheme.focusColor
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap:() async{
                      final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: androidProvider.selectedDate,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101));
                      if (picked != null && picked != androidProvider.selectedDate) {
                        androidProvider.selectedDate = picked;
                        androidProvider.pickdate(picked);
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month,color: themeProvider.currentTheme.focusColor),
                        SizedBox(width: 15,),
                        Text(
                          androidProvider.Date!=null? androidProvider.Date??'date' :'Pick Date',
                          style: TextStyle(
                              color: themeProvider.currentTheme.focusColor
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () async{
                      final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: androidProvider.selectedTime
                      );
                      androidProvider.picktime(picked!);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.access_time_sharp,color: themeProvider.currentTheme.focusColor),
                        SizedBox(width: 15,),
                        Text(
                          androidProvider.time!=null?androidProvider.time!:'Pick Time',
                          style: TextStyle(
                              color: themeProvider.currentTheme.focusColor
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Center(
                    child: InkWell(
                      onTap: () {
                        if(androidProvider.image!=null){
                          androidProvider.saveImge();
                        }
                        contactListProvider.addContact(Contact(fullnamecontroller.text.toString(), Phoncontroller.text.toString(), chatcontroller.text.toString(), androidProvider.Date!, androidProvider.time!,androidProvider.base64String!));
                        contactListProvider.saveContacts();
                        fullnamecontroller.clear();
                        Phoncontroller.clear();
                        chatcontroller.clear();
                        androidProvider.time = null;
                        androidProvider.Date = null;
                        androidProvider.image = null;

                      },
                      child: Container(
                        height: 40,width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: themeProvider.currentTheme.focusColor
                            )
                        ),
                        child: Center(
                          child: Text(
                            'SAVE',
                            style: TextStyle(
                                color: themeProvider.currentTheme.focusColor
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          contactListProvider.contacts.length>0?Column(
            children: [
              for(int i= 0 ; i < contactListProvider.contacts.length;i++)...[
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 300,
                          color: themeProvider.currentTheme.scaffoldBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                androidProvider.base64String!=null?ClipRRect(
                                  borderRadius: BorderRadius.circular(110),
                                  child:Image.memory(Uint8List.fromList(base64.decode(contactListProvider.contacts[i].Image)),height: 100,width: 100,fit: BoxFit.cover,)
                                  ,
                                ):CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  radius: 35,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      contactListProvider.contacts[i].Fullname,
                                      style: TextStyle(
                                          color: themeProvider.currentTheme.focusColor,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      contactListProvider.contacts[i].ChatConversation,
                                      style: TextStyle(
                                          color: themeProvider.currentTheme.focusColor,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  width: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          child: Icon(Icons.edit,color: themeProvider.currentTheme.focusColor,)
                                      ),
                                      InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shadowColor: Colors.grey.shade700,
                                                  backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
                                                  title:  Text('Delete',style: TextStyle(color: themeProvider.currentTheme.focusColor),),
                                                  content:  SingleChildScrollView(
                                                    child: Text('Are you Want delete',style: TextStyle(color: themeProvider.currentTheme.focusColor)),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child:  Text('Cancel',style: TextStyle(color: themeProvider.currentTheme.focusColor)),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child:  Text('Yes',style: TextStyle(color: themeProvider.currentTheme.focusColor)),
                                                      onPressed: () {
                                                        contactListProvider.deleteContact(i);
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(Icons.delete,color: themeProvider.currentTheme.focusColor,)
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40,width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: themeProvider.currentTheme.focusColor
                                        )
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: themeProvider.currentTheme.focusColor
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: androidProvider.base64String!=null?ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child:Image.memory(
                        Uint8List.fromList(base64.decode(contactListProvider.contacts[i].Image)),
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      )
                      ,
                    ):CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 35,
                    ),
                    title: Text(
                      contactListProvider.contacts[i].Fullname,
                      style: TextStyle(
                          color: themeProvider.currentTheme.focusColor,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    subtitle: Text(
                      contactListProvider.contacts[i].ChatConversation,
                      style: TextStyle(
                          color: themeProvider.currentTheme.focusColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    trailing: Text(
                      '${contactListProvider.contacts[i].Date},${contactListProvider.contacts[i].Time}',
                      style: TextStyle(
                          color: themeProvider.currentTheme.focusColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ):Center(child: Text('No any Chats yet...',style: TextStyle(color: themeProvider.currentTheme.focusColor))),
          contactListProvider.contacts.length>0?Column(
            children: [
              for(int i= 0 ; i < contactListProvider.contacts.length;i++)...[
                ListTile(
                    leading: androidProvider.base64String!=null?ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child:Image.memory(Uint8List.fromList(base64.decode(contactListProvider.contacts[i].Image)),height: 60,width: 60,fit: BoxFit.cover,)
                      ,
                    ):CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 35,
                    ),
                    title: Text(
                      contactListProvider.contacts[i].Fullname,
                      style: TextStyle(
                          color: themeProvider.currentTheme.focusColor,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    subtitle: Text(
                      contactListProvider.contacts[i].ChatConversation,
                      style: TextStyle(
                          color: themeProvider.currentTheme.focusColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    trailing: Icon(Icons.phone,color: Colors.green,)
                ),
              ]
            ],
          ):Center(child: Text('No any Call yet...',style: TextStyle(color: themeProvider.currentTheme.focusColor))),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person,color: color),
                    title: Text(
                      'Profile',
                      style: TextStyle(
                          color: themeProvider.currentTheme.focusColor
                      ),
                    ),
                    subtitle: Text(
                      'Update Profile Data',
                      style: TextStyle(
                          color: themeProvider.currentTheme.focusColor
                      ),
                    ),
                    trailing: CupertinoSwitch(
                      trackColor:  Colors.grey,
                      onChanged: (value) {
                        androidProvider.ChangeProfile(value);
                      },
                      value: androidProvider.profile,
                    ),
                  ),
                  Consumer<AndroidProvider>(
                    builder: (context, androidProvider, child) {
                      return androidProvider.profile?Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                            Consumer<AndroidProvider>(
                              builder: (context, androidProvider, child) {
                                return InkWell(
                                  onTap: () async{
                                    androidProvider.profilePicture2();
                                  },
                                  child: androidProvider.Profileimage != null?Center(
                                    child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(File(androidProvider.Profileimage!.path))
                                    ),
                                  ):CircleAvatar(
                                    radius: 50,
                                    backgroundColor: themeProvider.isLightTheme?Colors.grey:color ,
                                    child: Center(
                                      child: Icon(
                                        Icons.add_a_photo_outlined,color: themeProvider.currentTheme.focusColor,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 100),
                                child: TextField(
                                  controller: ProfileNamecontroller,
                                  style: TextStyle(
                                      color: themeProvider.currentTheme.focusColor
                                  ),
                                  decoration: InputDecoration(
                                      prefixText: ProfileNamecontroller.text,
                                      hintText: 'Enter your name...',
                                      hintStyle: TextStyle(
                                          color: themeProvider.currentTheme.focusColor
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themeProvider.currentTheme.scaffoldBackgroundColor
                                          )
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themeProvider.currentTheme.scaffoldBackgroundColor
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 100),
                                child: TextField(
                                  controller: ProfileBiocontroller,
                                  style: TextStyle(
                                      color: themeProvider.currentTheme.focusColor
                                  ),
                                  decoration: InputDecoration(
                                      prefixText: ProfileBiocontroller.text,
                                      hintText: 'Enter your Bio...',
                                      hintStyle: TextStyle(
                                          color: themeProvider.currentTheme.focusColor
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themeProvider.currentTheme.scaffoldBackgroundColor
                                          )
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themeProvider.currentTheme.scaffoldBackgroundColor
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        if(androidProvider.Profileimage!=null){
                                          androidProvider.saveProfileImge();
                                        }
                                        androidProvider.saveProfileInfoToPrefs();
                                      },
                                      child: Text(
                                        'SAVE',
                                        style: TextStyle(
                                            color: color
                                        ),
                                      )
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        ProfileBiocontroller.clear();
                                        ProfileNamecontroller.clear();
                                        androidProvider.Profileimage = null;
                                      },
                                      child: Text(
                                        'CLEAR',
                                        style: TextStyle(
                                            color: color
                                        ),
                                      )
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ):SizedBox();
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.sunny,color: color),
                    title: Text(
                      'Theme',
                      style: TextStyle(
                          color: themeProvider.currentTheme.focusColor
                      ),
                    ),
                    subtitle: Text(
                      'Change Theme',
                      style: TextStyle(
                          color: themeProvider.currentTheme.focusColor
                      ),
                    ),
                    trailing: CupertinoSwitch(
                      trackColor: Colors.grey.shade500,
                      onChanged: (value) {
                        themeProvider.setTheme(value);
                        themeProvider.saveThemevalue(value);
                      },
                      value: themeProvider.isLightTheme,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: DefaultTabController(
        initialIndex: index,
        length: 4,
        child: TabBar(
            controller: controller,
            indicatorSize: TabBarIndicatorSize.label,
            automaticIndicatorColorAdjustment: true,
            unselectedLabelColor: Colors.grey,
            labelColor: color,
            labelPadding: EdgeInsets.zero,
            indicatorColor: color,
            labelStyle: TextStyle(
                color: color
            ),
            onTap: (value) {
              androidProvider.GetIndex(value);
            },
            tabs: [
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: isoProvider.currentIndex == 0
                      ? Icon(CupertinoIcons.person_add_solid)
                      : Icon(CupertinoIcons.person_add),
                text: 'Add',
              ),
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: isoProvider.currentIndex == 0
                      ? Icon(CupertinoIcons.chat_bubble_2_fill)
                      : Icon(CupertinoIcons.chat_bubble_2),
                text: 'Chats',
              ),
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: isoProvider.currentIndex == 0
                      ? Icon(CupertinoIcons.phone_fill)
                      : Icon(CupertinoIcons.phone),
                text: 'Call',
              ),
              Tab(
                iconMargin: EdgeInsets.zero,
                icon: isoProvider.currentIndex == 0
                      ? Icon(CupertinoIcons.settings_solid)
                      : Icon(CupertinoIcons.settings),
                text: 'Setting',
              ),

            ]
        ),
      )
    );
  }
}
