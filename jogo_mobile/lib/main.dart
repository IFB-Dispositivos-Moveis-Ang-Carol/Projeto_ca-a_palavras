import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(WordSearchGame());
}

class WordSearchGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caça-Palavras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordSearchScreen(),
    );
  }
}

class WordSearchScreen extends StatefulWidget {
  @override
  _WordSearchScreenState createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  final int gridSize = 16; // Tamanho do grid: 16x16
  final List<String> words = ['FLUTTER', 'DART', 'CODIGO', 'APP', 'MOBILE', 'DESIGN', 'LOGIC', 'FRONTEND'];
  late List<List<String>> grid;
  List<List<int>> selectedPositions = [];
  List<String> foundWords = [];
  List<List<List<int>>> foundLettersPositions = []; // Armazena as posições das palavras encontradas

  @override
  void initState() {
    super.initState();
    _generateGrid();
  }

  void _generateGrid() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, ' ', growable: false));
    _placeWords();
    _fillEmptySpaces();
  }

  void _placeWords() {
    var random = Random();
    const directions = [
      [0, 1], // Horizontal direita
      [1, 0], // Vertical para baixo
      [1, 1], // Diagonal para baixo direita
      [0, -1], // Horizontal esquerda
      [-1, 0], // Vertical para cima
      [-1, -1], // Diagonal para cima esquerda
      [1, -1], // Diagonal para baixo esquerda
      [-1, 1], // Diagonal para cima direita
    ];

    for (var word in words) {
      bool placed = false;

      while (!placed) {
        int row = random.nextInt(gridSize);
        int col = random.nextInt(gridSize);
        var direction = directions[random.nextInt(directions.length)];

        if (_canPlaceWord(word, row, col, direction)) {
          _writeWord(word, row, col, direction);
          placed = true;
        }
      }
    }
  }

  bool _canPlaceWord(String word, int row, int col, List<int> direction) {
    for (int i = 0; i < word.length; i++) {
      int newRow = row + i * direction[0];
      int newCol = col + i * direction[1];

      if (newRow < 0 || newRow >= gridSize || newCol < 0 || newCol >= gridSize) {
        return false;
      }

      if (grid[newRow][newCol] != ' ' && grid[newRow][newCol] != word[i]) {
        return false;
      }
    }
    return true;
  }

  void _writeWord(String word, int row, int col, List<int> direction) {
    for (int i = 0; i < word.length; i++) {
      int newRow = row + i * direction[0];
      int newCol = col + i * direction[1];
      grid[newRow][newCol] = word[i];
    }
  }

  void _fillEmptySpaces() {
    var random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == ' ') {
          grid[i][j] = letters[random.nextInt(letters.length)];
        }
      }
    }
  }

  void _onLetterTap(int row, int col) {
    if (selectedPositions.any((pos) => pos[0] == row && pos[1] == col)) {
      return; // Evita selecionar a mesma letra duas vezes
    }

    setState(() {
      selectedPositions.add([row, col]);

      String currentWord = selectedPositions
          .map((pos) => grid[pos[0]][pos[1]])
          .join('');

      // Validação para só colorir a palavra encontrada
      if (words.contains(currentWord) && !foundWords.contains(currentWord)) {
        foundWords.add(currentWord);
        foundLettersPositions.add(List.from(selectedPositions)); // Adiciona as posições da palavra encontrada
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Encontrou a palavra: $currentWord')),
        );

        // Limpa seleção após encontrar uma palavra
        selectedPositions.clear();

        // Verifica se todas as palavras foram encontradas
        if (foundWords.length == words.length) {
          _showWinDialog();
        }
      } else if (selectedPositions.length >= gridSize) {
        // Se a seleção exceder o tamanho permitido, limpa-a
        selectedPositions.clear();
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Parabéns!'),
          content: Text('Você encontrou todas as palavras!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _generateGrid();
                  foundWords.clear();
                  foundLettersPositions.clear();
                  selectedPositions.clear();
                });
              },
              child: Text('Jogar novamente'),
            ),
          ],
        );
      },
    );
  }

  void _clearSelection() {
    setState(() {
      selectedPositions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Reduz o tamanho do quadrado proporcionalmente para que tudo caiba no grid expandido.
    double gridSquareSize = MediaQuery.of(context).size.width / gridSize;

    return Scaffold(
      appBar: AppBar(title: Text('Caça-Palavras')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                int row = index ~/ gridSize;
                int col = index % gridSize;

                // Verifica se a célula é parte de uma palavra encontrada
                bool isFound = foundLettersPositions.any((positions) =>
                    positions.any((pos) => pos[0] == row && pos[1] == col));

                // Verifica se a célula está sendo temporariamente selecionada
                bool isSelected = selectedPositions
                    .any((pos) => pos[0] == row && pos[1] == col);

                return GestureDetector(
                  onTap: () => _onLetterTap(row, col),
                  child: Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green // Temporariamente selecionado
                          : (isFound ? Colors.orange : Colors.blueAccent), // Parte de palavra encontrada
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: gridSquareSize,
                    height: gridSquareSize,
                    child: Center(
                      child: Text(
                        grid[row][col],
                        style: TextStyle(
                          fontSize: gridSquareSize / 2.5, // Fonte proporcional ao tamanho do bloco
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Palavras para encontrar: ${words.join(", ")}',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: _clearSelection,
            child: Text('Limpar Seleção'),
          ),
        ],
      ),
    );
  }
}
