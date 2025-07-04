// lib/features/Auth/presentation/bloc/forgot_password_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import '../../domain/useCases/forgot_password_usecase.dart';

part 'forgot_password_state.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._forgotPasswordUseCase) : super(ForgotPasswordInitial());
  
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty || !_isValidEmail(email)) {
      emit(ForgotPasswordFailure('البريد الإلكتروني غير صحيح'));
      return;
    }

    emit(ForgotPasswordLoading());
    
    try {
      final result = await _forgotPasswordUseCase.sendPasswordResetEmail(email.trim());
      
      switch (result) {
        case Success<void>():
          if (!isClosed) {
            emit(ForgotPasswordSuccess());
          }
          break;
        case Fail<void>():
          if (!isClosed) {
            emit(ForgotPasswordFailure(_getErrorMessage(result.exception)));
          }
          break;
      }
    } catch (e) {
      if (!isClosed) {
        emit(ForgotPasswordFailure('حدث خطأ غير متوقع. حاول مرة أخرى'));
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String _getErrorMessage(Exception exception) {
    final message = exception.toString().toLowerCase();
    
    if (message.contains('user-not-found') || message.contains('user not found')) {
      return 'لا يوجد حساب مسجل بهذا البريد الإلكتروني';
    } else if (message.contains('invalid-email') || message.contains('badly formatted')) {
      return 'البريد الإلكتروني غير صحيح';
    } else if (message.contains('too-many-requests') || message.contains('rate limit')) {
      return 'تم إرسال الكثير من الطلبات. حاول مرة أخرى لاحقاً (بعد 15 دقيقة)';
    } else if (message.contains('network-request-failed') || message.contains('network error')) {
      return 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى';
    } else if (message.contains('auth/operation-not-allowed')) {
      return 'إعادة تعيين كلمة المرور غير مفعلة. تواصل مع الدعم';
    } else if (message.contains('firebase_auth')) {
      return 'مشكلة في الخدمة. حاول مرة أخرى لاحقاً';
    } else {
      return 'حدث خطأ غير متوقع. حاول مرة أخرى';
    }
  }

  void reset() {
    emit(ForgotPasswordInitial());
  }
}
