import 'package:flutter/material.dart';
import 'word_search_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 150, // Diminuindo a altura da barra para aproximar os elementos
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Reduzindo padding para mais proximidade
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.4),
                  spreadRadius: 4,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Caça-Palavras',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5), // Reduzindo o espaço entre o título e o subtítulo
                Text(
                  'By: Ângelo e Carol',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Evita espaços desnecessários entre os elementos
          children: [
            SizedBox(height: 5), // Reduzindo espaço entre o título e a seleção de dificuldade
            Text(
              'Escolha o modo de jogo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5), // Reduzindo espaço extra
            ElevatedButton(
              onPressed: () => _chooseGameMode(context, 'Facil'),
              child: Text('Fácil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 5), // Aproximando botões
            ElevatedButton(
              onPressed: () => _chooseGameMode(context, 'Medio'),
              child: Text('Médio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 5), // Aproximando botões
            ElevatedButton(
              onPressed: () => _chooseGameMode(context, 'Dificil'),
              child: Text('Difícil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _chooseGameMode(BuildContext context, String difficulty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modo de Jogo'),
        content: Text('Escolha se deseja jogar sozinho ou com um amigo.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame(context, difficulty, false);
            },
            child: Text('1 Jogador'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame(context, difficulty, true);
            },
            child: Text('2 Jogadores'),
          ),
        ],
      ),
    );
  }

  void _startGame(BuildContext context, String difficulty, bool isTwoPlayers) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WordSearchScreen(difficulty, isTwoPlayers)),
    );
  }
}
