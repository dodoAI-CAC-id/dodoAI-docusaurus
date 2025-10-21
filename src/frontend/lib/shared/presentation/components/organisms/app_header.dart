import 'package:flutter/material.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text.dart';

/// アプリケーションヘッダー
class AppHeader extends StatelessWidget {
  final VoidCallback? onQrCodePressed;
  final VoidCallback? onViewPressed;
  final VoidCallback? onReloadPressed;
  final VoidCallback? onSettingsPressed;
  final String version;

  const AppHeader({
    Key? key,
    this.onQrCodePressed,
    this.onViewPressed,
    this.onReloadPressed,
    this.onSettingsPressed,
    this.version = 'v1.1.17',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // ロゴとバージョン
          Row(
            children: [
              // ロゴアイコン
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.visibility,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // サービス名
              AppText(
                text: 'mamoAI',
                type: TextStyleType.h2,
                color: Colors.blue[700],
              ),
              const SizedBox(width: 12),
              // バージョン
              AppText(
                text: version,
                type: TextStyleType.body2,
                color: Colors.grey[600],
              ),
            ],
          ),
          
          const Spacer(),
          
          // 右側のボタン群
          Row(
            children: [
              // QRコードボタン
              _HeaderButton(
                icon: Icons.qr_code_2,
                label: 'QRコード',
                onPressed: onQrCodePressed,
                showBadge: true,
              ),
              const SizedBox(width: 8),
              
              // ビューボタン
              _HeaderButton(
                icon: Icons.grid_view,
                label: 'ビュー',
                onPressed: onViewPressed,
              ),
              const SizedBox(width: 8),
              
              // 履歴リロードボタン
              _HeaderButton(
                icon: Icons.refresh,
                label: '履歴',
                onPressed: onReloadPressed,
              ),
              const SizedBox(width: 8),
              
              // 設定ボタン
              _HeaderButton(
                icon: Icons.settings,
                label: '設定',
                onPressed: onSettingsPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ヘッダーボタン
class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool showBadge;

  const _HeaderButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.showBadge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.blue[700],
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // バッジ（通知）
        if (showBadge)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
