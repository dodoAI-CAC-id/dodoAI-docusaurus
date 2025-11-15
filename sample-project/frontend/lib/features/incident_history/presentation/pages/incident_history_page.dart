import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_bloc.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_event.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_state.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_incidents_usecase.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_video_usecase.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/incident_remote_datasource.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/video_remote_datasource.dart';
import 'package:mamoai/features/incident_history/infrastructure/repositories/incident_repository_impl.dart';
import 'package:mamoai/features/incident_history/infrastructure/repositories/video_repository_impl.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/organisms/search_panel.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/organisms/incident_list_table.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/organisms/pagination_controls.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/video_player_dialog.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/qr_code_dialog.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text.dart';
import 'package:mamoai/shared/presentation/components/organisms/app_header.dart';
import 'package:mamoai/features/view_screen/presentation/pages/view_screen_page_wrapper.dart';

/// 履歴画面
class IncidentHistoryPage extends StatelessWidget {
  const IncidentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔄 APIリポジトリを使用（実際のバックエンドAPIと通信）
    final dio = Dio();
    final incidentRemoteDataSource = IncidentRemoteDataSource(dio);
    final videoRemoteDataSource = VideoRemoteDataSource(dio);
    
    final incidentRepository = IncidentRepositoryImpl(
      incidentRemoteDataSource,
    );
    final videoRepository = VideoRepositoryImpl(
      videoRemoteDataSource,
    );
    
    final getIncidentsUseCase = GetIncidentsUseCase(incidentRepository);
    final getVideoUseCase = GetVideoUseCase(videoRepository);

    return BlocProvider(
      create: (context) => IncidentHistoryBloc(
        getIncidentsUseCase: getIncidentsUseCase,
        getVideoUseCase: getVideoUseCase,
      )..add(LoadIncidentsEvent()),
      child: const IncidentHistoryView(),
    );
  }
}

/// 履歴画面ビュー
class IncidentHistoryView extends StatefulWidget {
  const IncidentHistoryView({super.key});

  @override
  State<IncidentHistoryView> createState() => _IncidentHistoryViewState();
}

class _IncidentHistoryViewState extends State<IncidentHistoryView> {
  // 検索条件の状態管理
  DateTime? _startDate;
  DateTime? _endDate;
  String? _roomNumber;
  String? _personName;
  String? _assignedTo;
  String? _actionType;
  String? _incidentType;
  
  // 選択された履歴のID
  final Set<String> _selectedIncidentIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // カスタムヘッダー
          AppHeader(
            onQrCodePressed: () {
              QrCodeDialog.show(context);
            },
            onViewPressed: () {
              // ビュー画面へ遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewScreenPageWrapper(),
                ),
              );
            },
            onReloadPressed: () {
              // 履歴データをリロード
              context.read<IncidentHistoryBloc>().add(LoadIncidentsEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('履歴データを再読み込みしました')),
              );
            },
            onSettingsPressed: () {
              // TODO: 設定画面へ遷移
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('設定画面への遷移（未実装）')),
              );
            },
          ),
          
          // 検索パネル
          SearchPanel(
            startDate: _startDate,
            endDate: _endDate,
            roomNumber: _roomNumber,
            personName: _personName,
            assignedTo: _assignedTo,
            actionType: _actionType,
            incidentType: _incidentType,
            onStartDateChanged: (date) {
              setState(() {
                _startDate = date;
              });
            },
            onEndDateChanged: (date) {
              setState(() {
                _endDate = date;
              });
            },
            onRoomNumberChanged: (value) {
              setState(() {
                _roomNumber = value;
              });
            },
            onPersonNameChanged: (value) {
              setState(() {
                _personName = value;
              });
            },
            onAssignedToChanged: (value) {
              setState(() {
                _assignedTo = value;
              });
            },
            onActionTypeChanged: (value) {
              setState(() {
                _actionType = value;
              });
            },
            onIncidentTypeChanged: (value) {
              setState(() {
                _incidentType = value;
              });
            },
            onSearch: () {
              // 検索実行
              context.read<IncidentHistoryBloc>().add(
                    SearchIncidentsEvent(
                      personName: _personName,
                      roomNumber: _roomNumber,
                      assignedTo: _assignedTo,
                      actionType: _actionType,
                      incidentType: _incidentType,
                      status: null, // statusは現在UIにないのでnull
                      fromDate: _startDate,
                      toDate: _endDate,
                    ),
                  );
            },
            onClear: () {
              setState(() {
                _startDate = null;
                _endDate = null;
                _roomNumber = null;
                _personName = null;
                _assignedTo = null;
                _actionType = null;
                _incidentType = null;
              });
              // クリア後に全件検索
              context.read<IncidentHistoryBloc>().add(LoadIncidentsEvent());
            },
          ),

          // 履歴一覧
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocConsumer<IncidentHistoryBloc, IncidentHistoryState>(
              listener: (context, state) {
                // 動画再生状態の処理
                if (state is VideoPlayingState) {
                  _showVideoDialog(context, state.videoUrl, 'INCIDENT_ID');
                }
              },
              builder: (context, state) {
                print('🟡 [Page] BlocBuilder state: ${state.runtimeType}');
                
                if (state is IncidentHistoryLoading) {
                  print('🟡 [Page] Showing loading indicator');
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is IncidentHistoryLoaded) {
                  print('🟡 [Page] Loaded state - incidents: ${state.incidents.length}');
                  return Column(
                    children: [
                      // インシデント一覧テーブル
                      Expanded(
                        child: IncidentListTable(
                          incidents: state.incidents,
                          selectedIncidentIds: _selectedIncidentIds,
                          onSelectionChanged: (id, selected) {
                            setState(() {
                              if (selected) {
                                _selectedIncidentIds.add(id);
                              } else {
                                _selectedIncidentIds.remove(id);
                              }
                            });
                          },
                          onPlayVideo: (id) {
                            final incident = state.incidents.firstWhere(
                              (i) => i.id == id,
                            );
                            if (incident.videoId != null) {
                              context.read<IncidentHistoryBloc>().add(
                                    PlayVideoEvent(incident.videoId!),
                                  );
                            }
                          },
                          onDownloadVideo: (id) {
                            // ダウンロード処理
                            // TODO: 実装
                          },
                        ),
                      ),

                      // ページネーションコントロール
                      PaginationControls(
                        currentPage: state.paginationInfo.currentPage,
                        totalPages: state.paginationInfo.totalPages,
                        totalCount: state.paginationInfo.totalCount,
                        onPageChanged: (page) {
                          context.read<IncidentHistoryBloc>().add(
                                ChangePageEvent(page),
                              );
                        },
                      ),
                    ],
                  );
                } else if (state is IncidentHistoryError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        AppText(
                          text: 'エラーが発生しました',
                          type: TextStyleType.h3,
                        ),
                        const SizedBox(height: 8),
                        AppText(
                          text: state.message,
                          type: TextStyleType.body2,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: AppText(
                      text: 'データがありません',
                      type: TextStyleType.body1,
                    ),
                  );
                }
              },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 動画再生ダイアログを表示
  void _showVideoDialog(BuildContext context, String videoUrl, String incidentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => VideoPlayerDialog(
        videoId: videoUrl,
        incidentId: incidentId,
        onClose: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }
}
