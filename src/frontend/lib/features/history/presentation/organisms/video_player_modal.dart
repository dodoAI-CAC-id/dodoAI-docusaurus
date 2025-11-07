import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:frontend/shared/presentation/components/atoms/app_button.dart';
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/core/themes/app_typography.dart';

/// 動画再生モーダル Organism
/// 
/// 履歴動画を再生・ダウンロードするためのモーダルコンポーネント。
/// video_playerパッケージを使用して動画を再生する。
class VideoPlayerModal extends StatefulWidget {
  /// 動画ID
  final String videoId;

  /// 動画URL
  final String videoUrl;

  /// 閉じるボタン押下時のコールバック
  final VoidCallback onClose;

  /// ダウンロードボタン押下時のコールバック
  final VoidCallback onDownload;

  /// エラー発生時のコールバック
  final Function(String error)? onError;

  const VideoPlayerModal({
    super.key,
    required this.videoId,
    required this.videoUrl,
    required this.onClose,
    required this.onDownload,
    this.onError,
  });

  @override
  State<VideoPlayerModal> createState() => _VideoPlayerModalState();
}

class _VideoPlayerModalState extends State<VideoPlayerModal> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isPlaying = false;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 動画の初期化
  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _controller.initialize();

      setState(() {
        _isInitialized = true;
      });

      // 動画の再生状態を監視
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = '動画の読み込みに失敗しました: ${e.toString()}';
      });
      widget.onError?.call(_errorMessage!);
    }
  }

  /// 再生/一時停止の切り替え
  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  /// シーク処理
  void _onSeek(double value) {
    final duration = _controller.value.duration;
    final position = duration * value;
    _controller.seekTo(position);
  }

  /// 全画面表示の切り替え
  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    // 実際の全画面表示は実装が複雑なため、UIの切り替えのみ
  }

  /// 時間をフォーマット（MM:SS）
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ヘッダー
          _buildHeader(),

          // 動画プレーヤー部分
          Expanded(
            child: _buildVideoContent(),
          ),

          // コントロール部分
          if (_isInitialized && !_hasError) _buildControls(),

          // フッター（ダウンロードボタン）
          _buildFooter(),
        ],
      ),
    );
  }

  /// ヘッダー部分
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '動画再生',
            style: AppTypography.headlineMedium,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onClose,
            tooltip: '閉じる',
          ),
        ],
      ),
    );
  }

  /// 動画コンテンツ部分
  Widget _buildVideoContent() {
    if (_hasError) {
      return _buildErrorState();
    }

    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }

  /// エラー状態の表示
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? '動画の読み込みに失敗しました',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// コントロール部分
  Widget _buildControls() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          // プログレススライダー
          Row(
            children: [
              Text(
                _formatDuration(position),
                style: AppTypography.bodySmall,
              ),
              Expanded(
                child: Slider(
                  value: progress.clamp(0.0, 1.0),
                  onChanged: _onSeek,
                  activeColor: AppColors.primary,
                ),
              ),
              Text(
                _formatDuration(duration),
                style: AppTypography.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 再生コントロール
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 32,
                ),
                onPressed: _togglePlayPause,
                tooltip: _isPlaying ? '一時停止' : '再生',
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.fullscreen),
                onPressed: _toggleFullscreen,
                tooltip: '全画面表示',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// フッター部分
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton(
            label: 'ダウンロード',
            onPressed: widget.onDownload,
            variant: ButtonVariant.secondary,
          ),
        ],
      ),
    );
  }
}
