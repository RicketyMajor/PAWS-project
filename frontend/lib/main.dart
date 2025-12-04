import 'package:festymatch_frontend/pages/profile_pages/edit_profile_page.dart';
import 'package:festymatch_frontend/pages/profile_pages/set_about_me_page.dart';
import 'package:festymatch_frontend/services/profile_service.dart';
import 'package:festymatch_frontend/components/models/pet_model.dart';
import 'package:festymatch_frontend/components/models/adopter_model.dart';
import 'package:festymatch_frontend/components/models/match_result_model.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'pages/auth_pages/chat_list_page.dart';
import 'pages/auth_pages/login_page.dart';
import 'pages/auth_pages/register_page.dart';
import 'pages/profile_pages/profile_page.dart';
import 'pages/user_settings_pages/settings_page.dart';
import 'pages/user_settings_pages/change_password_settings_page.dart';
import 'pages/adoptant_pages/housing_form_page.dart';
import 'pages/adoptant_pages/preference_form_page.dart';
import 'pages/profile_pages/user_purpose_page.dart';
import 'pages/welcome_page.dart';
import 'pages/profile_pages/set_name_page.dart';
import 'pages/profile_pages/set_location_page.dart';
import 'pages/adoptant_pages/home_page_adopter.dart';
import 'pages/rescuer_pages/home_page_rescue.dart';
import 'pages/adoptant_pages/be_adoptant_page.dart';
import 'pages/rescuer_pages/be_rescuer_page.dart';
import 'pages/profile_pages/set_profile_picture_page.dart';
import 'pages/rescuer_pages/set_pet_name_page.dart';
import 'pages/rescuer_pages/set_pet_info_1_page.dart';
import 'pages/rescuer_pages/set_pet_picture_page.dart';
import 'pages/rescuer_pages/likes_page.dart';
import "gates/home_adopter_gate.dart";
import 'pages/rescuer_pages/pet_profile_page.dart';
import 'pages/rescuer_pages/edit_pet_profile_page.dart';
import 'pages/rescuer_pages/chat_adopter_profile_page.dart';
import 'pages/adoptant_pages/chat_adoptant_page.dart';
import 'pages/rescuer_pages/chat_rescuer_page.dart';
import 'pages/adoptant_pages/chat_pet_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isAuthenticated = false;
  bool isProfileCreated = false;
  String userRole = '';

  try {
    isAuthenticated = await AuthService().checkAuthentication();
    if (isAuthenticated) {
      userRole = await AuthService().getUserRole() ?? '';
      isProfileCreated = await ProfileService().verifyProfileCreated();
    }
  } catch (e) {
    print("Error al comprobar autenticación: $e");
  }

  runApp(MyApp(
    isAuthenticated: isAuthenticated,
    userRole: userRole,
    isProfileCreated: isProfileCreated,
  ));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final bool isProfileCreated;
  final String userRole;

  const MyApp(
      {super.key,
      required this.isAuthenticated,
      required this.userRole,
      required this.isProfileCreated});

  @override
  Widget build(BuildContext context) {
    Widget initialPage;
    if (!isAuthenticated) {
      initialPage = const WelcomePage();
    } else if (!isProfileCreated) {
      initialPage = const UserPurposePage();
    } else {
      initialPage = const HomeAdopterGate();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paws',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: initialPage,
      routes: {
        '/register': (context) => const registerPage(),
        '/login': (context) => const loginPage(),
        '/profile_page': (context) => const ProfilePage(),
        '/settings_page': (context) => const SettingsPage(),
        '/change_password': (context) => const changePasswordPage(),
        '/set_name_page': (context) => const SetNamePage(),
        '/set_location_page': (context) => const SetLocationPage(),
        '/housing_form_page': (context) => const HousingFormPage(),
        '/preference_form_page': (context) => const PreferencesFormPage(),
        '/user_purpose_page': (context) => const UserPurposePage(),
        '/home_page_adopter': (context) => const HomePageAdopter(),
        '/home_page_rescue': (context) => const HomePageRescue(),
        '/be_adoptant_page': (context) => const BeAdoptantPage(),
        '/be_rescuer_page': (context) => const BeRescuerPage(),
        '/set_profile_picture_page': (context) => const SetProfilePicturePage(),
        '/set_pet_info_1_page': (context) => const SetPetInfo1Page(),
        '/set_pet_picture_page': (context) => const SetPetPicturePage(),
        '/set_pet_name_page': (context) => const SetPetNamePage(),
        "/home_adopter_gate": (context) => const HomeAdopterGate(),
        "/edit_profile_page": (context) => const EditProfilePage(),
        "/set_aboutMe_page": (context) => const SetaboutMePage(),
        "/chat_rescuer_page": (context) {
          final match = ModalRoute.of(context)!.settings.arguments as MatchResultModel;
          return ChatRescuerPage(match: match);
        },
        "/chatadopter_profile_page": (context) {
          final adopter = ModalRoute.of(context)!.settings.arguments as AdopterModel;
          return ChatAdopterProfilePage(adopter: adopter);
        },
        "/chat_list_page": (context) => const ChatListPage(),
        "/chat_adoptant_page": (context) {
      final match = ModalRoute.of(context)!.settings.arguments as MatchResultModel;
      return ChatAdoptantPage(match: match);
    },
         "/chat_pet_profile_page": (context) {
      final pet = ModalRoute.of(context)!.settings.arguments as Pet;
      return ChatPetProfilePage(pet: pet);
    },
  });
  }
}
