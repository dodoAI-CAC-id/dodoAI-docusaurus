import 'package:flutter/material.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text.dart';

/// ページネーションコントロールのOrganismコンポーネント
/// ページ切り替えボタンとページ情報を表示
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int? totalCount;
  final ValueChanged<int> onPageChanged;

  const PaginationControls({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.totalCount,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 総件数表示
          if (totalCount != null)
            AppText(
              text: '全 $totalCount 件',
              type: TextStyleType.body2,
            )
          else
            const SizedBox.shrink(),

          // ページネーションコントロール
          Row(
            children: [
              // 最初のページへ
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: currentPage > 1
                    ? () => onPageChanged(1)
                    : null,
                tooltip: '最初のページ',
              ),
              const SizedBox(width: 8),

              // 前のページへ
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 1
                    ? () => onPageChanged(currentPage - 1)
                    : null,
                tooltip: '前のページ',
              ),
              const SizedBox(width: 16),

              // 現在のページ / 総ページ数
              AppText(
                text: '$currentPage / $totalPages',
                type: TextStyleType.body1,
              ),
              const SizedBox(width: 16),

              // 次のページへ
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPages
                    ? () => onPageChanged(currentPage + 1)
                    : null,
                tooltip: '次のページ',
              ),
              const SizedBox(width: 8),

              // 最後のページへ
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: currentPage < totalPages
                    ? () => onPageChanged(totalPages)
                    : null,
                tooltip: '最後のページ',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
