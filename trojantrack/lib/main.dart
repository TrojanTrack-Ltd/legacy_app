import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/horse_provider.dart';
import '../screens/home_screen.dart';
import '../screens/auth/login_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext? get getContext => navigatorKey.currentState?.context;

void main() {
      WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth provider...
        ChangeNotifierProvider<AuthsProvider>.value(value: AuthsProvider()),

        // Horse provider...
        ChangeNotifierProvider<TrojanTrackProvider>.value(value: TrojanTrackProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TrojanTrack',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: buildMaterialColor(Color(0xFF1264AC)),
          visualDensity: VisualDensity.adaptivePlatformDensity,

          scaffoldBackgroundColor: Color(0xFFA4DAF3),
          // Elevated button theme...
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
              fixedSize: MaterialStateProperty.all(
                const Size(double.maxFinite, 55),
              ),
            ),
          ),
        ),
        home: Builder(
          builder: (context) => FutureBuilder(
            future:
                Provider.of<AuthsProvider>(getContext ?? context, listen: false)
                    .fetchUser(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Scaffold(
                        body: Center(
                          child: Image.asset(
                            'assets/preview.jpg',
                            width: 180,
                          ),
                        ),
                      )
                    : Consumer<AuthsProvider>(
                        builder: (context, auth, child) => auth.isUserLogin
                            ? const HomeScreen()
                            : const LoginScreen(),
                      ),
          ),
        ),
      ),
    );
  }
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
