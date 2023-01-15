import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:message_quest/maps/start_map.dart';
import 'package:message_quest/player/player_sprite.dart';

void main() async {
  // iOSでは横画面にする
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.device.setPortrait();
    await Flame.device.fullScreen();
  }
  // アセットからSpriteSheetを生成
  await PlayerSpriteSheet.load(); // ←追加
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Message Quest',
      debugShowCheckedModeBanner: false,
      home: StartMap(),
    );
  }
}