import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:token_integration/splash_screen.dart';
import 'package:token_integration/user/user_preference.dart';

import 'onboarding/Login_screen.dart';
import 'provider/app_provider.dart';
import 'provider/auth_provider.dart';
import 'provider/user_provider.dart';
import 'provider/wallet_provider.dart';
import 'locator.dart' as di;
import 'utils/size_config.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await UserSimplePreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<AppProvider>()..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => di.locator<WalletProvider>()),

        ChangeNotifierProvider(create: (_) => di.locator<UserProvider>()),
        // ChangeNotifierProvider(create: (_) => di.locator<Auth>()),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: SizeConfiguration(
        designSize: const Size(375, 812),
        builder: (_) {
          return MaterialApp(
            title: 'YourRider',
            // theme: AppTheme.light(),
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
    
            home: const SplashScreen(),
            routes: {
              LoginScreen.routeName: (context) => const LoginScreen(),
              SplashScreen.routeName: (context) => const SplashScreen(),
              // Home.routeNames: ((context) => const Home(privKey: privKey, pubAddress: pubAddress)
            },
          );
        }
      ),
    );
  }
}
