import 'package:flutter/material.dart';
import 'word_search_logic.dart'; // Certifique-se de que esse arquivo tem a função getWordsForDifficulty
import 'home_screen.dart';

class WordSearchScreen extends StatefulWidget {
  final String difficulty;
  final bool isTwoPlayers;

  WordSearchScreen(this.difficulty, this.isTwoPlayers);

  @override
  _WordSearchScreenState createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  late List<String> words;
  late List<List<String>> grid;
  late int gridHeight;
  late int gridWidth;
  List<int> selectedPositions = [];
  List<String> foundWords = [];
  int player1Score = 0;
  int player2Score = 0;

  @override
  void initState() {
    super.initState();
    _setGridSize();
    words = getWordsForDifficulty(widget.difficulty); // Corrigido
    grid = generateGrid(gridHeight, gridWidth, words);
  }

  void _setGridSize() {
    if (widget.difficulty == 'Facil') {
      gridHeight = 10;
      gridWidth = 26;
    } else if (widget.difficulty == 'Medio') {
      gridHeight = 12;
      gridWidth = 31;
    } else {
      gridHeight = 14;
      gridWidth = 36;
    }
  }

  void _selectLetter(int index) {
    setState(() {
      if (selectedPositions.contains(index)) {
        selectedPositions.remove(index);
      } else {
        selectedPositions.add(index);
      }

      String selectedWord = selectedPositions.map((pos) {
        int row = pos ~/ gridWidth;
        int col = pos % gridWidth;
        return grid[row][col];
      }).join('');

      if (words.contains(selectedWord)) {
        _assignPoint(selectedWord);
        foundWords.add(selectedWord);
        words.remove(selectedWord);
        selectedPositions.clear();
      }

      if (words.isEmpty) {
        Future.delayed(Duration(milliseconds: 4000), () {
          _showWinnerDialog();
        });
      }
    });
  }

  void _assignPoint(String word) {
    if (widget.isTwoPlayers) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Palavra Encontrada!'),
          content: Text('Quem encontrou a palavra "$word"?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  player1Score++;
                });
                Navigator.pop(context);
              },
              child: Text('Jogador 1'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  player2Score++;
                });
                Navigator.pop(context);
              },
              child: Text('Jogador 2'),
            ),
          ],
        ),
      );
    }
  }

  void _showWinnerDialog() {
    String winner;
    if (player1Score > player2Score) {
      winner = "Jogador 1 venceu!";
    } else if (player2Score > player1Score) {
      winner = "Jogador 2 venceu!";
    } else {
      winner = "Empate!";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fim do jogo!'),
        content: Text(widget.isTwoPlayers ? '$winner' : 'Parabéns! Você encontrou todas as palavras!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextLevel();
            },
            child: Text('Avançar'),
          ),
        ],
      ),
    );
  }

  void _nextLevel() {
    String nextLevel = widget.difficulty == 'Facil'
        ? 'Medio'
        : widget.difficulty == 'Medio'
            ? 'Dificil'
            : 'Fim';

    if (nextLevel == 'Fim') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WordSearchScreen(nextLevel, widget.isTwoPlayers)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tileSize = screenWidth / (gridWidth + 2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Caça Palavras - ${widget.difficulty}'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => setState(() => selectedPositions.clear()),
            tooltip: 'Limpar Seleção',
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.isTwoPlayers)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Jogador 1: $player1Score | Jogador 2: $player2Score',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: words.map((word) => Text(word, style: TextStyle(fontSize: 18))).toList(),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridWidth,
                childAspectRatio: 1.0,
              ),
              itemCount: gridHeight * gridWidth,
              itemBuilder: (context, index) {
                int row = index ~/ gridWidth;
                int col = index % gridWidth;
                bool isSelected = selectedPositions.contains(index);

                return GestureDetector(
                  onTap: () => _selectLetter(index),
                  child: Container(
                    width: tileSize,
                    height: tileSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.white,
                    ),
                    child: Center(child: Text(grid[row][col], style: TextStyle(fontSize: 20))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
