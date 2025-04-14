import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iplayer/view/CustomDrawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:iplayer/view/Splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA1KRRkOQw6k8d3AtZVUMnZUFQorYy2Fr4",
      appId: "1:986347211104:android:d162f91ef4af24f061f605",
      messagingSenderId: "986347211104",
      storageBucket: "zomato-239cf.appspot.com",
      projectId: "zomato-239cf",
    ),
  );
  await Hive.initFlutter();
  await Hive.openBox('videoBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()..fetchUserProfile()),
      ],
      child: VideoPlayerApp(),
    ),
  );
}
class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Player',
      home: SplashScreen(),
    );
  }
}
class VideoProvider with ChangeNotifier {
  Box<dynamic>? _videoBox;

  Box<dynamic>? get videoBox => _videoBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    _videoBox = await Hive.openBox('videoBox');
    await _requestPermissions();
    notifyListeners();
  }
  Future<void> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }
}
