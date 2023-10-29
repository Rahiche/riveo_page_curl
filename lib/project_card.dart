import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'dart:ui' as ui;

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    Key? key,
    required this.child,
    required this.onDelete,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onDelete;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with TickerProviderStateMixin {
  final double cornerRadius = 16.0;

  late final AnimationController _animationController;
  late final AudioPlayer _audioPlayer;
  late double _width;

  bool _isPlaying = false;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController.unbounded(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.value = 0.0;
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      // Handle pause logic if necessary
    } else {
      await _audioPlayer.seek(const Duration(milliseconds: 350));
      await _audioPlayer.play(AssetSource('peel.mp3'));
      setState(() {
        _isPlaying = true;
      });
    }
  }

  Future<void> _showCupertinoDialog() async {
    setState(() {
      _isDialogShown = true;
    });
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildCupertinoAlertDialog();
      },
    );
    setState(() {
      _isDialogShown = false;
    });
  }

  CupertinoAlertDialog _buildCupertinoAlertDialog() {
    return CupertinoAlertDialog(
      title: const Text('Delete Project'),
      content: const Text('Are you sure you want to delete this project?'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: _handleCancel,
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: _handleDelete,
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Future<void> _handleCancel() async {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop();
    await _animationController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
    );
  }

  Future<void> _handleDelete() async {
    HapticFeedback.heavyImpact();
    Navigator.of(context).pop();
    await _animationController.animateTo(-_width * 1.5);
    widget.onDelete();
    _animationController.value = 0;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _width = context.size!.width;
    final double newPointer =
        _animationController.value + details.primaryDelta! * _width / 200;
    _animationController.value = newPointer;
    final double value = _animationController.value + _width;

    if (value < -30 && !_isDialogShown) {
      _showCupertinoDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (_) => _playPauseAudio(),
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: (_) => _stopAudioAndReset(),
      onHorizontalDragCancel: _resetAnimation,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: _buildAnimatedCard,
      ),
    );
  }

  Widget _buildAnimatedCard(BuildContext context, Widget? child) {
    return ShaderBuilder(
      (context, shader, _) {
        return AnimatedSampler(
          (image, size, canvas) {
            _configureShader(shader, size, image);
            _drawShaderRect(shader, size, canvas);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: cornerRadius),
            child: widget.child,
          ),
        );
      },
      assetKey: 'shaders/page_curl.frag',
    );
  }

  void _configureShader(FragmentShader shader, Size size, ui.Image image) {
    shader
      ..setFloat(0, size.width) // resolution
      ..setFloat(1, size.height) // resolution
      ..setFloat(2, _animationController.value) // pointer
      ..setFloat(3, 0) // origin
      ..setFloat(4, 0) // inner container
      ..setFloat(5, 0) // inner container
      ..setFloat(6, size.width) // inner container
      ..setFloat(7, size.height) // inner container
      ..setFloat(8, cornerRadius) // cornerRadius
      ..setImageSampler(0, image); // image
  }

  void _drawShaderRect(FragmentShader shader, Size size, Canvas canvas) {
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      Paint()..shader = shader,
    );
  }

  Future<void> _stopAudioAndReset() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
    if (!_isDialogShown) {
      _resetAnimation();
    }
  }

  void _resetAnimation() {
    HapticFeedback.selectionClick();
    if (!_isDialogShown) {
      _animationController.animateTo(0);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
