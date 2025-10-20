import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_bloc.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_event.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_state.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_incidents_usecase.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_video_usecase.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/incident_remote_datasource.dart';
import 'package:mamoai/features/incident_history/infrastructure/datasources/video_remote_datasource.dart';
import 'package:mamoai/features/incident_history/infrastructure/repositories/incident_repository_impl.dart';
import 'package:mamoai/features/incident_history/infrastructure/repositories/video_repository_impl.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_button.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text_field.dart';

/// 履歴画面
class IncidentHistoryPage extends StatelessWidget {
  const IncidentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 依存関係の構築
    final dio = Dio();
    final incidentDataSource = IncidentRemoteDataSource(dio);
    final videoDataSource = VideoRemoteDataSource(dio);
    final incidentRepository = IncidentRepositoryImpl(incidentDataSource);
    final videoRepository = VideoRepositoryImpl(videoDataSource);
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
class IncidentHistoryView extends StatelessWidget {
  const IncidentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              // QRコード表示
            },
          ),
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () {
              // ビュー画面へ遷移
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 設定画面へ遷移
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 検索バー
          _buildSearchBar(context),
          // 履歴一覧
          Expanded(
            child: BlocBuilder<IncidentHistoryBloc, IncidentHistoryState>(
              builder: (context, state) {
                if (state is IncidentHistoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is IncidentHistoryLoaded) {
                  return _buildIncidentList(context, state);
                } else if (state is IncidentHistoryError) {
                  return Center(
                    child: Text('エラー: ${state.message}'),
                  );
                } else {
                  return const Center(
                    child: Text('データがありません'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 検索バー
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: '開始日',
                  hint: 'yyyy/mm/dd',
                  readOnly: true,
                  onTap: () async {
                    // 日付選択
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    // TODO: 選択した日付を状態管理
                  },
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppTextField(
                  label: '終了日',
                  hint: 'yyyy/mm/dd',
                  readOnly: true,
                  onTap: () async {
                    // 日付選択
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    // TODO: 選択した日付を状態管理
                  },
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: '部屋/ベッド番号',
                  hint: '例: 101',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppTextField(
                  label: '見守り対象者名',
                  hint: '例: 山田太郎',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppButton(
            text: '検索',
            icon: Icons.search,
            onPressed: () {
              // 検索実行
              context.read<IncidentHistoryBloc>().add(
                    SearchIncidentsEvent(),
                  );
            },
          ),
        ],
      ),
    );
  }

  /// 履歴一覧
  Widget _buildIncidentList(
    BuildContext context,
    IncidentHistoryLoaded state,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: state.incidents.length,
            itemBuilder: (context, index) {
              final incident = state.incidents[index];
              return ListTile(
                leading: Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                title: Text('履歴番号: ${incident.id}'),
                subtitle: Text(
                  '${incident.detectedAt}\n'
                  '部屋: ${incident.roomNumber ?? "-"} / '
                  '対象者: ${incident.personName ?? "-"}\n'
                  '異常: ${incident.type} / '
                  'ステータス: ${incident.status}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_circle),
                      onPressed: () {
                        if (incident.videoId != null) {
                          context.read<IncidentHistoryBloc>().add(
                                PlayVideoEvent(incident.videoId!),
                              );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        // ダウンロード処理
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // ページネーション
        _buildPagination(context, state),
      ],
    );
  }

  /// ページネーション
  Widget _buildPagination(
    BuildContext context,
    IncidentHistoryLoaded state,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: state.paginationInfo.hasPreviousPage
                ? () {
                    context.read<IncidentHistoryBloc>().add(
                          ChangePageEvent(
                            state.paginationInfo.currentPage - 1,
                          ),
                        );
                  }
                : null,
          ),
          Text(
            'ページ ${state.paginationInfo.currentPage} / '
            '${state.paginationInfo.totalPages}',
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: state.paginationInfo.hasNextPage
                ? () {
                    context.read<IncidentHistoryBloc>().add(
                          ChangePageEvent(
                            state.paginationInfo.currentPage + 1,
                          ),
                        );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
