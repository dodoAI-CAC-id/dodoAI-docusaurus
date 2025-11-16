import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/incident_status.dart';
import '../blocs/view_screen_bloc/view_screen_bloc.dart';
import '../blocs/view_screen_bloc/view_screen_event.dart';
import '../blocs/view_screen_bloc/view_screen_state.dart';
import '../widgets/molecules/incident_item_card.dart';
import 'package:mamoai/shared/presentation/components/organisms/app_header.dart';
import 'package:mamoai/features/incident_history/presentation/widgets/molecules/qr_code_dialog.dart';
import 'package:mamoai/features/incident_history/presentation/pages/incident_history_page.dart';

/// ビュー画面（Page）
/// デザイン画像に基づいたグリッドレイアウト実装
class ViewScreenPage extends StatefulWidget {
  const ViewScreenPage({super.key});

  @override
  State<ViewScreenPage> createState() => _ViewScreenPageState();
}

class _ViewScreenPageState extends State<ViewScreenPage> {
  @override
  void initState() {
    super.initState();
    // 初回データ読み込み
    context.read<ViewScreenBloc>().add(const LoadIncidentItems());
  }

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
              // 現在のページなので何もしない
            },
            onReloadPressed: () {
              // 履歴画面へ遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IncidentHistoryPage(),
                ),
              );
            },
            onSettingsPressed: () {
              // TODO: 設定画面へ遷移
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('設定画面への遷移（未実装）')),
              );
            },
          ),
          
          // メインコンテンツ
          Expanded(
            child: BlocConsumer<ViewScreenBloc, ViewScreenState>(
        listener: (context, state) {
          // エラー時にSnackBarを表示
          if (state is ViewScreenError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: '再試行',
                  textColor: Colors.white,
                  onPressed: () {
                    context
                        .read<ViewScreenBloc>()
                        .add(const LoadIncidentItems());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ViewScreenLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ViewScreenLoaded || state is ViewScreenUpdating) {
            final items = state is ViewScreenLoaded
                ? state.items
                : (state as ViewScreenUpdating).items;
            final detectedItems = state is ViewScreenLoaded
                ? state.detectedItems
                : items.where((item) => item.isDetected).toList();
            final noDetectionItems = state is ViewScreenLoaded
                ? state.noDetectionItems
                : items.where((item) => !item.isDetected).toList();
            final highlightedItemId = state is ViewScreenLoaded
                ? state.highlightedItemId
                : null;

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ViewScreenBloc>()
                    .add(const RefreshIncidentItems());
                // 更新完了を待つ
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 異常検知中セクション
                    if (detectedItems.isNotEmpty) ...[
                      _buildSectionHeader(
                        '異常検知一覧',
                        detectedItems.length,
                        Colors.red,
                      ),
                      _buildGridView(
                        context,
                        detectedItems,
                        highlightedItemId,
                        (item) => item, // アクションボタンは各カード内で処理
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 検知なしセクション
                    if (noDetectionItems.isNotEmpty) ...[
                      _buildSectionHeader(
                        'ご利用者一覧',
                        noDetectionItems.length,
                        Colors.grey,
                      ),
                      _buildGridView(
                        context,
                        noDetectionItems,
                        highlightedItemId,
                        (item) => item, // アラート切替ボタンを表示
                      ),
                    ],

                    // データが空の場合
                    if (items.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'データがありません',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          // 初期状態またはエラー後の状態
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'データの読み込みに失敗しました',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<ViewScreenBloc>()
                        .add(const LoadIncidentItems());
                  },
                  child: const Text('再読み込み'),
                ),
              ],
            ),
          );
        },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: color.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(Icons.circle, size: 12, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(
    BuildContext context,
    List items,
    String? highlightedItemId,
    Function(dynamic)? onActionButtonPressed,
  ) {
    // レスポンシブ対応：画面幅に応じてカラム数を調整（最大5列）
    return LayoutBuilder(
      builder: (context, constraints) {
        const minCardWidth = 240.0;
        final crossAxisCount = (constraints.maxWidth / minCardWidth)
            .floor()
            .clamp(1, 5);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.8, // カードの縦横比
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return IncidentItemCard(
              item: item,
              isHighlighted: highlightedItemId == item.id,
              onTap: () => _showIncidentDetail(context, item),
              onActionButtonPressed: onActionButtonPressed != null
                  ? (actionType) => _handleAction(context, item, actionType)
                  : null,
            );
          },
        );
      },
    );
  }

  void _handleAction(BuildContext context, item, String actionType) {
    switch (actionType) {
      case 'start_response':
        _handleStartResponse(context, item);
        break;
      case 'no_visit_needed':
        _handleNoVisitNeeded(context, item);
        break;
      case 'false_detection':
        _handleFalseDetection(context, item);
        break;
      case 'revert':
        _handleRevert(context, item);
        break;
      case 'complete':
        _handleComplete(context, item);
        break;
      case 'toggle_alert':
        _handleToggleAlert(context, item);
        break;
    }
  }

  void _handleStartResponse(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('対応開始'),
        content: Text('${item.roomBedNumber} の対応を開始しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ViewScreenBloc>().add(
                    UpdateIncidentStatus(
                      incidentId: item.id,
                      newStatus: IncidentStatus.inProgress,
                      actionType: 'start_response',
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.roomBedNumber} の対応を開始しました'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('対応開始'),
          ),
        ],
      ),
    );
  }

  void _handleNoVisitNeeded(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('訪室不要'),
        content: Text('${item.roomBedNumber} は訪室不要として処理しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ViewScreenBloc>().add(
                    UpdateIncidentStatus(
                      incidentId: item.id,
                      newStatus: IncidentStatus.noDetection,
                      actionType: 'no_visit_needed',
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.roomBedNumber} を訪室不要として処理しました'),
                ),
              );
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  void _handleFalseDetection(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('誤検知'),
        content: Text('${item.roomBedNumber} を誤検知として処理しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ViewScreenBloc>().add(
                    UpdateIncidentStatus(
                      incidentId: item.id,
                      newStatus: IncidentStatus.noDetection,
                      actionType: 'false_detection',
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.roomBedNumber} を誤検知として処理しました'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  void _handleRevert(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('対応を戻す'),
        content: Text('${item.roomBedNumber} の対応を未対応に戻しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ViewScreenBloc>().add(
                    UpdateIncidentStatus(
                      incidentId: item.id,
                      newStatus: IncidentStatus.unhandled,
                      actionType: 'revert',
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.roomBedNumber} を未対応に戻しました'),
                ),
              );
            },
            child: const Text('戻す'),
          ),
        ],
      ),
    );
  }

  void _handleComplete(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('対応完了'),
        content: Text('${item.roomBedNumber} の対応を完了しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ViewScreenBloc>().add(
                    UpdateIncidentStatus(
                      incidentId: item.id,
                      newStatus: IncidentStatus.noDetection,
                      actionType: 'complete',
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.roomBedNumber} の対応を完了しました'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('完了'),
          ),
        ],
      ),
    );
  }

  void _handleToggleAlert(BuildContext context, item) {
    final newAlertStatus = !item.isAlertActive;
    context.read<ViewScreenBloc>().add(
          ToggleAlertStatus(
            incidentId: item.id,
            isActive: newAlertStatus,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.roomBedNumber} のアラートを${newAlertStatus ? "稼働" : "停止"}しました',
        ),
      ),
    );
  }

  void _showIncidentDetail(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.roomBedNumber),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('見守り対象者: ${item.personName}'),
            Text('異常姿勢: ${item.detectionType}'),
            Text('ステータス: ${item.status.displayName}'),
            if (item.detectedAt != null)
              Text('検知日時: ${item.detectedAt}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}
