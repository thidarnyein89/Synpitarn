import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:synpitarn/data/custom_style.dart';
import 'package:synpitarn/data/language.dart';
import 'package:synpitarn/data/shared_rsa_value.dart';
import 'package:synpitarn/screens/auth/login.dart';
import 'package:synpitarn/screens/auth/register.dart';
import 'package:synpitarn/screens/home.dart';
import 'package:synpitarn/data/shared_value.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:synpitarn/l10n/app_localizations.dart';
import 'package:synpitarn/services/notification_service.dart';
import 'package:synpitarn/util/rsaUtil.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initializeFCM(clientId: '1559');
  runApp(MyApp());

  Future.microtask(() {
    runRSAKeyGenerator();
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }
}

enum AppStartStatus { loggedIn, needBiometricLogin, notLoggedIn }

class _MyAppState extends State<MyApp> {
  late Future<AppStartStatus> _loginStatusFuture;

  Locale? currentLocale = Locale(LanguageType.my.toString())!;

  @override
  void initState() {
    super.initState();
    getInitData();
    printDeviceInfo();
  }

  Future<void> getInitData() async {
    _loginStatusFuture = checkAppStartStatus();

    LanguageType language = await getLanguage();
    currentLocale = Locale(language.name);

    setState(() {});
  }

  Future<void> printDeviceInfo() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      print('❌ Device info not supported on this platform.');
      return;
    }

    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfoPlugin.androidInfo;
      print("✅ Android Device Info:");
      print("Model: ${android.name}");
      print("DeviceId: ${android.id}");
      print("OS Version: ${android.version.release}");
    } else if (Platform.isIOS) {
      final ios = await deviceInfoPlugin.iosInfo;
      print("✅ iOS Device Info:");
      print("Model: ${ios.model}");
      print("OS Version: ${ios.systemVersion}");
    }
  }

  Future<AppStartStatus> checkAppStartStatus() async {
    bool isLoggedIn = await getLoginStatus();
    if (isLoggedIn) {
      return AppStartStatus.loggedIn;
    }

    bool needBiometric = await getNeedBiometricLogin();
    if (needBiometric) {
      return AppStartStatus.needBiometricLogin;
    }

    return AppStartStatus.notLoggedIn;
  }

  void changeLanguage(Locale newLocale) {
    final langType = LanguageType.values.firstWhere(
      (e) => e.name == newLocale.languageCode,
      orElse: () => LanguageType.en,
    );

    setLanguage(langType);

    setState(() {
      currentLocale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:
          LanguageData.languages.map((lang) => lang.locale).toList(),
      locale: currentLocale,
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      navigatorKey: navigatorKey,
      home: FutureBuilder<AppStartStatus>(
        future: _loginStatusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          } else {
            final status = snapshot.data!;
            switch (status) {
              case AppStartStatus.loggedIn:
                return Banner(
                  message: 'Synpitarn',
                  location: BannerLocation.bottomStart,
                  child: HomePage(),
                );
              case AppStartStatus.needBiometricLogin:
                return Banner(
                  message: 'Synpitarn',
                  location: BannerLocation.bottomStart,
                  child: LoginPage(),
                );
              case AppStartStatus.notLoggedIn:
              default:
                return Banner(
                  message: 'Synpitarn',
                  location: BannerLocation.bottomStart,
                  child: MainPage(onLanguageChanged: changeLanguage),
                );
            }
          }
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  Function(Locale)? onLanguageChanged;

  MainPage({this.onLanguageChanged});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Locale? currentLocale;

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  Future<void> getInitData() async {
    LanguageType language = await getLanguage();
    Language.currentLanguage = language;
    currentLocale = Locale(language.name);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: const EdgeInsets.all(12.0),
            //     child: LanguageDropdown(
            //       selectedLocale: currentLocale!,
            //       onLanguageChanged: (locale) {
            //         widget.onLanguageChanged!(locale);
            //       },
            //     ),
            //   ),
            // ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/synpitarn.jpg', height: 180),
                    SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.welcomeMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomStyle.primary_color,
                      ),
                    ),
                    SizedBox(height: 100),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomStyle.primary_color,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.openAccount,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(AppLocalizations.of(context)!.or),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomStyle.primary_color,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.login,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
