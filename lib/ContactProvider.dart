import 'package:contacts/ContactModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactListProvider extends ChangeNotifier {
  List<Contact> contacts = [];
  Future<List> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsData = prefs.getStringList('contacts');
    if (contactsData != null) {
      contacts = contactsData.map((data) {
        final parts = data.split(',');
        return Contact(parts[0], parts[1],parts[2],parts[3],parts[4],parts[5]);
      }).toList();
      notifyListeners();
    }
    return contacts;
  }
  void addContact(Contact newContact) {
    contacts.add(newContact);
    saveContacts();
    notifyListeners();
  }

  void updateContact(int index, Contact updatedContact) {
    contacts[index] = updatedContact;
    saveContacts();
    notifyListeners();
  }

  void deleteContact(int index) {
    contacts.removeAt(index);
    saveContacts();
    notifyListeners();
  }

  void saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsData = contacts.map((contact) {
      return '${contact.Fullname},${contact.phoneNumber},${contact.ChatConversation},${contact.Date},${contact.Time},${contact.Image}';
    }).toList();
    prefs.setStringList('contacts', contactsData);
  }
}