// lib/features/Auth/data/datasources/forgot_password_datasource_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'forgot_password_datasource.dart';

@Injectable(as: ForgotPasswordDataSource)
class ForgotPasswordDataSourceImpl implements ForgotPasswordDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) {
    return executeApi(() async {
      try {
        await _firebaseAuth.sendPasswordResetEmail(
          email: email,
          actionCodeSettings: ActionCodeSettings(
            url: 'https://yourapp.com/reset-password', // Your app's reset page
            handleCodeInApp: false, // Set to true if you want to handle in app
            iOSBundleId: 'com.yourcompany.wisechild', // Your iOS bundle ID
            androidPackageName: 'com.yourcompany.wisechild', // Your Android package
            androidInstallApp: true,
            androidMinimumVersion: '12',
          ),
        );
      } on FirebaseAuthException catch (e) {
        throw Exception('firebase_auth_${e.code}: ${e.message}');
      } catch (e) {
        throw Exception('network_error: Failed to send reset email');
      }
    });
  }

  @override
  Future<Result<bool>> verifyEmailExists(String email) {
    return executeApi(() async {
      try {
        // Try to fetch sign-in methods for the email
        final methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
        return methods.isNotEmpty;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          return false;
        }
        throw Exception('firebase_auth_${e.code}: ${e.message}');
      } catch (e) {
        throw Exception('network_error: Failed to verify email');
      }
    });
  }
}
