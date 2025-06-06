import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/api/api_manager/api_manager.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Auth/data/models/request/get_user_email_request.dart';

import 'package:wise_child/features/Auth/data/models/request/user_model_response.dart';
import 'package:wise_child/features/Auth/domain/entities/user_entity.dart';
import 'Auth_datasource_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthDatasourceRepo)
class AuthDatasourceRepoImpl implements AuthDatasourceRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ApiService _apiService;

  AuthDatasourceRepoImpl(this._apiService);

  @override
  Future<Result<UserSignUpEntity?>> signUp(
      String? firstName,
      String? lastName,
      String email,
      String password,
      ) async {

      return await executeApi(() async {
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (credential.user != null) {
          UserModelRequest userModelRequest = UserModelRequest(
            id: credential.user!.uid,
            firstName: firstName ?? credential.user!.displayName ?? 'Unknown',
            gender: 'male',
            lastName: lastName ?? 'Unknown',
            profileImage: credential.user!.photoURL,
            email: credential.user!.email ?? email,
            password: password,
          );
          var user = await _apiService.signUp(userModelRequest);
          return user?.toUserSignInEntity();
        }
        return null;
      });
    }



  @override
  Future<Result<UserSignUpEntity?>> signIn(String email, String password) {
    return executeApi(() async {
      // تسجيل الدخول إلى Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final user = userCredential.user!;
        GetUserByEmailRequest userModelRequest = GetUserByEmailRequest(

          email: user.email,

        );
        // طلب الحصول على بيانات المستخدم من API
        final userResponse = await _apiService.getUserByEmail(userModelRequest);

        if (userResponse != null) {
          // تحويل النتيجة إلى كيان التطبيق
          return userResponse.toUserSignInEntity();
        } else {
          throw Exception("User data not found in the database.");
        }
      } else {
        throw Exception("Failed to sign in. User credentials are invalid.");
      }
    });
  }




  @override
  Future<Result<UserSignUpEntity?>> signInWithGoogle() {
    return executeApi(() async {
      // خطوة تسجيل الدخول باستخدام Google
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // تسجيل الدخول إلى Firebase باستخدام بيانات Google
        final userCredential = await _firebaseAuth.signInWithCredential(credential);

        if (userCredential.user != null) {
          final user = userCredential.user!;
          UserModelRequest userModelRequest = UserModelRequest(
            id: user.uid,
            firstName: googleUser.displayName?.split(' ').first ?? '',
            lastName: googleUser.displayName?.split(' ').last ?? '',
            email: user.email,
            profileImage: user.photoURL,
          );

          final userEntity = await _apiService.signUpWithGoogle(userModelRequest);
          return userEntity?.toUserSignInEntity();
        } else {
          throw Exception('Google Sign-In failed: User is null.');
        }
      } else {
        throw Exception('Google Sign-In was cancelled by the user.');
      }
    });
  }



}
