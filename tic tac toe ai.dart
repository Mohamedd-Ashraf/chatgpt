
import 'dart:math';

import 'package:flutter/cupertino.dart';

void main() {
  Map<String, dynamic> position = {
    'board': List.filled(9, List.filled(9, 0)),
    'nextBoard': -1,
    'winner': -1,
    'turn': 1
  };
  while (true) {
    print(position);
    print('Next board: ${position['nextBoard']}');
    print('Enter your move:');
    String input = stdin.readLineSync()!;
    int move = int.parse(input);
    if (!makeMove(position, move)) {
      print('Invalid move!');
      continue;
    }
    if (position['winner'] != -1) {
      print('Game over!');
      break;
    }
    if (position['turn'] == 1) {
      move = findBestMove(position, 3);
      makeMove(position, move);
      print('Computer plays $move');
      if (position['winner'] != -1) {
        print('Game over!');
        break;
      }
    }
  }
}
// Function to make a move on the board
bool makeMove(Map<String, dynamic> position, int move) {
  if (position['winner'] != -1 || position['board'][move ~/ 9][move % 9] != 0 ||
      (position['nextBoard'] != -1 && position['nextBoard'] != move % 9)) {
    return false;
  }
  position['board'][move ~/ 9][move % 9] = position['turn'];
  int win = checkWinCondition(position['board'][move % 9]);
  if (win != -1) {
    position['boardToPlayOn'][move % 9] = win;
    if (checkWinCondition(position['boardToPlayOn']) != -1) {
      position['winner'] = checkWinCondition(position['boardToPlayOn']);
      return true;
    }
    position['nextBoard'] = -1;
  } else {
    if (checkWinCondition(position['board'][move % 9]) != -1) {
      position['nextBoard'] = move % 9;
    } else {
      position['nextBoard'] = -1;
    }
  }
  position['turn'] = 3 - position['turn'];
  return true;
}


int evaluatePos(int pos, List<List<int>> square) {
  int score = 0;
  int row = (pos / 9).floor();
  int col = pos % 9;
  int baseRow = (row / 3).floor() * 3;
  int baseCol = (col / 3).floor() * 3;
  for (int i = 0; i < 3; i++) {
    if (square[baseRow + i][baseCol] == square[baseRow + i][baseCol + 1] && square[baseRow + i][baseCol + 1] == square[baseRow + i][baseCol + 2]) {
      score += square[baseRow + i][baseCol] == currentPlayer ? 3 : -2;
    }
    if (square[baseRow][baseCol + i] == square[baseRow + 1][baseCol + i] && square[baseRow + 1][baseCol + i] == square[baseRow + 2][baseCol + i]) {
      score += square[baseRow][baseCol + i] == currentPlayer ? 3 : -2;
    }
  }
  if (square[baseRow][baseCol] == square[baseRow + 1][baseCol + 1] && square[baseRow + 1][baseCol + 1] == square[baseRow + 2][baseCol + 2]) {
    score += square[baseRow][baseCol] == currentPlayer ? 3 : -2;
  }
  if (square[baseRow][baseCol + 2] == square[baseRow + 1][baseCol + 1] && square[baseRow + 1][baseCol + 1] == square[baseRow + 2][baseCol]) {
    score += square[baseRow][baseCol + 2] == currentPlayer ? 3 : -2;
  }
  return score;
}

double miniMax(Map<String, dynamic> position, int boardToPlayOn, int depth, double alpha, double beta, bool maximizingPlayer) {
  if (depth == 0 || position['winner'] != null
) {
int score = evaluateGame(position, position['board']);
return score.toDouble();
}

List<int> availableMoves = getAvailableMoves(position, boardToPlayOn);
if (availableMoves.isEmpty) {
return 0;
}

if (maximizingPlayer) {
double maxScore = -double.infinity;
for (int move in availableMoves) {
Map<String, dynamic> nextPosition = getNextPosition(position, boardToPlayOn, move);
double score = miniMax(nextPosition, move, depth - 1, alpha, beta, false);
maxScore = max(maxScore, score);
alpha = max(alpha, score);
if (beta <= alpha) {
break;
}
}
return maxScore;
} else {
double minScore = double.infinity;
for (int move in availableMoves) {
Map<String, dynamic> nextPosition = getNextPosition(position, boardToPlayOn, move);
double score = miniMax(nextPosition, move, depth - 1, alpha, beta, true);
minScore = min(minScore, score);
beta = min(beta, score);
if (beta <= alpha) {
break;
}
}
return minScore;
}
}

int evaluateGame(Map<String, dynamic> position, List<List<int>> currentBoard) {
int score = 0;
for (int i = 0; i < 9; i++) {
int squareScore = evaluatePos(i, currentBoard);
score += squareScore;
}
return score;
}

List<int> getAvailableMoves(Map<String, dynamic> position, int boardToPlayOn) {
List<int> availableMoves = [];
for (int i = 0; i < 9; i++) {
if (position['winner'] != null) {
break;
}
if (i != boardToPlayOn && position['board'][boardToPlayOn][i] == null) {
availableMoves.add(i);
}
}
return availableMoves;
}

Map<String, dynamic> getNextPosition(Map<String, dynamic> position, int boardToPlayOn, int move) {
List<List<int>> newBoard = position['board'].map((row) => List.from(row)).toList();
int currentPlayer = position['currentPlayer'];
newBoard[boardToPlayOn][move] = currentPlayer;
Map<String, dynamic> nextPosition = {'board': newBoard, 'winner': null, 'currentPlayer': currentPlayer};
int row = (move / 9).floor();
int col = move % 9;
int baseRow = (row / 3).floor() * 3;
int baseCol = (col / 3).floor() * 3;
if (checkWinCondition(newBoard[boardToPlayOn].sublist(baseCol, baseCol + 3))) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition(newBoard[boardToPlayOn].sublist(baseCol + 3, baseCol + 6))) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition(newBoard[boardToPlayOn].sublist(baseCol + 6, baseCol + 9))) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition([newBoard[boardToPlayOn][baseCol], newBoard[boardToPlayOn][baseCol + 1], newBoard[boardToPlayOn][baseCol + 2]])) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition([newBoard[boardToPlayOn][baseCol + 3], newBoard[boardToPlayOn][baseCol + 4], newBoard[boardToPlayOn][baseCol + 5]])) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition([newBoard[boardToPlayOn][baseCol + 6], newBoard[boardToPlayOn][baseCol + 7], newBoard[boardToPlayOn][baseCol + 8]])) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition([newBoard[boardToPlayOn][baseRow + 0], newBoard[boardToPlayOn][baseRow + 1], newBoard[boardToPlayOn][baseRow + 2]])) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition([newBoard[boardToPlayOn][baseRow + 3], newBoard[boardToPlayOn][baseRow + 4], newBoard[boardToPlayOn][baseRow + 5]])) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition([newBoard[boardToPlayOn][baseRow + 6], newBoard[boardToPlayOn][baseRow + 7], newBoard[boardToPlayOn][baseRow + 8]])) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition([newBoard[boardToPlayOn][0], newBoard[boardToPlayOn][4], newBoard[boardToPlayOn][8]])) {
nextPosition['winner'] = currentPlayer;
} else if (checkWinCondition([newBoard[boardToPlayOn][2], newBoard[boardToPlayOn][4], newBoard[boardToPlayOn][6]])) {
nextPosition['winner'] = currentPlayer;
} else {
bool isTie = true;
for (int i = 0; i < 9; i++) {
for (int j = 0; j < 9; j++) {
if (newBoard[i][j] == null) {
isTie = false;
break;
}
}
}
if (isTie) {
nextPosition['winner'] = -1;
} else {
nextPosition['currentPlayer'] = 3 - currentPlayer;
}
}
return nextPosition;
}

bool checkWinCondition(List<int> map) {
if (map[0] == map[1] && map[1] == map[2] && map[0] != null) {
return true;
}
return false;
}

int getWinner(Map<String, dynamic> position) {
int winner = position['winner'];
if (winner == null) {
winner = realEvaluate(position, position['board']);
}
return winner;
}double realEvaluate(Map<String, dynamic> position, List<List<int>> board) {
double score = 0;
for (int i = 0; i < 9; i++) {
for (int j = 0; j < 9; j++) {
if (board[i][j] != null) {
int square = (i ~/ 3) * 3 + (j ~/ 3);
score += evaluatePos(position, square, i % 3, j % 3) * (board[i][j] == 1 ? 1 : -1);
}
}
}
return score;
}

double evaluatePos(Map<String, dynamic> position, int square, int row, int col) {
double score = 0;
for (int i = 0; i < 3; i++) {
for (int j = 0; j < 3; j++) {
int val = position['board'][square * 3 + i][square * 3 + j];
if (val == 1) {
score += evaluateSquare(position, square, i, j);
} else if (val == 2) {
score -= evaluateSquare(position, square, i, j);
}
}
}
return score;
}

double evaluateSquare(Map<String, dynamic> position, int square, int row, int col) {
double score = 0;
int currentPlayer = position['currentPlayer'];
int opponentPlayer = 3 - currentPlayer;
if (position['board'][square * 3 + row][square * 3 + col] != null) {
return score;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 0], position['board'][square * 3 + 0][square * 3 + 1], position['board'][square * 3 + 0][square * 3 + 2]])) {
return currentPlayer == 1 ? 100 : -100;
}
if (checkWinCondition([position['board'][square * 3 + 1][square * 3 + 0], position['board'][square * 3 + 1][square * 3 + 1], position['board'][square * 3 + 1][square * 3 + 2]])) {
return currentPlayer == 1 ? 100 : -100;
}
if (checkWinCondition([position['board'][square * 3 + 2][square * 3 + 0], position['board'][square * 3 + 2][square * 3 + 1], position['board'][square * 3 + 2][square * 3 + 2]])) {
return currentPlayer == 1 ? 100 : -100;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 0], position['board'][square * 3 + 1][square * 3 + 0], position['board'][square * 3 + 2][square * 3 + 0]])) {
return currentPlayer == 1 ? 100 : -100;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 1], position['board'][square * 3 + 1][square * 3 + 1], position['board'][square * 3 + 2][square * 3 + 1]])) {
return currentPlayer == 1 ?
100 : -100;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 2], position['board'][square * 3 + 1][square * 3 + 2], position['board'][square * 3 + 2][square * 3 + 2]])) {
return currentPlayer == 1 ? 100 : -100;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 0], position['board'][square * 3 + 1][square * 3 + 1], position['board'][square * 3 + 2][square * 3 + 2]])) {
return currentPlayer == 1 ? 100 : -100;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 2], position['board'][square * 3 + 1][square * 3 + 1], position['board'][square * 3 + 2][square * 3 + 0]])) {
return currentPlayer == 1 ? 100 : -100;
}
score += realEvaluateSquare(position, square) * (currentPlayer == 1 ? 1 : -1);
score += realEvaluateSquare(position, square, opponentPlayer) * (currentPlayer == 1 ? -1 : 1);
return score;
}

double realEvaluateSquare(Map<String, dynamic> position, int square, [int player]) {
player ??= position['currentPlayer'];
int opponentPlayer = 3 - player;
double score = 0;
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 0], position['board'][square * 3 + 0][square * 3 + 1], position['board'][square * 3 + 0][square * 3 + 2]], player)) {
score += 10;
}
if (checkWinCondition([position['board'][square * 3 + 1][square * 3 + 0], position['board'][square * 3 + 1][square * 3 + 1], position['board'][square * 3 + 1][square * 3 + 2]], player)) {
score += 10;
}
if (checkWinCondition([position['board'][square * 3 + 2][square * 3 + 0], position['board'][square * 3 + 2][square * 3 + 1], position['board'][square * 3 + 2][square * 3 + 2]], player)) {
score += 10;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 0], position['board'][square * 3 + 1][square * 3 + 0], position['board'][square * 3 + 2][square * 3 + 0]], player)) {
score += 10;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 1], position['board'][square * 3 + 1][square * 3 + 1], position['board'][square * 3 + 2][square * 3 + 1]], player)) {
score += 10;
}
if (checkWinCondition([position['board'][square * 3 +0][square * 3 + 2], position['board'][square * 3 + 1][square * 3 + 2], position['board'][square * 3 + 2][square * 3 + 2]], player)) {
score += 10;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 0], position['board'][square * 3 + 1][square * 3 + 1], position['board'][square * 3 + 2][square * 3 + 2]], player)) {
score += 10;
}
if (checkWinCondition([position['board'][square * 3 + 0][square * 3 + 2], position['board'][square * 3 + 1][square * 3 + 1], position['board'][square * 3 + 2][square * 3 + 0]], player)) {
score += 10;
}
score += countPossibleWins(position, square, player) * 5;
score += countPossibleWins(position, square, opponentPlayer) * 3;
score += countPossibleLines(position, square, player) * 2;
score += countPossibleLines(position, square, opponentPlayer) * 1;
score += countPossibleForks(position, square, player) * 2;
score += countPossibleForks(position, square, opponentPlayer) * 1;
return score;
}

int countPossibleWins(Map<String, dynamic> position, int square, int player) {
int count = 0;
if (position['board'][square * 3 + 0][square * 3 + 0] == player && position['board'][square * 3 + 0][square * 3 + 1] == player && position['board'][square * 3 + 0][square * 3 + 2] == 0) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 0] == player && position['board'][square * 3 + 0][square * 3 + 1] == 0 && position['board'][square * 3 + 0][square * 3 + 2] == player) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 0] == 0 && position['board'][square * 3 + 0][square * 3 + 1] == player && position['board'][square * 3 + 0][square * 3 + 2] == player) {
count++;
}
if (position['board'][square * 3 + 1][square * 3 + 0] == player && position['board'][square * 3 + 1][square * 3 + 1] == player && position['board'][square * 3 + 1][square * 3 + 2] == 0) {
count++;
}
if (position['board'][square * 3 + 1][square * 3 + 0] == player && position['board'][square * 3 + 1][square * 3 + 1] == 0 && position['board'][square * 3 + 1][square * 3 + 2] == player) {
count++;
}
if (position['board'][square * 3 + 1][square * 3 + 0] ==0 && position['board'][square * 3 + 1][square * 3 + 1] == player && position['board'][square * 3 + 1][square * 3 + 2] == player) {
count++;
}
if (position['board'][square * 3 + 2][square * 3 + 0] == player && position['board'][square * 3 + 2][square * 3 + 1] == player && position['board'][square * 3 + 2][square * 3 + 2] == 0) {
count++;
}
if (position['board'][square * 3 + 2][square * 3 + 0] == player && position['board'][square * 3 + 2][square * 3 + 1] == 0 && position['board'][square * 3 + 2][square * 3 + 2] == player) {
count++;
}
if (position['board'][square * 3 + 2][square * 3 + 0] == 0 && position['board'][square * 3 + 2][square * 3 + 1] == player && position['board'][square * 3 + 2][square * 3 + 2] == player) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 0] == player && position['board'][square * 3 + 1][square * 3 + 0] == player && position['board'][square * 3 + 2][square * 3 + 0] == 0) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 0] == player && position['board'][square * 3 + 1][square * 3 + 0] == 0 && position['board'][square * 3 + 2][square * 3 + 0] == player) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 0] == 0 && position['board'][square * 3 + 1][square * 3 + 0] == player && position['board'][square * 3 + 2][square * 3 + 0] == player) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 1] == player && position['board'][square * 3 + 1][square * 3 + 1] == player && position['board'][square * 3 + 2][square * 3 + 1] == 0) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 1] == player && position['board'][square * 3 + 1][square * 3 + 1] == 0 && position['board'][square * 3 + 2][square * 3 + 1] == player) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 1] == 0 && position['board'][square * 3 + 1][square * 3 + 1] == player && position['board'][square * 3 + 2][square * 3 + 1] == player) {
count++;
}
ifposition['board'][square * 3 + 0][square * 3 + 2] == player && position['board'][square * 3 + 1][square * 3 + 2] == player && position['board'][square * 3 + 2][square * 3 + 2] == 0) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 2] == player && position['board'][square * 3 + 1][square * 3 + 2] == 0 && position['board'][square * 3 + 2][square * 3 + 2] == player) {
count++;
}
if (position['board'][square * 3 + 0][square * 3 + 2] == 0 && position['board'][square * 3 + 1][square * 3 + 2] == player && position['board'][square * 3 + 2][square * 3 + 2] == player) {
count++;
}
return count;
}

int evaluatePos(Map<String, dynamic> position, int square) {
int oppSquare = (square + 4) % 9;
int score = 0;
score += realEvaluateSquare(position, square, 1); //we are 1
score -= realEvaluateSquare(position, oppSquare, 1); //opp is -1
score += realEvaluateSquare(position, square, -1);
score -= realEvaluateSquare(position, oppSquare, -1);
return score;
}

Map<String, dynamic> miniMax(Map<String, dynamic> position, int boardToPlayOn, int depth, int alpha, int beta, bool maximizingPlayer) {
int currentPlayer = maximizingPlayer ? 1 : -1;
int bestMove = -1;
int value;

if (depth == 0 || checkWinCondition(position['map']) != null || checkWinCondition(position['board'][boardToPlayOn]) != null) {
return {'move': bestMove, 'score': realEvaluate(position, boardToPlayOn)};
}

List<int> availableMoves = [];
for (int i = 0; i < 81; i++) {
if (position['board'][boardToPlayOn][i ~/ 9][i % 9 % 9] == 0 && position['map'][i ~/ 27][i % 9 ~/ 3] == boardToPlayOn) {
availableMoves.add(i);
}
}

if (maximizingPlayer) {
value = -999999;
for (int i = 0; i < availableMoves.length; i++) {
int move = availableMoves[i];
int newBoardToPlayOn = move % 9;
Map<String, dynamic> newPosition = makeMove(position, move ~/ 9, move % 9 % 9, currentPlayer);  Map<String, dynamic> mmResult = miniMax(newPosition, newBoardToPlayOn, depth - 1, alpha, beta, false);
  if (mmResult['score'] > value) {
    value = mmResult['score'];
    bestMove = move;
  }
  alpha = alpha > value ? alpha : value;
  if (beta <= alpha) {
    break;
  }
}
} else {
value = 999999;
for (int i = 0; i < availableMoves.length; i++) {
int move = availableMoves[i];
int newBoardToPlayOn = move % 9; Map<String, dynamic> newPosition = makeMove(position, move ~/ 9, move % 9 % 9, currentPlayer);
  Map<String, dynamic> mmResult = miniMax(newPosition, newBoardToPlayOn, depth - 1, alpha, beta, true);
  if (mmResult['score'] < value) {
    value = mmResult['score'];
    bestMove = move;
  }
  beta = beta < value ? beta : value;
  if (beta <= alpha) {
    break;
  }
}}

return {'move': bestMove, 'score': value};
}

int evaluateGame(Map<String, dynamic> position, int currentBoard) {
int score = 0;
for (int i = 0; i < 9; i++) {
if (i == currentBoard) {
score += evaluatePos(position, i) * 2;
} else {
score += evaluatePos(position, i);
}
}
return score;
}

String checkWinCondition(List<List<int>> map) {
String winner = null;
for (int i = 0; i < 3; i++) {
if (map[i][0] == map[i][1] && map[i][1] == map[i][2] && map[i][0] != -1) {
if (winner != null && winner != map[i][0].toString()) {
return null;
}
winner = map[i][0].toString();
}
if (map[0][i] == map[1][i] && map[1][i] == map[2][i] && map[0][i] != -1) {
if (winner != null && winner != map[0][i].toString()) {
return null;
}
winner = map[0][i].toString();
}
}
if (map[0][0] == map[1][1] && map[1][1] == map[2][2] && map[0][0] != -1) {
if (winner != null && winner != map[0][0].toString()) {
return null;
}
winner = map[0][0].toString();
}
if (map[0][2] == map[1][1] && map[1][1] == map[2][0] && map[0][2] != -1) {
if (winner != null && winner != map[0][2].toString()) {
return null;
}
winner = map[0][2].toString();
}
return winner;
}void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Ultimate Tic Tac Toe AI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentBoard = -1;
  List<List<List<int>>> _board = List.generate(9, (_) => List.generate(9, (_) => List.filled(3, -1)));
  bool _gameOver = false;
  int _winner = -1;
  int _currentPlayer = 1;
  bool _aiTurn = false;
  bool _aiPlaying = false;
  int _difficulty = 3;

  void _resetGame() {
    setState(() {
      _currentBoard = -1;
      _board = List.generate(9, (_) => List.generate(9, (_) => List.filled(3, -1)));
      _gameOver = false;
      _winner = -1;
      _currentPlayer = 1;
      _aiTurn = false;
    });
  }

  void _makeMove(int board, int position) {
    setState(() {
      _board[board][position ~/ 3][position % 3] = _currentPlayer;
      String win = checkWinCondition(_board[board]);
      if (win != null) {
        _board[board] = List.generate(3, (_) => List.filled(3, _winner));
      }
      String gameWin = checkWinCondition(_board);
      if (gameWin != null) {
        _gameOver = true;
        _winner = int.parse(gameWin);
      }
      if (_board[position % 9][0][0] != -1 && !(_board[position % 9][0][0] is bool)) {
        _currentBoard = -1;
      } else {
        _currentBoard = position % 9;
      }
      _currentPlayer = _currentPlayer == 1 ? 2 : 1;
      _aiTurn = _aiPlaying && _currentPlayer == -1;
      if (_aiTurn) {
        int bestMove = miniMax({'board': _board, 'player': _currentPlayer}, _currentBoard, _difficulty, double.negativeInfinity, double.infinity, true)['move'];
        _makeMove(bestMove ~/ 9, bestMove % 9 % 9);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: _currentBoard == index ? Colors.grey : Colors.white,
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      children: List.generate(9, (position) {
                        return GestureDetector(
                          onTap: () {
                            if (!_gameOver && (_currentBoard == -1 || _currentBoard == position % 9) && _board[position ~/3][position % 3] == -1 && !_aiTurn) {
_makeMove(position % 9, position);
}
},
child: Container(
decoration: BoxDecoration(
border: Border.all(color: Colors.black),
color: _board[position % 9][position ~/ 3][position % 3] == -1 ? Colors.white : _board[position % 9][position ~/ 3][position % 3] == 1 ? Colors.redAccent : Colors.blueAccent,
),
child: Center(
child: Text(
_board[position % 9][position ~/ 3][position % 3] == -1 ? '' : _board[position % 9][position ~/ 3][position % 3] == 1 ? 'X' : 'O',
style: TextStyle(
color: Colors.white,
fontSize: 40.0,
fontWeight: FontWeight.bold,
),
),
),
),
);
}),
),
),
);
}),
),
),
Container(
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
Padding(
padding: const EdgeInsets.all(8.0),
child: RaisedButton(
child: Text('Reset'),
onPressed: () {
_resetGame();
},
),
),
Padding(
padding: const EdgeInsets.all(8.0),
child: RaisedButton(
child: Text(_aiPlaying ? 'Stop AI' : 'Start AI'),
onPressed: () {
setState(() {
_aiPlaying = !_aiPlaying;
if (_aiPlaying && _currentPlayer == -1) {
int bestMove = miniMax({'board': _board, 'player': _currentPlayer}, _currentBoard, _difficulty, double.negativeInfinity, double.infinity, true)['move'];
_makeMove(bestMove ~/ 9, bestMove % 9 % 9);
}
});
},
),
),
Padding(
padding: const EdgeInsets.all(8.0),
child: DropdownButton(
value: _difficulty,
items: [
DropdownMenuItem(
child: Text('Easy'),
value: 1,
),
DropdownMenuItem(
child: Text('Medium'),
value: 3,
),
DropdownMenuItem(
child: Text('Hard'),
value: 5,
),
DropdownMenuItem(
child: Text('Impossible'),
value: 9,
),
],
onChanged: (value) {
setState(() {
_difficulty = value;
});
},
),
),
],
),
),
_gameOver
? Padding(
padding: const EdgeInsets.all(8.0),
child: Text(
_winner == 1 ? 'Player 1 wins!' : _winner == 2 ? 'Player 2 wins!' : 'It's a tie!',
style: TextStyle(
fontSize: 30.0,
fontWeight: FontWeight.bold,
),
),
)
: SizedBox.shrink(),
],
),
);
}
}

String checkWinCondition(List<List<int>> map) {
for (int i = 0; i < 3; i++) {
if (map[i][0] != -1 && map[i][0] == map[i][1] && map[i][0] == map[i][2]) {
return map[i][0].toString();
}
if (map[0][i] != -1 && map[0][i] == map[1][i] && map[0][i] == map[2][i]) {
      return map[0][i].toString();
    }
  }
  if (map[0][0] != -1 && map[0][0] == map[1][1] && map[0][0] == map[2][2]) {
    return map[0][0].toString();
  }
  if (map[2][0] != -1 && map[2][0] == map[1][1] && map[2][0] == map[0][2]) {
    return map[2][0].toString();
  }
  if (map.expand((element) => element).contains(-1)) {
    return '';
  } else {
    return 'T';
  }
}

dynamic evaluateGame(Map position, List<List<int>> currentBoard) {
  String winner = checkWinCondition(position['board'][position['player']]);
  if (winner == '1') {
    return {'score': 10};
  } else if (winner == '2') {
    return {'score': -10};
  } else if (winner == 'T') {
    return {'score': 0};
  } else {
    int score = 0;
    for (int i = 0; i < 9; i++) {
      String squareWinner = checkWinCondition(currentBoard[i]);
      if (squareWinner == '1') {
        score += 3;
      } else if (squareWinner == '2') {
        score -= 3;
      }
      score += evaluatePos(i, currentBoard[i])['score'];
    }
    return {'score': score};
  }
}

dynamic miniMax(Map position, int boardToPlayOn, int depth, double alpha, double beta, bool maximizingPlayer) {
  if (depth == 0) {
    return {'score': realEvaluateSquare(position['player'], boardToPlayOn), 'move': -1};
  }
  String winner = checkWinCondition(position['board'][position['player']]);
  if (winner == '1') {
    return {'score': 10, 'move': -1};
  } else if (winner == '2') {
    return {'score': -10, 'move': -1};
  } else if (winner == 'T') {
    return {'score': 0, 'move': -1};
  }
  List<Map> moves = [];
  for (int i = 0; i < 81; i++) {
    if (position['board'][i ~/ 9][i % 9 ~/ 3][i % 9 % 3] == -1) {
      Map move = {'board': List.generate(3, (_) => List.generate(3, (_) => List.filled(3, -1, growable: false), growable: false), growable: false), 'player': position['player'] == 1 ? 2 : 1};
      for (int j = 0; j < 3; j++) {
        for (int k = 0; k < 3; k++) {
          for (int l = 0; l < 3; l++) {
            move['board'][j][k][l] = position['board'][j][k][l];
          }
        }
      }
      move['board'][i ~/ 27 * 3 + i % 9 ~/ 3][i % 3][i % 9 % 3] = maximizingPlayer ? 1 : 2;
      moves.add(move);
    }
  }
  if (maximizingPlayer) {
    double bestScore = double.negativeInfinity;
    int bestMove =-1;
    for (int i = 0; i < moves.length; i++) {
      dynamic score = miniMax(moves[i], (moves[i]['board'][i ~/ 27 * 3 + i % 9 ~/ 3][i % 3][i % 9 % 3] - 1) * 9 + i % 9 % 3, depth - 1, alpha, beta, false);
      if (score['score'] > bestScore) {
        bestScore = score['score'];
        bestMove = (moves[i]['board'][i ~/ 27 * 3 + i % 9 ~/ 3][i % 3][i % 9 % 3] - 1) * 9 + i % 9 % 3;
      }
      alpha = max(alpha, bestScore);
      if (beta <= alpha) {
        break;
      }
    }
    return {'score': bestScore, 'move': bestMove};
  } else {
    double bestScore = double.infinity;
    int bestMove = -1;
    for (int i = 0; i < moves.length; i++) {
      dynamic score = miniMax(moves[i], (moves[i]['board'][i ~/ 27 * 3 + i % 9 ~/ 3][i % 3][i % 9 % 3] - 1) * 9 + i % 9 % 3, depth - 1, alpha, beta, true);
      if (score['score'] < bestScore) {
        bestScore = score['score'];
        bestMove = (moves[i]['board'][i ~/ 27 * 3 + i % 9 ~/ 3][i % 3][i % 9 % 3] - 1) * 9 + i % 9 % 3;
      }
      beta = min(beta, bestScore);
      if (beta <= alpha) {
        break;
      }
    }
    return {'score': bestScore, 'move': bestMove};
  }
} 
