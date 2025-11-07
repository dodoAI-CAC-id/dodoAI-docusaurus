/// テーブルカラム定義モデルクラス
class TableColumn {
  /// カラムラベル（表示名）
  final String label;

  /// カラム幅（ピクセル）
  final double width;

  /// ソート可能かどうか
  final bool sortable;

  /// カラムキー（ソート時の識別用）
  final String? key;

  const TableColumn({
    required this.label,
    required this.width,
    this.sortable = false,
    this.key,
  });

  @override
  String toString() {
    return 'TableColumn(label: $label, width: $width, sortable: $sortable, key: $key)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableColumn &&
        other.label == label &&
        other.width == width &&
        other.sortable == sortable &&
        other.key == key;
  }

  @override
  int get hashCode {
    return label.hashCode ^ width.hashCode ^ sortable.hashCode ^ key.hashCode;
  }
}
