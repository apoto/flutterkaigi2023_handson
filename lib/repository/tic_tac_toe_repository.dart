import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterkaigi2023_handson/model/tic_tac_toe.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final ticTacToeRepositoryProvider = AutoDisposeProvider<TicTacToeRepository>(
  (ref) => TicTacToeRepository(),
);

final class TicTacToeRepository {
  TicTacToeRepository();
  final _client = FirebaseFirestore.instance;
  static const _collectionKey = 'tic_tac_toe';
  String _documentKey(String playerX, String playerO) {
    return '${playerX}_$playerO';
  }

  CollectionReference<TicTacToe> _colRef() =>
      _client.collection(_collectionKey).withConverter(
            fromFirestore: (doc, _) => TicTacToe.fromJson(doc.data()!),
            toFirestore: (entity, _) => entity.toJson(),
          );

  /// 盤面のデータを取得する
  Stream<TicTacToe> get({
    String playerX = 'X',
    String playerO = 'O',
  }) {
    // ドキュメント名に変換する
    final documentKey = _documentKey(playerX, playerO);
    // スナップショットを取得し、モデルへ変換する
    // データがない場合、モデルの初期状態を返す
    return _colRef().doc(documentKey).snapshots().map(
          (e) =>
              e.data() ??
              TicTacToe.start(
                playerX: playerX,
                playerO: playerO,
              ),
        );
  }

  Future<void> update(TicTacToe ticTacToe) async {
    final documentKey =
        _documentKey(ticTacToe.players.playerX, ticTacToe.players.playerO);
    await _colRef().doc(documentKey).set(ticTacToe);
  }
}
