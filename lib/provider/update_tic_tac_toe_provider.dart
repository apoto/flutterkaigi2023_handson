import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterkaigi2023_handson/model/tic_tac_toe.dart';
import 'package:flutterkaigi2023_handson/repository/tic_tac_toe_repository.dart';

final updateTicTacToeProvider =
    AutoDisposeFutureProviderFamily<void, TicTacToe>(
  (ref, arg) => ref.watch(ticTacToeRepositoryProvider).update(arg),
);
