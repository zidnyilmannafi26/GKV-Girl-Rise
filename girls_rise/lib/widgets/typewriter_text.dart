import 'dart:async';
import 'package:flutter/material.dart';
import '../services/story_controller.dart';
import 'screen_shake.dart';

class TypewriterText extends StatefulWidget {
  final String? text;
  final InlineSpan? span;
  final TextStyle? style;
  final TextAlign textAlign;
  final Duration speed;
  final VoidCallback? onFinished;

  const TypewriterText(
    this.text, {
    this.style,
    this.textAlign = TextAlign.justify,
    this.speed = const Duration(milliseconds: 18),
    this.onFinished,
    super.key,
  }) : span = null;

  const TypewriterText.span(
    this.span, {
    this.textAlign = TextAlign.justify,
    this.speed = const Duration(milliseconds: 18),
    this.onFinished,
    super.key,
  }) : text = null, style = null;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;
  bool _isFinished = false;

  int get _fullLength {
    if (widget.text != null) return widget.text!.length;
    if (widget.span != null) return widget.span!.toPlainText().length;
    return 0;
  }

  String get _rawString {
    if (widget.text != null) return widget.text!;
    if (widget.span != null) return widget.span!.toPlainText();
    return '';
  }

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.span != widget.span) {
      _timer?.cancel();
      _displayedText = '';
      _currentIndex = 0;
      _isFinished = false;
      _startTyping();
    }
  }

  void _startTyping() {
    final int totalLen = _fullLength;
    if (totalLen == 0) {
      _isFinished = true;
      StoryController.instance.finishTyping();
      widget.onFinished?.call();
      return;
    }

    StoryController.instance.startTyping(_skipToEnd);

    final raw = _rawString;
    if (raw.contains('!!') || raw.contains('!?') || raw.toLowerCase().contains('bentak') || raw.toLowerCase().contains('menampar') || raw.toLowerCase().contains('paksa')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScreenShake.of(context)?.shake();
      });
    }

    _timer = Timer.periodic(widget.speed, (timer) {
      if (_currentIndex < totalLen) {
        setState(() {
          _currentIndex++;
          if (widget.text != null) {
            _displayedText = widget.text!.substring(0, _currentIndex);
          }
        });
      } else {
        _timer?.cancel();
        if (!_isFinished) {
          _isFinished = true;
          StoryController.instance.finishTyping();
          widget.onFinished?.call();
        }
      }
    });
  }

  void _skipToEnd() {
    if (_isFinished) return;
    _timer?.cancel();
    StoryController.instance.finishTyping();
    setState(() {
      if (widget.text != null) {
        _displayedText = widget.text!;
      }
      _isFinished = true;
    });
    widget.onFinished?.call();
  }

  InlineSpan _sliceSpan(InlineSpan span, int count) {
    if (count <= 0) return const TextSpan(text: '');
    if (span is TextSpan) {
      if (span.text != null && span.text!.isNotEmpty) {
        if (span.text!.length <= count) {
          return span;
        } else {
          return TextSpan(text: span.text!.substring(0, count), style: span.style);
        }
      } else if (span.children != null) {
        int remaining = count;
        List<InlineSpan> newChildren = [];
        for (final child in span.children!) {
          final childLen = child.toPlainText().length;
          if (childLen <= remaining) {
            newChildren.add(child);
            remaining -= childLen;
          } else {
            newChildren.add(_sliceSpan(child, remaining));
            break;
          }
        }
        return TextSpan(style: span.style, children: newChildren);
      }
    }
    return span;
  }

  @override
  void dispose() {
    _timer?.cancel();
    StoryController.instance.finishTyping();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.span != null) {
      final sliced = _isFinished ? widget.span! : _sliceSpan(widget.span!, _currentIndex);
      content = RichText(
        text: sliced,
        textAlign: widget.textAlign,
      );
    } else {
      content = Text(
        _displayedText,
        style: widget.style,
        textAlign: widget.textAlign,
      );
    }

    return GestureDetector(
      onTap: _skipToEnd,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}
