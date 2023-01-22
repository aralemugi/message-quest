abstract class GameItem {
  GameItem({required this.imagePath, required this.name});
  String imagePath;
  String name;
}

class Letter extends GameItem {
  Letter()
      : super(
    imagePath: 'objects/letter.png',
    name: '招待状',
  );
}

