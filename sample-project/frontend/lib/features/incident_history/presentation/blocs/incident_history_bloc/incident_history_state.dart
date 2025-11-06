import 'package:equatable/equatable.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/domain/entities/pagination_info.dart';

/// 異常イベント履歴画面の状態
abstract class IncidentHistoryState extends Equatable {
  const IncidentHistoryState();

  @override
  List<Object?> get props => [];
}

/// 初期状態
class IncidentHistoryInitial extends IncidentHistoryState {}

/// ローディング中
class IncidentHistoryLoading extends IncidentHistoryState {}

/// データ読み込み完了
class IncidentHistoryLoaded extends IncidentHistoryState {
  final List<Incident> incidents;
  final PaginationInfo paginationInfo;

  const IncidentHistoryLoaded({
    required this.incidents,
    required this.paginationInfo,
  });

  @override
  List<Object?> get props => [incidents, paginationInfo];
}

/// エラー
class IncidentHistoryError extends IncidentHistoryState {
  final String message;

  const IncidentHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

/// 動画再生中
class VideoPlayingState extends IncidentHistoryState {
  final String videoUrl;

  const VideoPlayingState(this.videoUrl);

  @override
  List<Object?> get props => [videoUrl];
}
