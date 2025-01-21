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
  final int gridRows = 14; // 14 linhas
  final int gridColumns = 40; // 40 colunas
  final List<String> words = [
    'ANGELO',
    'CAROL',
    'CODIGO',
    'APP',
    'MOBILE',
    'DESENVOLVER',
    'LOGICA',
    'JOGO',
    'PALAVRAS',
  ];
  late List<List<String>> grid;
  List<List<int>> selectedPositions = [];
  List<String> foundWords = [];
  List<List<List<int>>> foundLettersPositions = []; // Armazena as posições das palavras encontradas
  bool isTitleHovered = false; // Controla a animação do título

  @override
  void initState() {
    super.initState();
    _generateGrid();
  }

  void _generateGrid() {
    grid = List.generate(gridRows, (_) => List.filled(gridColumns, ' ', growable: false));
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
        int row = random.nextInt(gridRows);
        int col = random.nextInt(gridColumns);
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

      // Certifica-se de que não sairá do grid
      if (newRow < 0 || newRow >= gridRows || newCol < 0 || newCol >= gridColumns) {
        return false;
      }

      // Certifica-se de que não haja conflito de letras
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
    for (int i = 0; i < gridRows; i++) {
      for (int j = 0; j < gridColumns; j++) {
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

      if (words.contains(currentWord) && !foundWords.contains(currentWord)) {
        foundWords.add(currentWord);
        foundLettersPositions.add(List.from(selectedPositions)); // Adiciona a palavra encontrada
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Encontrou a palavra: $currentWord')),
        );

        selectedPositions.clear();

        // Verifica se todas as palavras foram encontradas
        if (foundWords.length == words.length) {
          _showWinDialog();
        }
      } else if (selectedPositions.length > max(gridRows, gridColumns)) {
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
    // Calcula o tamanho do quadrado de forma responsiva
    double gridSquareSize = MediaQuery.of(context).size.width / gridColumns;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: MouseRegion(
          onEnter: (_) {
            setState(() {
              isTitleHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              isTitleHovered = false;
            });
          },
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              decoration: BoxDecoration(
                color: isTitleHovered ? Colors.blueAccent : Colors.lightBlue,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  if (isTitleHovered)
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
      ),
      body: Column(
        children: [
          Flexible(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridColumns,
              ),
              itemCount: gridRows * gridColumns,
              itemBuilder: (context, index) {
                int row = index ~/ gridColumns;
                int col = index % gridColumns;

                bool isFound = foundLettersPositions.any((positions) =>
                    positions.any((pos) => pos[0] == row && pos[1] == col));
                bool isSelected = selectedPositions
                    .any((pos) => pos[0] == row && pos[1] == col);

                return GestureDetector(
                  onTap: () => _onLetterTap(row, col),
                  child: Container(
                    margin: EdgeInsets.all(0.5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green
                          : (isFound ? Colors.orange : Colors.blueAccent),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        grid[row][col],
                        style: TextStyle(
                          fontSize: gridSquareSize / 2.5,
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
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(children: [
              LinearProgressIndicator(
                value: foundWords.length / words.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: words.map((word) {
                  bool isFound = foundWords.contains(word);
                  return Text(
                    word,
                    style: TextStyle(
                      decoration: isFound ? TextDecoration.lineThrough : null,
                      color: isFound ? Colors.green : Colors.black,
                      fontSize: 16,
                    ),
                  );
                }).toList(),
              ),
            ]),
          ),
          ElevatedButton(
            onPressed: _clearSelection,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              textStyle: TextStyle(fontSize: 16),
            ),
            child: Text('Limpar Seleção'),
          ),
        ],
      ),
    );
  }
}
