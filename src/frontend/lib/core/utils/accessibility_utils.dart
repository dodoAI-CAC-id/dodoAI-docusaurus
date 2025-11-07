import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// アクセシビリティユーティリティクラス
/// 
/// スクリーンリーダー対応、キーボードナビゲーション、
/// セマンティックラベルなどのアクセシビリティ機能を提供します。
class AccessibilityUtils {
  /// セマンティックラベルを生成（日時用）
  static String dateTimeLabel(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 '
        '${dateTime.hour}時${dateTime.minute}分';
  }

  /// セマンティックラベルを生成（ステータス用）
  static String statusLabel(String status) {
    final statusMap = {
      '検知済み': '検知済み、未対応',
      '確認済み': '確認済み、対応待ち',
      '対応中': '現在対応中',
      '解決済み': '対応完了、解決済み',
    };
    return statusMap[status] ?? status;
  }

  /// セマンティックラベルを生成（ページネーション用）
  static String paginationLabel(int currentPage, int totalPages) {
    return '全${totalPages}ページ中${currentPage}ページ目';
  }

  /// セマンティックラベルを生成（動画再生ボタン用）
  static String videoPlayLabel(String incidentId) {
    return '履歴番号${incidentId}の動画を再生';
  }

  /// セマンティックラベルを生成（動画ダウンロードボタン用）
  static String videoDownloadLabel(String incidentId) {
    return '履歴番号${incidentId}の動画をダウンロード';
  }

  /// テーブル行のセマンティックラベルを生成
  static String tableRowLabel({
    required String incidentId,
    required String date,
    required String time,
    required String roomBed,
    required String patientName,
    required String detectedAction,
    required String status,
  }) {
    return '履歴番号${incidentId}、'
        '${date} ${time}、'
        '${roomBed}、'
        '${patientName}、'
        '異常検出動作：${detectedAction}、'
        'ステータス：${statusLabel(status)}';
  }
}

/// キーボードナビゲーション用のショートカットクラス
class KeyboardShortcuts {
  /// 検索フォーカス (Ctrl+F / Cmd+F)
  static final searchFocus = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyF,
  );

  /// リフレッシュ (Ctrl+R / Cmd+R)
  static final refresh = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyR,
  );

  /// 次のページ (Ctrl+→ / Cmd+→)
  static final nextPage = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.arrowRight,
  );

  /// 前のページ (Ctrl+← / Cmd+←)
  static final previousPage = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.arrowLeft,
  );

  /// モーダルを閉じる (Esc)
  static final closeModal = LogicalKeySet(
    LogicalKeyboardKey.escape,
  );

  /// ヘルプを表示 (F1)
  static final showHelp = LogicalKeySet(
    LogicalKeyboardKey.f1,
  );
}

/// Focus管理用のヘルパークラス
class FocusHelper {
  /// 次のフォーカス可能な要素にフォーカスを移動
  static void moveFocusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// 前のフォーカス可能な要素にフォーカスを移動
  static void moveFocusPrevious(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// 指定したノードにフォーカスを移動
  static void requestFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  /// フォーカスをクリア
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// 現在フォーカスされているかチェック
  static bool isFocused(FocusNode node) {
    return node.hasFocus;
  }
}

/// スクリーンリーダー用のアナウンスヘルパー
class ScreenReaderAnnouncer {
  /// ライブリージョンでアナウンス
  static void announce(
    BuildContext context,
    String message, {
    bool assertive = false,
  }) {
    // Semanticsウィジェットを使用してアナウンス
    // Flutter 3.x以降では TextDirection が必要
    SemanticsService.announce(
      message,
      Directionality.of(context),
    );
  }

  /// ページ読み込み完了をアナウンス
  static void announcePageLoaded(
    BuildContext context,
    int itemCount,
  ) {
    announce(
      context,
      'ページの読み込みが完了しました。${itemCount}件のデータが表示されています。',
    );
  }

  /// エラーをアナウンス
  static void announceError(
    BuildContext context,
    String errorMessage,
  ) {
    announce(
      context,
      'エラーが発生しました。${errorMessage}',
      assertive: true,
    );
  }

  /// 検索結果をアナウンス
  static void announceSearchResult(
    BuildContext context,
    int resultCount,
  ) {
    announce(
      context,
      '検索が完了しました。${resultCount}件の結果が見つかりました。',
    );
  }

  /// アクション成功をアナウンス
  static void announceSuccess(
    BuildContext context,
    String message,
  ) {
    announce(context, '成功しました。${message}');
  }
}

/// カラーコントラストチェッカー
class ContrastChecker {
  /// WCAG 2.1のコントラスト比を計算
  static double calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();
    
    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// WCAG AA基準を満たしているかチェック（通常テキスト: 4.5:1）
  static bool meetsWCAGAA(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 4.5;
  }

  /// WCAG AAA基準を満たしているかチェック（通常テキスト: 7:1）
  static bool meetsWCAGAAA(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 7.0;
  }

  /// 大きなテキスト用のWCAG AA基準（3:1）
  static bool meetsWCAGAALarge(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 3.0;
  }
}

/// タッチターゲットサイズチェッカー
class TouchTargetChecker {
  /// WCAG 2.1の最小タッチターゲットサイズ（44x44 dp）
  static const double minTouchTargetSize = 44.0;

  /// 推奨タッチターゲットサイズ（48x48 dp）
  static const double recommendedTouchTargetSize = 48.0;

  /// タッチターゲットサイズが十分かチェック
  static bool isTouchTargetSufficient(double width, double height) {
    return width >= minTouchTargetSize && height >= minTouchTargetSize;
  }

  /// 推奨サイズかチェック
  static bool isTouchTargetRecommended(double width, double height) {
    return width >= recommendedTouchTargetSize && 
           height >= recommendedTouchTargetSize;
  }

  /// パディングを追加して最小サイズを確保
  static EdgeInsets ensureMinimumSize(double width, double height) {
    final horizontalPadding = 
        (minTouchTargetSize - width).clamp(0.0, double.infinity) / 2;
    final verticalPadding = 
        (minTouchTargetSize - height).clamp(0.0, double.infinity) / 2;
    
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );
  }
}
