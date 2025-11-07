import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/features/history/domain/entities/action.dart';
import 'package:frontend/features/history/domain/entities/incident.dart';
import 'package:frontend/features/history/domain/repositories/i_incident_repository.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_bloc.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_event.dart';
import 'package:frontend/features/history/presentation/blocs/history/history_state.dart';
import 'package:frontend/features/history/presentation/organisms/history_table.dart';

@GenerateMocks([IIncidentRepository])
import 'history_bloc_test.mocks.dart';

void main() {
  group('HistoryBloc', () {
    late MockIIncidentRepository mockRepository;
    late HistoryBloc historyBloc;

    // モックデータの作成
    final mockIncident = Incident(
      id: 'incident-1',
      incidentId: 'INC-001',
      roomNumber: '101',
      bedNumber: 'A',
      residentName: '山田太郎',
      detectedAt: DateTime(2025, 1, 15, 10, 30),
      detectionType: '転倒検知',
      status: IncidentStatus.resolved,
      videoId: 'video-1',
      actions: [
        Action(
          id: 'action-1',
          incidentId: 'incident-1',
          actionType: '確認',
          performedBy: '看護師A',
          performedAt: DateTime(2025, 1, 15, 10, 35),
          notes: '確認しました',
        ),
      ],
    );

    setUp(() {
      mockRepository = MockIIncidentRepository();
      historyBloc = HistoryBloc(incidentRepository: mockRepository);
    });

    tearDown(() {
      historyBloc.close();
    });

    test('初期状態はHistoryStatus.initial', () {
      expect(historyBloc.state.status, HistoryStatus.initial);
      expect(historyBloc.state.incidents, isEmpty);
      expect(historyBloc.state.currentPage, 1);
      expect(historyBloc.state.pageSize, 20);
      expect(historyBloc.state.totalCount, 0);
      expect(historyBloc.state.isSearching, false);
    });

    group('HistoryInitialFetchRequested', () {
      blocTest<HistoryBloc, HistoryState>(
        '成功時：データを取得してsuccessステートに遷移',
        build: () {
          when(mockRepository.fetchIncidents(
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
            orderBy: anyNamed('orderBy'),
            descending: anyNamed('descending'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countIncidents()).thenAnswer((_) async => 50);

          return historyBloc;
        },
        act: (bloc) => bloc.add(const HistoryInitialFetchRequested()),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success)
              .having((s) => s.incidents.length, 'incidents length', 1)
              .having((s) => s.totalCount, 'totalCount', 50)
              .having((s) => s.currentPage, 'currentPage', 1)
              .having((s) => s.errorMessage, 'errorMessage', null),
        ],
        verify: (_) {
          verify(mockRepository.fetchIncidents(
            limit: 20,
            offset: 0,
            orderBy: 'detectedAt',
            descending: true,
          )).called(1);
          verify(mockRepository.countIncidents()).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        '失敗時：エラーメッセージ付きでfailureステートに遷移',
        build: () {
          when(mockRepository.fetchIncidents(
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
            orderBy: anyNamed('orderBy'),
            descending: anyNamed('descending'),
          )).thenThrow(Exception('Network error'));

          return historyBloc;
        },
        act: (bloc) => bloc.add(const HistoryInitialFetchRequested()),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('HistoryPageChanged', () {
      blocTest<HistoryBloc, HistoryState>(
        '通常モード：指定されたページのデータを取得',
        build: () {
          when(mockRepository.fetchIncidents(
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
            orderBy: anyNamed('orderBy'),
            descending: anyNamed('descending'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countIncidents()).thenAnswer((_) async => 50);

          return historyBloc;
        },
        act: (bloc) =>
            bloc.add(const HistoryPageChanged(page: 2, pageSize: 20)),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success)
              .having((s) => s.currentPage, 'currentPage', 2)
              .having((s) => s.pageSize, 'pageSize', 20),
        ],
        verify: (_) {
          verify(mockRepository.fetchIncidents(
            limit: 20,
            offset: 20, // (page 2 - 1) * 20 = 20
            orderBy: 'detectedAt',
            descending: true,
          )).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        '検索モード：検索条件を保持してページ変更',
        seed: () => HistoryState(
          searchFilters: {
            'roomNumber': '101',
            'startDate': DateTime(2025, 1, 1),
          },
        ),
        build: () {
          when(mockRepository.searchIncidents(
            roomNumber: anyNamed('roomNumber'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            bedNumber: anyNamed('bedNumber'),
            residentName: anyNamed('residentName'),
            performedBy: anyNamed('performedBy'),
            detectionType: anyNamed('detectionType'),
            status: anyNamed('status'),
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countSearchResults(
            roomNumber: anyNamed('roomNumber'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            bedNumber: anyNamed('bedNumber'),
            residentName: anyNamed('residentName'),
            performedBy: anyNamed('performedBy'),
            detectionType: anyNamed('detectionType'),
            status: anyNamed('status'),
          )).thenAnswer((_) async => 10);

          return historyBloc;
        },
        act: (bloc) =>
            bloc.add(const HistoryPageChanged(page: 2, pageSize: 20)),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success)
              .having((s) => s.currentPage, 'currentPage', 2),
        ],
        verify: (_) {
          verify(mockRepository.searchIncidents(
            roomNumber: '101',
            startDate: DateTime(2025, 1, 1),
            endDate: null,
            bedNumber: null,
            residentName: null,
            performedBy: null,
            detectionType: null,
            status: null,
            limit: 20,
            offset: 20,
          )).called(1);
        },
      );
    });

    group('HistoryPageSizeChanged', () {
      blocTest<HistoryBloc, HistoryState>(
        'ページサイズ変更時は1ページ目に戻る',
        build: () {
          when(mockRepository.fetchIncidents(
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
            orderBy: anyNamed('orderBy'),
            descending: anyNamed('descending'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countIncidents()).thenAnswer((_) async => 50);

          return historyBloc;
        },
        act: (bloc) => bloc.add(const HistoryPageSizeChanged(50)),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success)
              .having((s) => s.pageSize, 'pageSize', 50)
              .having((s) => s.currentPage, 'currentPage', 1),
        ],
      );
    });

    group('HistorySearchRequested', () {
      blocTest<HistoryBloc, HistoryState>(
        '検索条件を指定してデータを検索',
        build: () {
          when(mockRepository.searchIncidents(
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            roomNumber: anyNamed('roomNumber'),
            bedNumber: anyNamed('bedNumber'),
            residentName: anyNamed('residentName'),
            performedBy: anyNamed('performedBy'),
            detectionType: anyNamed('detectionType'),
            status: anyNamed('status'),
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countSearchResults(
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            roomNumber: anyNamed('roomNumber'),
            bedNumber: anyNamed('bedNumber'),
            residentName: anyNamed('residentName'),
            performedBy: anyNamed('performedBy'),
            detectionType: anyNamed('detectionType'),
            status: anyNamed('status'),
          )).thenAnswer((_) async => 10);

          return historyBloc;
        },
        act: (bloc) => bloc.add(HistorySearchRequested(
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 1, 31),
          roomNumber: '101',
        )),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success)
              .having((s) => s.isSearching, 'isSearching', true)
              .having((s) => s.totalCount, 'totalCount', 10)
              .having((s) => s.currentPage, 'currentPage', 1),
        ],
        verify: (_) {
          verify(mockRepository.searchIncidents(
            startDate: DateTime(2025, 1, 1),
            endDate: DateTime(2025, 1, 31),
            roomNumber: '101',
            bedNumber: null,
            residentName: null,
            performedBy: null,
            detectionType: null,
            status: null,
            limit: 20,
            offset: 0,
          )).called(1);
          verify(mockRepository.countSearchResults(
            startDate: DateTime(2025, 1, 1),
            endDate: DateTime(2025, 1, 31),
            roomNumber: '101',
            bedNumber: null,
            residentName: null,
            performedBy: null,
            detectionType: null,
            status: null,
          )).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        '検索失敗時：エラーメッセージ付きでfailureステートに遷移',
        build: () {
          when(mockRepository.searchIncidents(
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            roomNumber: anyNamed('roomNumber'),
            bedNumber: anyNamed('bedNumber'),
            residentName: anyNamed('residentName'),
            performedBy: anyNamed('performedBy'),
            detectionType: anyNamed('detectionType'),
            status: anyNamed('status'),
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
          )).thenThrow(Exception('Search failed'));

          return historyBloc;
        },
        act: (bloc) => bloc.add(const HistorySearchRequested(
          roomNumber: '101',
        )),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', contains('検索に失敗')),
        ],
      );
    });

    group('HistorySearchCleared', () {
      blocTest<HistoryBloc, HistoryState>(
        '検索条件をクリアして初期データを再取得',
        seed: () => HistoryState(
          searchFilters: {'roomNumber': '101'},
        ),
        build: () {
          when(mockRepository.fetchIncidents(
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
            orderBy: anyNamed('orderBy'),
            descending: anyNamed('descending'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countIncidents()).thenAnswer((_) async => 50);

          return historyBloc;
        },
        act: (bloc) => bloc.add(const HistorySearchCleared()),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.searchFilters, 'searchFilters', isEmpty),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success)
              .having((s) => s.isSearching, 'isSearching', false),
        ],
      );
    });

    group('HistoryRefreshRequested', () {
      blocTest<HistoryBloc, HistoryState>(
        '通常モード：現在のページを再取得',
        seed: () => const HistoryState(currentPage: 2, pageSize: 20),
        build: () {
          when(mockRepository.fetchIncidents(
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
            orderBy: anyNamed('orderBy'),
            descending: anyNamed('descending'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countIncidents()).thenAnswer((_) async => 50);

          return historyBloc;
        },
        act: (bloc) => bloc.add(const HistoryRefreshRequested()),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success)
              .having((s) => s.currentPage, 'currentPage', 2),
        ],
      );

      blocTest<HistoryBloc, HistoryState>(
        '検索モード：検索条件を保持して再検索',
        seed: () => HistoryState(
          searchFilters: {'roomNumber': '101'},
        ),
        build: () {
          when(mockRepository.searchIncidents(
            roomNumber: anyNamed('roomNumber'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            bedNumber: anyNamed('bedNumber'),
            residentName: anyNamed('residentName'),
            performedBy: anyNamed('performedBy'),
            detectionType: anyNamed('detectionType'),
            status: anyNamed('status'),
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countSearchResults(
            roomNumber: anyNamed('roomNumber'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            bedNumber: anyNamed('bedNumber'),
            residentName: anyNamed('residentName'),
            performedBy: anyNamed('performedBy'),
            detectionType: anyNamed('detectionType'),
            status: anyNamed('status'),
          )).thenAnswer((_) async => 10);

          return historyBloc;
        },
        act: (bloc) => bloc.add(const HistoryRefreshRequested()),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success)
              .having((s) => s.isSearching, 'isSearching', true),
        ],
      );
    });

    group('HistorySortChanged', () {
      blocTest<HistoryBloc, HistoryState>(
        '通常モード：ソート条件を変更して1ページ目から再取得',
        build: () {
          when(mockRepository.fetchIncidents(
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
            orderBy: anyNamed('orderBy'),
            descending: anyNamed('descending'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countIncidents()).thenAnswer((_) async => 50);

          return historyBloc;
        },
        act: (bloc) => bloc.add(const HistorySortChanged(
          columnId: 'roomNumber',
          order: SortOrder.ascending,
        )),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.sortBy, 'sortBy', 'roomNumber')
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.ascending),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success),
        ],
      );

      blocTest<HistoryBloc, HistoryState>(
        '検索モード：ソート条件を変更して検索を再実行',
        seed: () => HistoryState(
          searchFilters: {'roomNumber': '101'},
        ),
        build: () {
          when(mockRepository.searchIncidents(
            roomNumber: anyNamed('roomNumber'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            bedNumber: anyNamed('bedNumber'),
            residentName: anyNamed('residentName'),
            performedBy: anyNamed('performedBy'),
            detectionType: anyNamed('detectionType'),
            status: anyNamed('status'),
            limit: anyNamed('limit'),
            offset: anyNamed('offset'),
          )).thenAnswer((_) async => [mockIncident]);

          when(mockRepository.countSearchResults(
            roomNumber: anyNamed('roomNumber'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
            bedNumber: anyNamed('bedNumber'),
            residentName: anyNamed('residentName'),
            performedBy: anyNamed('performedBy'),
            detectionType: anyNamed('detectionType'),
            status: anyNamed('status'),
          )).thenAnswer((_) async => 10);

          return historyBloc;
        },
        act: (bloc) => bloc.add(const HistorySortChanged(
          columnId: 'roomNumber',
          order: SortOrder.ascending,
        )),
        expect: () => [
          isA<HistoryState>()
              .having((s) => s.sortBy, 'sortBy', 'roomNumber')
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.ascending),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.loading),
          isA<HistoryState>()
              .having((s) => s.status, 'status', HistoryStatus.success)
              .having((s) => s.isSearching, 'isSearching', true),
        ],
      );
    });

    group('HistoryState - 計算プロパティ', () {
      test('totalPages: 総ページ数を正しく計算', () {
        final state = const HistoryState(
          totalCount: 50,
          pageSize: 20,
        );
        expect(state.totalPages, 3); // ceil(50/20) = 3
      });

      test('totalPages: データがない場合は1を返す', () {
        const state = HistoryState(
          totalCount: 0,
          pageSize: 20,
        );
        expect(state.totalPages, 1);
      });

      test('hasData: データがある場合はtrue', () {
        final state = HistoryState(
          incidents: [mockIncident],
        );
        expect(state.hasData, true);
      });

      test('isLoading: ローディング中の判定', () {
        const state = HistoryState(status: HistoryStatus.loading);
        expect(state.isLoading, true);
      });

      test('isSearching: 検索条件がある場合はtrue', () {
        const state = HistoryState(
          searchFilters: {'roomNumber': '101'},
        );
        expect(state.isSearching, true);
      });
    });
  });
}
