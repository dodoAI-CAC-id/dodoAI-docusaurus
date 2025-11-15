import 'package:flutter/material.dart';
import '../../../domain/entities/incident_status.dart';

/// ステータス表示バッジ
class StatusBadge extends StatelessWidget {
  final IncidentStatus status;
  final double? fontSize;
  final bool? isAlertActive;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize,
    this.isAlertActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Text(
        _getDisplayText(),
        style: TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: FontWeight.bold,
          color: _getTextColor(),
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (status == IncidentStatus.noDetection && isAlertActive != null) {
      return isAlertActive! ? 'アラート稼働中' : 'アラート停止中';
    }
    return status.displayName;
  }

  Color _getBackgroundColor() {
    if (status == IncidentStatus.noDetection && isAlertActive != null) {
      return isAlertActive!
          ? const Color(0xFFC8E6C9) // 稼働中: 緑色
          : const Color(0xFFE0E0E0); // 停止中: 灰色
    }
    
    switch (status) {
      case IncidentStatus.unhandled:
        return const Color(0xFFFFF9C4); // 黄色
      case IncidentStatus.inProgress:
        return const Color(0xFFC8E6C9); // 緑色
      case IncidentStatus.noDetection:
        return const Color(0xFFE0E0E0); // 灰色
    }
  }

  Color _getBorderColor() {
    if (status == IncidentStatus.noDetection && isAlertActive != null) {
      return isAlertActive!
          ? const Color(0xFF66BB6A) // 稼働中: 濃い緑色
          : const Color(0xFF9E9E9E); // 停止中: 濃い灰色
    }
    
    switch (status) {
      case IncidentStatus.unhandled:
        return const Color(0xFFFBC02D); // 濃い黄色
      case IncidentStatus.inProgress:
        return const Color(0xFF66BB6A); // 濃い緑色
      case IncidentStatus.noDetection:
        return const Color(0xFF9E9E9E); // 濃い灰色
    }
  }

  Color _getTextColor() {
    if (status == IncidentStatus.noDetection && isAlertActive != null) {
      return isAlertActive!
          ? const Color(0xFF2E7D32) // 稼働中: ダークグリーン
          : const Color(0xFF424242); // 停止中: ダークグレー
    }
    
    switch (status) {
      case IncidentStatus.unhandled:
        return const Color(0xFFF57F17); // ダークイエロー
      case IncidentStatus.inProgress:
        return const Color(0xFF2E7D32); // ダークグリーン
      case IncidentStatus.noDetection:
        return const Color(0xFF424242); // ダークグレー
    }
  }
}
