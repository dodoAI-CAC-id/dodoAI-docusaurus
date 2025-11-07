import 'package:flutter/material.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/themes/app_typography.dart';

/// ページネーションコンポーネント
/// 
/// 複数ページの履歴データを切り替えるためのページネーション機能を提供します。
class Pagination extends StatelessWidget {
  /// 現在のページ番号（1始まり）
  final int currentPage;

  /// 総ページ数
  final int totalPages;

  /// ページ変更時のコールバック
  final ValueChanged<int> onPageChanged;

  /// 一度に表示するページボタンの最大数
  final int maxVisiblePages;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.maxVisiblePages = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 最初へ
        IconButton(
          icon: const Icon(Icons.first_page),
          onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
          tooltip: '最初',
        ),
        // 前へ
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          tooltip: '前へ',
        ),
        // ページ番号ボタン
        ..._buildPageNumbers(),
        // 次へ
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
          tooltip: '次へ',
        ),
        // 最後へ
        IconButton(
          icon: const Icon(Icons.last_page),
          onPressed: currentPage < totalPages ? () => onPageChanged(totalPages) : null,
          tooltip: '最後',
        ),
      ],
    );
  }

  /// ページ番号ボタンのリストを生成
  List<Widget> _buildPageNumbers() {
    final List<Widget> pageButtons = [];

    if (totalPages <= maxVisiblePages) {
      // 総ページ数が最大表示数以下の場合、すべてのページを表示
      for (int i = 1; i <= totalPages; i++) {
        pageButtons.add(_buildPageButton(i));
      }
    } else {
      // 総ページ数が多い場合、省略記号を使用
      final int halfVisible = (maxVisiblePages - 3) ~/ 2;

      // 最初のページ
      pageButtons.add(_buildPageButton(1));

      if (currentPage <= halfVisible + 2) {
        // 現在のページが前半にある場合
        for (int i = 2; i <= maxVisiblePages - 2; i++) {
          pageButtons.add(_buildPageButton(i));
        }
        pageButtons.add(_buildEllipsis());
      } else if (currentPage >= totalPages - halfVisible - 1) {
        // 現在のページが後半にある場合
        pageButtons.add(_buildEllipsis());
        for (int i = totalPages - maxVisiblePages + 3; i < totalPages; i++) {
          pageButtons.add(_buildPageButton(i));
        }
      } else {
        // 現在のページが中間にある場合
        pageButtons.add(_buildEllipsis());
        for (int i = currentPage - halfVisible; i <= currentPage + halfVisible; i++) {
          pageButtons.add(_buildPageButton(i));
        }
        pageButtons.add(_buildEllipsis());
      }

      // 最後のページ
      pageButtons.add(_buildPageButton(totalPages));
    }

    return pageButtons;
  }

  /// ページ番号ボタンを生成
  Widget _buildPageButton(int page) {
    final bool isCurrentPage = page == currentPage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: isCurrentPage
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4.0),
              ),
              alignment: Alignment.center,
              child: Text(
                page.toString(),
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : InkWell(
              onTap: () => onPageChanged(page),
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  page.toString(),
                  style: AppTypography.bodyMedium,
                ),
              ),
            ),
    );
  }

  /// 省略記号を生成
  Widget _buildEllipsis() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            '...',
            style: AppTypography.bodyMedium,
          ),
        ),
      ),
    );
  }
}
