import 'package:equatable/equatable.dart';

/// 対応履歴エンティティ
/// 
/// 異常検知に対する対応履歴を表現するドメインエンティティ
class Action extends Equatable {
  /// アクションID
  final String id;

  /// 関連するインシデントID
  final String incidentId;

  /// 対応実施日時
  final DateTime performedAt;

  /// 対応実施者
  final String performedBy;

  /// 対応種別（確認、対応、完了、キャンセル、その他）
  final String actionType;

  /// 備考・メモ
  final String? notes;

  const Action({
    required this.id,
    required this.incidentId,
    required this.performedAt,
    required this.performedBy,
    required this.actionType,
    this.notes,
  });

  /// コピーして新しいインスタンスを作成
  Action copyWith({
    String? id,
    String? incidentId,
    DateTime? performedAt,
    String? performedBy,
    String? actionType,
    String? notes,
  }) {
    return Action(
      id: id ?? this.id,
      incidentId: incidentId ?? this.incidentId,
      performedAt: performedAt ?? this.performedAt,
      performedBy: performedBy ?? this.performedBy,
      actionType: actionType ?? this.actionType,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        incidentId,
        performedAt,
        performedBy,
        actionType,
        notes,
      ];

  @override
  bool get stringify => true;
}
