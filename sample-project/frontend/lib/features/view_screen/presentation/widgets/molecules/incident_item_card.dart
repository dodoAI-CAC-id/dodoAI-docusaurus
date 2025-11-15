import 'package:flutter/material.dart';
import '../../../domain/entities/incident_item.dart';
import '../../../domain/entities/incident_status.dart';
import '../atoms/status_badge.dart';

/// インシデントアイテムカード（Molecule）
/// デザイン画像に基づいた実装
class IncidentItemCard extends StatefulWidget {
  final IncidentItem item;
  final VoidCallback? onTap;
  final Function(String actionType)? onActionButtonPressed;

  const IncidentItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onActionButtonPressed,
  });

  @override
  State<IncidentItemCard> createState() => _IncidentItemCardState();
}

class _IncidentItemCardState extends State<IncidentItemCard> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー（部屋番号 + 見守り対象者名 + 患者ID + ステータスバッジ）
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bed, 
                              color: Colors.grey.shade700, 
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.item.roomBedNumber,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.item.personName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (widget.item.cameraId != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.item.cameraId!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  StatusBadge(
                    status: widget.item.status,
                    fontSize: 11,
                    isAlertActive: widget.item.isAlertActive,
                  ),
                ],
              ),
            ),

            // 異常姿勢表示
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.item.detectionType,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 画像表示エリア
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // 異常姿勢アイコン
                    Expanded(
                      flex: 1,
                      child: _buildPostureIcon(),
                    ),
                    const SizedBox(width: 8),
                    // 検知画像
                    Expanded(
                      flex: 2,
                      child: widget.item.isDetected
                          ? _buildDetectionImage()
                          : _buildNoDetectionPlaceholder(),
                    ),
                  ],
                ),
              ),
            ),

            // アクションボタン
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBorderColor() {
    switch (widget.item.status) {
      case IncidentStatus.unhandled:
        return Colors.amber.shade200;
      case IncidentStatus.inProgress:
        return Colors.green.shade200;
      case IncidentStatus.noDetection:
        return Colors.grey.shade300;
    }
  }

  Widget _buildPostureIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          _getPostureIcon(),
          size: 48,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  IconData _getPostureIcon() {
    final type = widget.item.detectionType.toLowerCase();
    if (type.contains('起床') || type.contains('端坐位')) {
      return Icons.airline_seat_recline_normal;
    } else if (type.contains('転倒')) {
      return Icons.personal_injury;
    } else if (type.contains('離床')) {
      return Icons.directions_walk;
    } else {
      return Icons.bed;
    }
  }

  Widget _buildDetectionImage() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(
              Icons.image,
              size: 36,
              color: Colors.white54,
            ),
          ),
        ),
        // 画像切り替えボタン
        Positioned(
          left: 2,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon: Icon(Icons.chevron_left, 
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _currentImageIndex = (_currentImageIndex - 1) % 2;
              });
            },
          ),
        ),
        Positioned(
          right: 2,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon: Icon(Icons.chevron_right, 
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _currentImageIndex = (_currentImageIndex + 1) % 2;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoDetectionPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          '臥床',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    switch (widget.item.status) {
      case IncidentStatus.unhandled:
        return _buildUnhandledButtons();
      case IncidentStatus.inProgress:
        return _buildInProgressButtons();
      case IncidentStatus.noDetection:
        return const SizedBox.shrink(); // ボタンなし
    }
  }

  Widget _buildUnhandledButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                '訪室不要',
                Colors.black87,
                () => widget.onActionButtonPressed?.call('no_visit_needed'),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildActionButton(
                '誤検知',
                Colors.red.shade700,
                () => widget.onActionButtonPressed?.call('false_detection'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _buildActionButton(
          '対応',
          Colors.blue.shade700,
          () => widget.onActionButtonPressed?.call('start_response'),
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildInProgressButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            '戻す',
            Colors.grey.shade700,
            () => widget.onActionButtonPressed?.call('revert'),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _buildActionButton(
            '完了',
            Colors.green.shade700,
            () => widget.onActionButtonPressed?.call('complete'),
          ),
        ),
      ],
    );
  }


  Widget _buildActionButton(
    String label,
    Color color,
    VoidCallback? onPressed, {
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
