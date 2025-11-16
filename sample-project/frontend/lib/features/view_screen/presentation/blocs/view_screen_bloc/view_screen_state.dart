import 'package:equatable/equatable.dart';
import '../../../domain/entities/incident_item.dart';

/// ビュー画面のBLoCステート
abstract class ViewScreenState extends Equatable {
  const ViewScreenState();

  @override
  List<Object?> get props => [];
}

/// 初期状態
class ViewScreenInitial extends ViewScreenState {
  const ViewScreenInitial();
}

/// ローディング中
class ViewScreenLoading extends ViewScreenState {
  const ViewScreenLoading();
}

/// データ読み込み成功
class ViewScreenLoaded extends ViewScreenState {
  final List<IncidentItem> items;
  final String? highlightedItemId;

  const ViewScreenLoaded({
    required this.items,
    this.highlightedItemId,
  });

  /// 異常検知中のアイテム（未対応 + 対応中）
  List<IncidentItem> get detectedItems {
    return items.where((item) => item.isDetected).toList()
      ..sort((a, b) {
        // 未対応を先に表示
        if (a.status != b.status) {
          return a.status.index.compareTo(b.status.index);
        }
        // 同じステータスなら検知日時の新しい順
        if (a.detectedAt != null && b.detectedAt != null) {
          return b.detectedAt!.compareTo(a.detectedAt!);
        }
        return 0;
      });
  }

  /// 検知なしのアイテム
  List<IncidentItem> get noDetectionItems {
    return items.where((item) => !item.isDetected).toList()
      ..sort((a, b) => a.roomBedNumber.compareTo(b.roomBedNumber));
  }

  @override
  List<Object?> get props => [items, highlightedItemId];
}

/// エラー状態
class ViewScreenError extends ViewScreenState {
  final String message;

  const ViewScreenError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// ステータス更新中
class ViewScreenUpdating extends ViewScreenState {
  final List<IncidentItem> items;
  final String updatingItemId;

  const ViewScreenUpdating({
    required this.items,
    required this.updatingItemId,
  });

  @override
  List<Object?> get props => [items, updatingItemId];
}
