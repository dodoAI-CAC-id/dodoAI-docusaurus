import 'package:equatable/equatable.dart';
import '../../../domain/entities/incident_status.dart';

/// ビュー画面のBLoCイベント
abstract class ViewScreenEvent extends Equatable {
  const ViewScreenEvent();

  @override
  List<Object?> get props => [];
}

/// インシデントアイテム一覧を読み込むイベント
class LoadIncidentItems extends ViewScreenEvent {
  const LoadIncidentItems();
}

/// インシデントアイテム一覧を更新（リフレッシュ）するイベント
class RefreshIncidentItems extends ViewScreenEvent {
  const RefreshIncidentItems();
}

/// インシデントのステータスを更新するイベント
class UpdateIncidentStatus extends ViewScreenEvent {
  final String incidentId;
  final IncidentStatus newStatus;
  final String actionType;

  const UpdateIncidentStatus({
    required this.incidentId,
    required this.newStatus,
    required this.actionType,
  });

  @override
  List<Object?> get props => [incidentId, newStatus, actionType];
}

/// アラートの稼働状態を切り替えるイベント
class ToggleAlertStatus extends ViewScreenEvent {
  final String incidentId;
  final bool isActive;

  const ToggleAlertStatus({
    required this.incidentId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [incidentId, isActive];
}

/// 異常検知をシミュレーションするイベント（開発用）
class SimulateIncidentDetected extends ViewScreenEvent {
  final String incidentId;
  final String cameraId;

  const SimulateIncidentDetected({
    required this.incidentId,
    required this.cameraId,
  });

  @override
  List<Object?> get props => [incidentId, cameraId];
}
