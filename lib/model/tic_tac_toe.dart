import 'package:flutterkaigi2023_handson/model/players.dart';

class TicTacToe {
  final List<List<String>> board;
  final Players players;
  final String currentPlayer;

  TicTacToe(
    this.board,
    this.players,
    this.currentPlayer,
  );

  factory TicTacToe.fromJson(Map<String, dynamic> json) {
    final flatBoard = List<String>.from(json['board']);

    return TicTacToe(
      // Firestore側を1次元配列にしているので、モデルの2次元配列とここで合わせる
      [
        List<String>.from(flatBoard.sublist(0, 3)),
        List<String>.from(flatBoard.sublist(3, 6)),
        List<String>.from(flatBoard.sublist(6, 9)),
      ],
      Players(
        playerX: json['players']['playerX'],
        playerO: json['players']['playerO'],
      ),
      json['currentPlayer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // モデルが2次元配列なので、Firestore側の1次元配列にここで合わせる
      'board': [...board[0], ...board[1], ...board[2]],
      'players': {
        'playerX': players.playerX,
        'playerO': players.playerO,
      },
      'currentPlayer': currentPlayer,
    };
  }

  factory TicTacToe.start({
    playerX = 'X',
    playerO = 'O',
  }) {
    final players = Players(
      playerX: playerX,
      playerO: playerO,
    );

    return TicTacToe(
      [
        ['', '', ''],
        ['', '', ''],
        ['', '', ''],
      ],
      players,
      players.playerX,
    );
  }

  TicTacToe placeMark(int row, int col) {
    if (board[row][col].isEmpty) {
      final newBoard = List.of(board);
      newBoard[row][col] = currentPlayer == players.playerX ? 'X' : 'O';
      String nextPlayer =
          currentPlayer == players.playerX ? players.playerO : players.playerX;

      return TicTacToe(newBoard, players, nextPlayer);
    }
    return this;
  }

  String getWinner() {
    for (int i = 0; i < 3; i++) {
      // row = i における横の判定
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0].isNotEmpty) {
        return board[i][0] == 'X' ? players.playerX : players.playerO;
      }
      // col = i における縦の判定
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i].isNotEmpty) {
        return board[0][i] == 'X' ? players.playerX : players.playerO;
      }
    }
    // 左上から右下への斜めの判定
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0].isNotEmpty) {
      return board[0][0] == 'X' ? players.playerX : players.playerO;
    }
    // 右上から左下への斜めの判定
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2].isNotEmpty) {
      return board[0][2] == 'X' ? players.playerX : players.playerO;
    }
    return '';
  }

  bool isDraw() {
    return getWinner().isEmpty &&
        board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  TicTacToe resetBoard() {
    return TicTacToe.start(
      playerX: players.playerX,
      playerO: players.playerO,
    );
  }
}
