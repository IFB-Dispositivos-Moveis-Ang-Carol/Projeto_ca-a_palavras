import 'package:flutter/material.dart';
import 'word_search_logic.dart';
import 'home_screen.dart';

class WordSearchScreen extends StatefulWidget {
  final String difficulty;
  WordSearchScreen(this.difficulty);

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

  @override
  void initState() {
    super.initState();
    _setGridSize();
    _setWords();
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

  void _setWords() {
    if (widget.difficulty == 'Facil') {
      words = ['SOL', 'LUZ', 'MAR', 'FLOR'];
    } else if (widget.difficulty == 'Medio') {
      words = ['CAVALO', 'TIGRE', 'CACHORRO', 'GATO'];
    } else {
      words = ['ELEFANTE', 'DINOSSAURO', 'BORBOLETA', 'CROCODILO'];
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
        foundWords.add(selectedWord);
        words.remove(selectedWord);
        selectedPositions.clear();
      }

      if (words.isEmpty) {
        _showLevelCompleteDialog();
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedPositions.clear();
    });
  }

  void _showLevelCompleteDialog() {
    String nextLevel = '';
    if (widget.difficulty == 'Facil') {
      nextLevel = 'Medio';
    } else if (widget.difficulty == 'Medio') {
      nextLevel = 'Dificil';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Parabéns!'),
        content: Text(widget.difficulty == 'Dificil'
            ? 'Você completou o jogo! Deseja jogar novamente?'
            : 'Você completou esse nível! Deseja avançar para o próximo nível?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.difficulty == 'Dificil') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WordSearchScreen(nextLevel)),
                );
              }
            },
            child: Text('Sim'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.difficulty == 'Facil') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else if (widget.difficulty == 'Medio') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
              if (widget.difficulty == 'Dificil') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
            },
            child: Text('Não'),
          ),
        ],
      ),
    );
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
            onPressed: _clearSelection,
            tooltip: 'Limpar Seleção',
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text('Encontre as palavras:', style: TextStyle(fontSize: 18)),
          Wrap(
            spacing: 10,
            children: words.map((word) => Text(
              word,
              style: TextStyle(
                fontSize: 18,
                decoration: foundWords.contains(word) ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            )).toList(),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
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
                    child: Center(
                      child: Text(
                        grid[row][col],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: foundWords.contains(grid[row][col]) ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
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