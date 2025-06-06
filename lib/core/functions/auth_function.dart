import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/routes_manager.dart';

import 'custom_flush_bar.dart';

class AuthFunctions {
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      if (userCredential.user != null) {
       log(userCredential.user!.photoURL.toString());
       log(userCredential.user!.phoneNumber.toString());
       log(userCredential.user!.photoURL.toString());
       log(userCredential.user!.providerData.toString());

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, RoutesManager.chatBotAssistantScreen);
        }
      }
    } catch (e) {
      Flushbar(
        title: "Error",
        message: "Error during Google sign-in",
        backgroundColor: Colors.red,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          ),
        ],
      ).show(context);
      print('Error during Google sign-in: $e');
    }
  }

  static Future<void> signInWithEmail(
    BuildContext context,
    String emailAddress,
    String password,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress.trim(),
        password: password.trim(),
      );

      if (userCredential.user != null && context.mounted) {

        Navigator.pushReplacementNamed(context, RoutesManager.chatBotAssistantScreen);
      }
      log(userCredential.user!.photoURL.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.uid.toString());
      log(userCredential.user!.phoneNumber.toString());
      log(userCredential.user!.photoURL.toString());
      log(userCredential.user!.providerData.toString());
      print('User signed in: ${userCredential.user?.uid}');
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} | ${e.message}');

      String errorMessage = 'حدث خطأ أثناء تسجيل الدخول.';
      if (e.code == 'user-not-found') {
        errorMessage = 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'كلمة المرور غير صحيحة.';
      }
    }
  }

  static Future<void> resetPassword(
    BuildContext context,
    String emailAddress,
  ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: "mohammedzewin01@gmail.com",
      );
      if (context.mounted) {
        customFlushBar(context, message:  "Password reset email sent successfully", title: "Success");
      }


    } catch (e) {
      if (context.mounted) {
        customFlushBar(context, message:   "Error during password reset", title: "Error", color: Colors.red);
      }

      print('Error during password reset: $e');
    }
  }

  static Future<void> signupInWithEmail(
    BuildContext context,
    String emailAddress,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
}

