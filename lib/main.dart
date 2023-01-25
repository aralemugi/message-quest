import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:message_quest/maps/start_map.dart';
import 'package:message_quest/mob/cat_sprite.dart';
import 'package:message_quest/mob/rabbit_sprite.dart';
import 'package:message_quest/npc/bride_sprite.dart';
import 'package:message_quest/npc/groom_sprite.dart';
import 'package:message_quest/npc/maid_sprite.dart';
import 'package:message_quest/player/player_beared_dude_controller.dart';
import 'package:message_quest/player/player_sprite.dart';

void main() async {
  // iOSでは横画面にする
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Flame.device.setPortrait();
    await Flame.device.fullScreen();
  }

  // アセットからSpriteSheetを生成
  await PlayerSpriteSheet.load();
  await MaidSprite.load();
  await CatSprite.load();
  await GroomSprite.load();
  await BrideSprite.load();
  await RabbitSprite.load();

  // controllerをゲーム内どこからでもシングルトンとして扱えるようにする
  BonfireInjector().put((i) => BearedDudeController());

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