import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterkaigi2023_handson/model/tic_tac_toe.dart';

final ticTacToeProvider = StateProvider.autoDispose<TicTacToe>((ref) {
  return TicTacToe.start();
});
