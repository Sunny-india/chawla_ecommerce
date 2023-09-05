import 'package:chawla_trial_udemy/auth/customer_signup.dart';
import 'package:chawla_trial_udemy/auth/supplier_signup.dart';
import 'package:chawla_trial_udemy/galleries/access_gallery.dart';
import 'package:chawla_trial_udemy/galleries/bags_gallery.dart';
import 'package:chawla_trial_udemy/galleries/home_garden_gallery.dart';
import 'package:chawla_trial_udemy/main_screens/cart.dart';
import 'package:chawla_trial_udemy/main_screens/wish.dart';
import 'package:chawla_trial_udemy/providers/cart_provider.dart';
import 'package:chawla_trial_udemy/providers/wish_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/customer_login.dart';
import 'auth/supplier_login.dart';
import 'galleries/electronics_gallery.dart';
import 'galleries/men_gallery.dart';
import 'galleries/shoes_gallery.dart';
import 'galleries/women_gallery.dart';
import 'main_screens/customer_home.dart';
import 'main_screens/splash_screen.dart';
import 'main_screens/supplier_home.dart';
import 'main_screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // comes from firebase_core package.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishList(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          // for later use in a card. Awesome...
          //cardColor: NeumorphicColors.background,
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.brown,
            indicatorColor: Colors.brown,
          ),
          // bottomAppBarTheme: const BottomAppBarTheme(color: Colors.teal),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontFamily: 'FontMain', fontSize: 24),
            titleMedium: TextStyle(fontFamily: 'FontTwo', fontSize: 17.5),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.screenName,
        routes: {
          SplashScreen.screenName: (context) => const SplashScreen(),
          WelcomeScreen.screenName: (context) => WelcomeScreen(),
          SupplierHomeScreen.screenName: (context) =>
              const SupplierHomeScreen(),
          CustomerHomeScreen.screenName: (context) =>
              const CustomerHomeScreen(),
          CartScreen.screenName: (context) => const CartScreen(),
          CustomerRegister.screenName: (context) => const CustomerRegister(),
          CustomerLogin.screenName: (context) => const CustomerLogin(),
          SupplierRegister.screenName: (context) => const SupplierRegister(),
          SupplierLogin.screenName: (context) => const SupplierLogin(),
          MenGalleryScreen.screenName: (context) => const MenGalleryScreen(),
          WomenGalleryScreen.screenName: (context) =>
              const WomenGalleryScreen(),
          ShoesGalleryScreen.screenName: (context) =>
              const ShoesGalleryScreen(),
          BagsGalleryScreen.screenName: (context) => const BagsGalleryScreen(),
          ElectronicsGalleryScreen.screenName: (context) =>
              const ElectronicsGalleryScreen(),
          AccessoriesGalleryScreen.screenName: (context) =>
              const AccessoriesGalleryScreen(),
          HomeGardenGalleryScreen.screenName: (context) =>
              const HomeGardenGalleryScreen(),
          // ProductDetailScreen.screenName: (context) =>
          //     ProductDetailScreen(),
          WishScreen.screenName: (context) => const WishScreen(),
        },
      ),
    ),
  );
}
