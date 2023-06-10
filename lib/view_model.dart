import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import 'component.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  bool isSignedIn = false;
  bool isObscure = true;


  var logger = Logger();

  List expensesName = [];
  List expenseAmount = [];
  List incomeesName = [];
  List incomeAmount = [];

  //check if signed in

  Future<void> isLoggedin() async {
    await _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isSignedIn = false;
      } else {
        isSignedIn = true;
      }
    });
    notifyListeners();
  }

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> createUserWihEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.d("Registration Successful"))
        .onError((error, stackTrace) {
      logger.d("Registration error $error");
      DialogBox(
          context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.d("Logged In Successfully"))
        .onError((error, stackTrace) {
      logger.d("Log in Error $error");
      DialogBox(
          context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  Future<void> signInWithGoogleWeb(BuildContext context) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    await _auth.signInWithPopup(googleAuthProvider).onError(
        (error, stackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    logger
        .d("Current user is not empty = ${_auth.currentUser!.uid.isNotEmpty}");
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> signInWithGoogleMobile(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn()
        .signIn()
        .onError((error, stackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    await _auth.signInWithCredential(credential).then((value) {
      logger.d("Google sign in successfully");
    }).onError((error, stackTrace) {
      logger.d("Google sign in error $error");
      DialogBox(
          context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  //DATABASE

  Future addExpense(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(32.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(text: 'Name', containerWidth: 130.0, hintText: 'Name', controller: controllerName, validator: (text){
                if(text.toString().isEmpty){
                  return "Required";
                }
              }),
              SizedBox(width: 10.0,),
              TextForm(text: 'Amount', containerWidth: 100.0, hintText: 'Amount', controller: controllerAmount, validator: (text){
                if(text.toString().isEmpty){
                  return "Required";
                }
              }),
              SizedBox(width: 10.0,),
            ],
          ),
        ),
        actions: [
          MaterialButton(child: OpenSans(text: 'save',size: 15.0,color: Colors.white,),
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onPressed: () async{
              if(formKey.currentState!.validate()){
               await userCollection.doc(_auth.currentUser!.uid).collection('expenses')
                    .add({
                  "name" : controllerName.text,
                  "amount" : controllerAmount.text,
                  
                }).onError((error, stackTrace) {
                  logger.d("add expense error = $error");
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
          ),

        ],
      ),
    );
  }
}
