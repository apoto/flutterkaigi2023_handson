import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterkaigi2023_handson/model/tic_tac_toe.dart';
import 'package:flutterkaigi2023_handson/provider/get_tic_tac_toe_provider.dart';
import 'package:flutterkaigi2023_handson/provider/update_tic_tac_toe_provider.dart';

class Board extends ConsumerWidget {
  const Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticTacToeStream = ref.watch(getTicTacToeProvider);

    return ticTacToeStream.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, __) =>
          Center(child: Text('エラーが発生しました: ${error.toString()}')),
      data: (ticTacToe) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _statusMessage(ticTacToe),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final int row = index ~/ 3;
                  final int col = index % 3;
                  final String mark = ticTacToe.board[row][col];

                  return GestureDetector(
                    onTap: () {
                      final winner = ticTacToe.getWinner();
                      if (mark.isEmpty && winner.isEmpty) {
                        ref.read(
                          updateTicTacToeProvider(
                              ticTacToe.placeMark(row, col)),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          mark,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      ref.read(
                        updateTicTacToeProvider(ticTacToe.resetBoard()),
                      );
                    },
                    child: const Text('ゲームをリセット')),
              ),
            ],
          ),
        );
      },
    );
  }

  String _statusMessage(TicTacToe ticTacToe) {
    final winner = ticTacToe.getWinner();
    final isDraw = ticTacToe.isDraw();

    if (winner.isNotEmpty) {
      return '$winner の勝ち';
    } else if (isDraw) {
      return '引き分けです';
    } else {
      return '${ticTacToe.currentPlayer} の番です';
    }
  }
}
