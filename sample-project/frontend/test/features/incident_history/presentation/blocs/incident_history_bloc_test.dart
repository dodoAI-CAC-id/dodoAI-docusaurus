import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_bloc.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_event.dart';
import 'package:mamoai/features/incident_history/presentation/blocs/incident_history_bloc/incident_history_state.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_incidents_usecase.dart';
import 'package:mamoai/features/incident_history/application/usecases/get_video_usecase.dart';
import 'package:mamoai/features/incident_history/domain/entities/incident.dart';
import 'package:mamoai/features/incident_history/domain/entities/pagination_info.dart';
import 'package:mamoai/features/incident_history/domain/repositories/i_incident_repository.dart';
import 'package:mamoai/core/error/failures.dart';

import 'incident_history_bloc_test.mocks.dart';

@GenerateMocks([GetIncidentsUseCase, GetVideoUseCase])
void main() {
  late IncidentHistoryBloc bloc;
  late MockGetIncidentsUseCase mockGetIncidentsUseCase;
  late MockGetVideoUseCase mockGetVideoUseCase;

  setUp(() {
    mockGetIncidentsUseCase = MockGetIncidentsUseCase();
    mockGetVideoUseCase = MockGetVideoUseCase();
    bloc = IncidentHistoryBloc(
      getIncidentsUseCase: mockGetIncidentsUseCase,
      getVideoUseCase: mockGetVideoUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('IncidentHistoryBloc', () {
    final tIncidents = [
      Incident(
        id: '001',
        detectedAt: DateTime(2025, 2, 25, 12, 14, 59),
        type: '転倒',
        personId: 'TWO2-02',
        personName: '山田太郎',
        roomNumber: '101',
        status: 'open',
        videoId: 'video_001',
        createdAt: DateTime(2025, 2, 25, 12, 14, 59),
        updatedAt: DateTime(2025, 2, 25, 12, 14, 59),
      ),
    ];

    final tPaginationInfo = PaginationInfo.fromTotalCount(
      totalCount: 1,
      limit: 20,
      currentPage: 1,
    );

    final tIncidentListResult = IncidentListResult(
      incidents: tIncidents,
      paginationInfo: tPaginationInfo,
    );

    test('initial state should be IncidentHistoryInitial', () {
      expect(bloc.state, equals(IncidentHistoryInitial()));
    });

    blocTest<IncidentHistoryBloc, IncidentHistoryState>(
      'should emit [Loading, Loaded] when LoadIncidentsEvent is added',
      build: () {
        when(mockGetIncidentsUseCase(any))
            .thenAnswer((_) async => Right(tIncidentListResult));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadIncidentsEvent()),
      expect: () => [
        IncidentHistoryLoading(),
        IncidentHistoryLoaded(
          incidents: tIncidents,
          paginationInfo: tPaginationInfo,
        ),
      ],
    );

    blocTest<IncidentHistoryBloc, IncidentHistoryState>(
      'should emit [Loading, Error] when LoadIncidentsEvent fails',
      build: () {
        when(mockGetIncidentsUseCase(any))
            .thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadIncidentsEvent()),
      expect: () => [
        IncidentHistoryLoading(),
        const IncidentHistoryError('Server error'),
      ],
    );

    blocTest<IncidentHistoryBloc, IncidentHistoryState>(
      'should emit [Loading, Loaded] when SearchIncidentsEvent is added',
      build: () {
        when(mockGetIncidentsUseCase(any))
            .thenAnswer((_) async => Right(tIncidentListResult));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchIncidentsEvent(
        personId: 'TWO2-02',
        status: 'open',
      )),
      expect: () => [
        IncidentHistoryLoading(),
        IncidentHistoryLoaded(
          incidents: tIncidents,
          paginationInfo: tPaginationInfo,
        ),
      ],
    );

    blocTest<IncidentHistoryBloc, IncidentHistoryState>(
      'should emit [Loading, Loaded] when ChangePageEvent is added',
      build: () {
        when(mockGetIncidentsUseCase(any))
            .thenAnswer((_) async => Right(tIncidentListResult));
        return bloc;
      },
      act: (bloc) => bloc.add(const ChangePageEvent(2)),
      expect: () => [
        IncidentHistoryLoading(),
        IncidentHistoryLoaded(
          incidents: tIncidents,
          paginationInfo: tPaginationInfo,
        ),
      ],
    );

    blocTest<IncidentHistoryBloc, IncidentHistoryState>(
      'should emit [VideoPlaying] when PlayVideoEvent is added',
      build: () {
        when(mockGetVideoUseCase(any))
            .thenAnswer((_) async => const Right('https://example.com/video.mp4'));
        return bloc;
      },
      act: (bloc) => bloc.add(const PlayVideoEvent('video_001')),
      expect: () => [
        const VideoPlayingState('https://example.com/video.mp4'),
      ],
    );

    blocTest<IncidentHistoryBloc, IncidentHistoryState>(
      'should emit [Error] when PlayVideoEvent fails',
      build: () {
        when(mockGetVideoUseCase(any))
            .thenAnswer((_) async => const Left(ServerFailure('Video not found')));
        return bloc;
      },
      act: (bloc) => bloc.add(const PlayVideoEvent('video_001')),
      expect: () => [
        const IncidentHistoryError('Video not found'),
      ],
    );
  });
}
