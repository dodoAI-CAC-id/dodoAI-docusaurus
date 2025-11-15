/// 異常検知のステータスを表すEnum
enum IncidentStatus {
  /// 未対応：異常検知が発生したが、まだスタッフが対応を開始していない状態
  unhandled('未対応', 'unhandled'),

  /// 対応中：スタッフが対応を開始した状態
  inProgress('対応中', 'in_progress'),

  /// 検知なし：異常検知が発生していない、または対応が完了した状態
  noDetection('検知なし', 'no_detection');

  const IncidentStatus(this.displayName, this.value);

  /// 表示用の名前
  final String displayName;

  /// API通信用の値
  final String value;

  /// API値からIncidentStatusを取得
  static IncidentStatus fromValue(String value) {
    return IncidentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => IncidentStatus.noDetection,
    );
  }

  /// 背景色を取得（UI用）
  String get backgroundColor {
    switch (this) {
      case IncidentStatus.unhandled:
        return '#FFF9C4'; // 黄色
      case IncidentStatus.inProgress:
        return '#C8E6C9'; // 緑色
      case IncidentStatus.noDetection:
        return '#E0E0E0'; // 灰色
    }
  }

  /// ステータスが異常検知中かどうか
  bool get isDetected {
    return this == IncidentStatus.unhandled ||
        this == IncidentStatus.inProgress;
  }
}
