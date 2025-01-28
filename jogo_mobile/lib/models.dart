class Word {
  final String text;
  final List<int> positions;

  Word(this.text, this.positions);
}

class SelectedWord {
  List<int> selectedPositions = [];

  void addPosition(int position) {
    if (!selectedPositions.contains(position)) {
      selectedPositions.add(position);
    }
  }

  bool matchesWord(Word word) {
    return selectedPositions.length == word.positions.length &&
        selectedPositions.every((pos) => word.positions.contains(pos));
  }

  void clear() {
    selectedPositions.clear();
  }
}
