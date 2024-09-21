import 'package:flutter/material.dart';
import 'package:todo_app/my_user.dart';

class UserProvider extends ChangeNotifier{
  MyUser? currentUser ;
  void updateUser(MyUser newUser){
    currentUser = newUser ;
    notifyListeners() ;


  }
}