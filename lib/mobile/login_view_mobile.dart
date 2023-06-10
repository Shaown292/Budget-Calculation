import 'package:calculating_budget/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

import '../view_model.dart';

class LoginViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _emailField = useTextEditingController();
    TextEditingController _passwordField = useTextEditingController();
    final viewModelProvider = ref.watch(viewModel);
    final double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: deviceHeight / 5.5),
            //logo
            Image.asset(
              "assets/logo.png",
              fit: BoxFit.contain,
              width: 210.0,
            ),
            SizedBox(
              height: 30.0,
            ),
            //Email text field
            SizedBox(
              width: 350.0,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                controller: _emailField,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  hintText: "Email",
                  hintStyle: GoogleFonts.openSans(),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),

            //password text field
            SizedBox(
              width: 350.0,
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: _passwordField,
                obscureText: viewModelProvider.isObscure,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: IconButton(
                      icon: Icon(
                        viewModelProvider.isObscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      onPressed: () {
                        viewModelProvider.toggleObscure();
                      }),
                  hintText: "Password",
                  hintStyle: GoogleFonts.openSans(),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //Register Button
                SizedBox(
                  height: 50.0,
                  width: 150.0,
                  child: MaterialButton(
                    onPressed: () async {
                      await viewModelProvider.createUserWihEmailAndPassword(context, _emailField.text, _passwordField.text);
                    },
                    child: OpenSans(text: "Register", size: 25.0, color: Colors.white,),
                    splashColor: Colors.grey,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Text('Or',
                style: GoogleFonts.pacifico(
                  color: Colors.black,
                  fontSize: 15.0
                ),
                ),
                SizedBox(width: 20.0),
                //log in button
                SizedBox(
                  height: 50.0,
                  width: 150.0,
                  child: MaterialButton(
                    onPressed: () async {
                      await viewModelProvider.signInWithEmailAndPassword(context, _emailField.text, _passwordField.text);

                    },
                    child: OpenSans(text: "Log In", size: 25.0, color: Colors.white,),
                    splashColor: Colors.grey,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 30.0),
            //sign in with google
            SignInButton(buttonType: ButtonType.google,
                btnColor: Colors.black,
                btnTextColor: Colors.white,
                buttonSize: ButtonSize.medium,
                onPressed: () async {
                  if(kIsWeb){
                    await viewModelProvider.signInWithGoogleWeb(context);
                  }
                  else{
                    await viewModelProvider.signInWithGoogleMobile(context);
                  }
                }),
          ],
        ),
      ),
    ));
  }
}
