import 'dart:math';

List<List<String>> generateGrid(int gridHeight, int gridWidth, List<String> words) {
  List<List<String>> grid = List.generate(gridHeight, (_) => List.generate(gridWidth, (_) => ' '));
  Random random = Random();
  Map<String, List<int>> wordPositions = {};

  for (String word in words) {
    bool placed = false;
    while (!placed) {
      bool placeHorizontally = random.nextBool(); // Define se a palavra será colocada horizontalmente ou verticalmente
      int row, col;
      if (placeHorizontally) {
        row = random.nextInt(gridHeight);
        col = random.nextInt(gridWidth - word.length);
      } else {
        row = random.nextInt(gridHeight - word.length);
        col = random.nextInt(gridWidth);
      }
      
      bool canPlace = true;
      List<int> positions = [];
      for (int i = 0; i < word.length; i++) {
        int currentRow = placeHorizontally ? row : row + i;
        int currentCol = placeHorizontally ? col + i : col;
        if (grid[currentRow][currentCol] != ' ' && grid[currentRow][currentCol] != word[i]) {
          canPlace = false;
          break;
        }
        positions.add(currentRow * gridWidth + currentCol);
      }
      
      if (canPlace) {
        for (int i = 0; i < word.length; i++) {
          int currentRow = placeHorizontally ? row : row + i;
          int currentCol = placeHorizontally ? col + i : col;
          grid[currentRow][currentCol] = word[i];
        }
        wordPositions[word] = positions;
        placed = true;
      }
    }
  }

  for (int i = 0; i < gridHeight; i++) {
    for (int j = 0; j < gridWidth; j++) {
      if (grid[i][j] == ' ') {
        grid[i][j] = String.fromCharCode(random.nextInt(26) + 65);
      }
    }
  }

  return grid;
}

List<String> getWordsForDifficulty(String difficulty) {
  if (difficulty == 'Facil') {
    return ['SOL', 'LUZ', 'MAR', 'FLOR', 'ARCO'];
  } else if (difficulty == 'Medio') {
    return ['CAVALO', 'TIGRE', 'CACHORRO', 'GATO', 'URSO', 'RAPOSA', 'LOBO'];
  } else {
    return ['ELEFANTE', 'DINOSSAURO', 'BORBOLETA', 'CROCODILO', 'GIRAFA', 'TARTARUGA', 'PANTERA', 'GORILA', 'LEOPARDO'];
  }
}