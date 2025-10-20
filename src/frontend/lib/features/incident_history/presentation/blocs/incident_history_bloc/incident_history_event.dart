import 'package:equatable/equatable.dart';

/// 異常イベント履歴画面のイベント
abstract class IncidentHistoryEvent extends Equatable {
  const IncidentHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// 初期表示イベント
class LoadIncidentsEvent extends IncidentHistoryEvent {}

/// 検索実行イベント
class SearchIncidentsEvent extends IncidentHistoryEvent {
  final String? personId;
  final String? personName;
  final String? roomNumber;
  final String? status;
  final DateTime? fromDate;
  final DateTime? toDate;

  const SearchIncidentsEvent({
    this.personId,
    this.personName,
    this.roomNumber,
    this.status,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [
        personId,
        personName,
        roomNumber,
        status,
        fromDate,
        toDate,
      ];
}

/// ページ変更イベント
class ChangePageEvent extends IncidentHistoryEvent {
  final int pageNumber;

  const ChangePageEvent(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

/// 動画再生イベント
class PlayVideoEvent extends IncidentHistoryEvent {
  final String videoId;

  const PlayVideoEvent(this.videoId);

  @override
  List<Object?> get props => [videoId];
}
