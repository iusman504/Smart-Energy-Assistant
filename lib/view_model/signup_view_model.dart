import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _loading = false;
  bool get loading =>_loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

void clearFields(){
  nameController.clear();
  emailController.clear();
  phoneNoController.clear();
  passwordController.clear();
}

  String? validation  (){
    if (nameController.text.isEmpty) {
      return 'Please Enter Your Name';
    }
    else if (emailController.text.isEmpty) {
      return 'Please Enter Your Email';
    }
    else if (phoneNoController.text.isEmpty) {
      return 'Please Enter Your Phone No';
    }
    else if (passwordController.text.isEmpty) {
      return 'Please Enter Your Password';
    }
    return null;
  }

  Future<String?> signUp() async {
    try{
      setLoading(true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      User? currentUser = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('user').doc(currentUser!.uid).set({
        'Name' : nameController.text.trim(),
        'Phone No' : phoneNoController.text.trim(),
        'user_id' : currentUser.uid
      });

      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('name', nameController.text.trim());
      sp.setString('user_id', currentUser.uid);

      notifyListeners();
      setLoading(false);
      return null;
    } on FirebaseException catch (e) {
      setLoading(false);
      if (e.code == 'invalid-email') {
        return 'The Email Format is Invalid.';
      }
      else if (e.code == 'email-already-in-use') {
        return 'This Email Is Already Registered.';
      }
      else if (e.code == 'weak-password') {
        return 'Password Must Be At Least 6 Characters';
      }
      else {
        return'An error occurred';

      }
    }
  }
}