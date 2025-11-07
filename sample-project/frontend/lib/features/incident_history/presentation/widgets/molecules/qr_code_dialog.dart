import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_text.dart';
import 'package:mamoai/shared/presentation/components/atoms/app_button.dart';

/// QRコード表示ダイアログ
class QrCodeDialog extends StatelessWidget {
  final String qrData;

  const QrCodeDialog({
    Key? key,
    required this.qrData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // タイトル
            AppText(
              text: 'QRコードでログイン',
              type: TextStyleType.h2,
            ),
            const SizedBox(height: 8),
            AppText(
              text: 'モバイル機器でこのQRコードをスキャンしてログインしてください',
              type: TextStyleType.body2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // QRコード
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.0,
                backgroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 閉じるボタン
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: '閉じる',
                onPressed: () => Navigator.of(context).pop(),
                type: ButtonType.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// QRコードダイアログを表示
  static void show(BuildContext context, {String? qrData}) {
    showDialog(
      context: context,
      builder: (context) => QrCodeDialog(
        qrData: qrData ?? 'https://mamoai.app/login?token=sample-token-12345',
      ),
    );
  }
}
