import 'package:flutter/material.dart';
import 'package:wise_child/features/Auth/presentation/pages/Auth_page.dart';
import 'package:wise_child/features/ChatBotAssistant/presentation/pages/chatbot_assistant_page.dart';
import 'package:wise_child/features/AddChildren/presentation/pages/add_child_chatbot_screen.dart';
import 'package:wise_child/features/NewChildren/presentation/pages/NewChildren_page.dart';
import 'package:wise_child/features/layout/presentation/pages/layout_view.dart';
import 'package:wise_child/welcome_screen.dart';

class RoutesManager {
  static const String welcomeScreen = '/';
  static const String authPage = '/AuthPage';
  static const String layoutScreen = '/LayoutScreen';
  static const String chatBotAssistantScreen = '/ChatBotAssistantScreen';
  static const String chatBotAddChildScreen = '/chatBotAddChildScreen';
  static const String newChildrenPage = '/NewChildrenPage';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesManager.welcomeScreen:
        return NavigateAnimation(const WelcomeScreen());
      case RoutesManager.chatBotAssistantScreen:
        return NavigateAnimation(const ChatBotAssistantPage());
      case RoutesManager.authPage:
        return NavigateAnimation(const AuthPage());
        case RoutesManager.layoutScreen:
        return NavigateAnimation(const LayoutScreen());
      // case RoutesManager.chatBotAddChildScreen:
      //   return NavigateAnimation(const AddChildChatbotScreen());
      case RoutesManager.newChildrenPage:
        return NavigateAnimation(const NewChildrenPage());
      default:
        return unDefinedRoute();
    }
  }


  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text("No Route Found")),
      ),
    );
  }
}





/// ✅ Fade + Slide Animation
class NavigateAnimation extends PageRouteBuilder {
  final Widget page;

  NavigateAnimation(this.page)
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );


      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          // begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );
    },
  );
}
