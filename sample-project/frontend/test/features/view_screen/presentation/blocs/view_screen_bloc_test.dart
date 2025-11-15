import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mamoai/core/error/failures.dart';
import 'package:mamoai/features/view_screen/application/usecases/get_incident_items_usecase.dart';
import 'package:mamoai/features/view_screen/application/usecases/update_incident_status_usecase.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_item.dart';
import 'package:mamoai/features/view_screen/domain/entities/incident_status.dart';
import 'package:mamoai/features/view_screen/domain/repositories/i_view_screen_repository.dart';
import 'package:mamoai/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_bloc.dart';
import 'package:mamoai/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_event.dart';
import 'package:mamoai/features/view_screen/presentation/blocs/view_screen_bloc/view_screen_state.dart';

@GenerateMocks([
  GetIncidentItemsUseCase,
  UpdateIncidentStatusUseCase,
  IViewScreenRepository,
])
import 'view_screen_bloc_test.mocks.dart';

void main() {
  late ViewScreenBloc bloc;
  late MockGetIncidentItemsUseCase mockGetIncidentItemsUseCase;
  late MockUpdateIncidentStatusUseCase mockUpdateIncidentStatusUseCase;
  late MockIViewScreenRepository mockRepository;

  setUp(() {
    mockGetIncidentItemsUseCase = MockGetIncidentItemsUseCase();
    mockUpdateIncidentStatusUseCase = MockUpdateIncidentStatusUseCase();
    mockRepository = MockIViewScreenRepository();

    bloc = ViewScreenBloc(
      getIncidentItemsUseCase: mockGetIncidentItemsUseCase,
      updateIncidentStatusUseCase: mockUpdateIncidentStatusUseCase,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ViewScreenBloc', () {
    final tIncidentItems = [
      const IncidentItem(
        id: '1',
        roomBedNumber: '101-A',
        personName: '山田 太郎',
        detectionType: '起床',
        status: IncidentStatus.unhandled,
      ),
      const IncidentItem(
        id: '2',
        roomBedNumber: '102-B',
        personName: '佐藤 花子',
        detectionType: '離床',
        status: IncidentStatus.inProgress,
      ),
    ];

    test('初期状態はViewScreenInitial', () {
      expect(bloc.state, equals(const ViewScreenInitial()));
    });

    blocTest<ViewScreenBloc, ViewScreenState>(
      'LoadIncidentItemsイベントで成功時、ViewScreenLoadedを返す',
      build: () {
        when(mockGetIncidentItemsUseCase.call())
            .thenAnswer((_) async => Right(tIncidentItems));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadIncidentItems()),
      expect: () => [
        const ViewScreenLoading(),
        ViewScreenLoaded(items: tIncidentItems),
      ],
      verify: (_) {
        verify(mockGetIncidentItemsUseCase.call()).called(1);
      },
    );

    blocTest<ViewScreenBloc, ViewScreenState>(
      'LoadIncidentItemsイベントで失敗時、ViewScreenErrorを返す',
      build: () {
        when(mockGetIncidentItemsUseCase.call()).thenAnswer(
          (_) async => Left(ServerFailure('Server Error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadIncidentItems()),
      expect: () => [
        const ViewScreenLoading(),
        const ViewScreenError(message: 'Server Error'),
      ],
      verify: (_) {
        verify(mockGetIncidentItemsUseCase.call()).called(1);
      },
    );

    blocTest<ViewScreenBloc, ViewScreenState>(
      'UpdateIncidentStatusイベントで成功時、更新されたアイテムを含むViewScreenLoadedを返す',
      build: () {
        final updatedItem = tIncidentItems[0].copyWith(
          status: IncidentStatus.inProgress,
        );
        when(mockUpdateIncidentStatusUseCase.call(any))
            .thenAnswer((_) async => Right(updatedItem));
        return bloc;
      },
      seed: () => ViewScreenLoaded(items: tIncidentItems),
      act: (bloc) => bloc.add(
        const UpdateIncidentStatus(
          incidentId: '1',
          newStatus: IncidentStatus.inProgress,
          actionType: 'start',
        ),
      ),
      expect: () => [
        ViewScreenUpdating(
          items: tIncidentItems,
          updatingItemId: '1',
        ),
        isA<ViewScreenLoaded>().having(
          (state) => state.items.first.status,
          'first item status',
          IncidentStatus.inProgress,
        ),
      ],
      verify: (_) {
        verify(mockUpdateIncidentStatusUseCase.call(any)).called(1);
      },
    );

    blocTest<ViewScreenBloc, ViewScreenState>(
      'UpdateIncidentStatusイベントで失敗時、エラーを表示して元の状態に戻る',
      build: () {
        when(mockUpdateIncidentStatusUseCase.call(any)).thenAnswer(
          (_) async => Left(ServerFailure('Update Failed')),
        );
        return bloc;
      },
      seed: () => ViewScreenLoaded(items: tIncidentItems),
      act: (bloc) => bloc.add(
        const UpdateIncidentStatus(
          incidentId: '1',
          newStatus: IncidentStatus.inProgress,
          actionType: 'start',
        ),
      ),
      expect: () => [
        ViewScreenUpdating(
          items: tIncidentItems,
          updatingItemId: '1',
        ),
        ViewScreenLoaded(items: tIncidentItems),
        const ViewScreenError(message: 'Update Failed'),
        ViewScreenLoaded(items: tIncidentItems),
      ],
      verify: (_) {
        verify(mockUpdateIncidentStatusUseCase.call(any)).called(1);
      },
    );

    blocTest<ViewScreenBloc, ViewScreenState>(
      'ToggleAlertStatusイベントで成功時、更新されたアイテムを含むViewScreenLoadedを返す',
      build: () {
        final updatedItem = tIncidentItems[0].copyWith(
          isAlertActive: false,
        );
        when(mockRepository.toggleAlertStatus(
          id: anyNamed('id'),
          isActive: anyNamed('isActive'),
        )).thenAnswer((_) async => Right(updatedItem));
        return bloc;
      },
      seed: () => ViewScreenLoaded(items: tIncidentItems),
      act: (bloc) => bloc.add(
        const ToggleAlertStatus(
          incidentId: '1',
          isActive: false,
        ),
      ),
      expect: () => [
        ViewScreenUpdating(
          items: tIncidentItems,
          updatingItemId: '1',
        ),
        isA<ViewScreenLoaded>().having(
          (state) => state.items.first.isAlertActive,
          'first item alert status',
          false,
        ),
      ],
      verify: (_) {
        verify(mockRepository.toggleAlertStatus(
          id: '1',
          isActive: false,
        )).called(1);
      },
    );

    blocTest<ViewScreenBloc, ViewScreenState>(
      'RefreshIncidentItemsイベントでViewScreenLoaded状態から成功時、新しいデータでViewScreenLoadedを返す',
      build: () {
        when(mockGetIncidentItemsUseCase.call())
            .thenAnswer((_) async => Right(tIncidentItems));
        return bloc;
      },
      seed: () => ViewScreenLoaded(items: const []),
      act: (bloc) => bloc.add(const RefreshIncidentItems()),
      expect: () => [
        ViewScreenLoaded(items: tIncidentItems),
      ],
      verify: (_) {
        verify(mockGetIncidentItemsUseCase.call()).called(1);
      },
    );
  });

  group('ViewScreenLoaded State', () {
    test('detectedItemsは異常検知中のアイテムのみを返す', () {
      final items = [
        const IncidentItem(
          id: '1',
          roomBedNumber: '101-A',
          personName: '山田 太郎',
          detectionType: '起床',
          status: IncidentStatus.unhandled,
        ),
        const IncidentItem(
          id: '2',
          roomBedNumber: '102-B',
          personName: '佐藤 花子',
          detectionType: '離床',
          status: IncidentStatus.inProgress,
        ),
        const IncidentItem(
          id: '3',
          roomBedNumber: '103-A',
          personName: '鈴木 一郎',
          detectionType: '臥床',
          status: IncidentStatus.noDetection,
        ),
      ];

      final state = ViewScreenLoaded(items: items);

      expect(state.detectedItems.length, 2);
      expect(state.detectedItems[0].id, '1');
      expect(state.detectedItems[1].id, '2');
    });

    test('noDetectionItemsは検知なしのアイテムのみを返す', () {
      final items = [
        const IncidentItem(
          id: '1',
          roomBedNumber: '101-A',
          personName: '山田 太郎',
          detectionType: '起床',
          status: IncidentStatus.unhandled,
        ),
        const IncidentItem(
          id: '3',
          roomBedNumber: '103-A',
          personName: '鈴木 一郎',
          detectionType: '臥床',
          status: IncidentStatus.noDetection,
        ),
      ];

      final state = ViewScreenLoaded(items: items);

      expect(state.noDetectionItems.length, 1);
      expect(state.noDetectionItems[0].id, '3');
    });
  });
}
