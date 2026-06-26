import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../scenario_1/part_1_screen.dart';
import '../scenario_2/intro/scenario_2_intro_screen.dart';
import '../services/game_state_manager.dart';
import '../utils/fade_page_route.dart';
import 'history_match_screen.dart';

class ScenarioSelectionScreen extends StatefulWidget {
  const ScenarioSelectionScreen({super.key});

  @override
  State<ScenarioSelectionScreen> createState() => _ScenarioSelectionScreenState();
}

class _ScenarioSelectionScreenState extends State<ScenarioSelectionScreen>
    with TickerProviderStateMixin {
  AnimationController? _transitionController;
  Animation<double>? _selectedCardScaleAnim;
  Animation<double>? _unselectedCardFadeAnim;
  Animation<double>? _bgZoomAnim;

  AnimationController? _historyBtnController;
  Animation<double>? _historyScaleAnim;
  Animation<double>? _historyRotateAnim;
  Animation<double>? _historyRippleScaleAnim;
  Animation<double>? _historyRippleAlphaAnim;

  int? _selectedScenario; // 1 or 2

  void _ensureController() {
    if (_transitionController != null && _historyBtnController != null) return;

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _selectedCardScaleAnim = Tween<double>(begin: 1.0, end: 1.55).animate(
      CurvedAnimation(parent: _transitionController!, curve: Curves.easeInOutCubic),
    );

    _unselectedCardFadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _transitionController!,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _bgZoomAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _transitionController!, curve: Curves.easeInOutCubic),
    );

    _historyBtnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _historyScaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.05).chain(CurveTween(curve: Curves.easeOutBack)), weight: 60),
    ]).animate(_historyBtnController!);

    _historyRotateAnim = Tween<double>(begin: 0.0, end: pi).animate(
      CurvedAnimation(parent: _historyBtnController!, curve: Curves.easeInOutBack),
    );

    _historyRippleScaleAnim = Tween<double>(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(parent: _historyBtnController!, curve: Curves.easeOutQuad),
    );
    _historyRippleAlphaAnim = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _historyBtnController!, curve: Curves.easeOutQuad),
    );
  }

  @override
  void initState() {
    super.initState();
    _ensureController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GameStateManager.instance.endScenario();
    });
  }

  @override
  void dispose() {
    _transitionController?.dispose();
    _historyBtnController?.dispose();
    super.dispose();
  }

  void _onHistoryTapped() async {
    _ensureController();
    await _historyBtnController?.forward();
    if (!mounted) return;
    await Navigator.of(context).push(
      FadePageRoute(page: const HistoryMatchScreen()),
    );
    if (mounted) {
      _historyBtnController?.reset();
    }
  }

  void _onSelectScenario(int scenarioId, Widget targetScreen) {
    _ensureController();
    if (_selectedScenario != null) return;

    setState(() {
      _selectedScenario = scenarioId;
    });

    _transitionController!.forward();

    Navigator.of(context)
        .push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnim = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curvedAnim,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.12, end: 1.0).animate(curvedAnim),
              child: child,
            ),
          );
        },
      ),
    )
        .then((_) {
      if (mounted) {
        setState(() {
          _selectedScenario = null;
        });
        _transitionController?.reset();
        GameStateManager.instance.endScenario();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _ensureController();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: AnimatedBuilder(
        animation: _transitionController!,
        builder: (context, _) {
          final bool isTransitioning = _selectedScenario != null;
          final double bgScale = isTransitioning ? _bgZoomAnim!.value : 1.0;
          final double uiOpacity = isTransitioning ? _unselectedCardFadeAnim!.value : 1.0;

          return Stack(
            children: [
              // Background Image (overflowed by 30px, zooms smoothly during transition)
              Positioned(
                top: -30,
                bottom: -30,
                left: -30,
                right: -30,
                child: Transform.scale(
                  scale: bgScale,
                  child: Image.asset(
                    'assets/images/bg.home.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),

              // Pill-shaped Back Button (top left)
              Positioned(
                top: 25,
                left: 25,
                child: Opacity(
                  opacity: uiOpacity,
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedScenario == null) Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF1E9), // Girl Rise Cream
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF9C6C69), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '← BACK',
                        style: GoogleFonts.lora(
                          color: const Color(0xFF5A3831), // Deep brown
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // History Medal Button & Label (top right)
              Positioned(
                top: 25,
                right: 25,
                child: Opacity(
                  opacity: uiOpacity,
                  child: AnimatedBuilder(
                    animation: _historyBtnController!,
                    builder: (context, child) {
                      final double btnScale = _historyScaleAnim?.value ?? 1.0;
                      final double btnRotate = _historyRotateAnim?.value ?? 0.0;
                      final double rippleScale = _historyRippleScaleAnim?.value ?? 1.0;
                      final double rippleAlpha = _historyRippleAlphaAnim?.value ?? 0.0;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Expanding Ripple Ring
                              if (_historyBtnController!.isAnimating)
                                Transform.scale(
                                  scale: rippleScale,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF9C6C69).withValues(alpha: rippleAlpha),
                                        width: 2.5,
                                      ),
                                    ),
                                  ),
                                ),

                              // Glass Medal Button
                              GestureDetector(
                                onTap: _onHistoryTapped,
                                child: Transform.scale(
                                  scale: btnScale,
                                  child: Transform.rotate(
                                    angle: btnRotate,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFAF1E9).withValues(alpha: 0.82),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF9C6C69),
                                              width: 2.0,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.2),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.history_rounded,
                                            color: Color(0xFF5A3831),
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Small Label Text [Riwayat]
                          Text(
                            'Riwayat',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFFAF1E9),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Center Cards
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Scenario 1 Card
                    _buildAnimatedCard(
                      scenarioId: 1,
                      imagePath: 'assets/images/Scenario_1.png',
                      targetScreen: const Part1Screen(),
                    ),
                    const SizedBox(width: 30),
                    // Scenario 2 Card
                    _buildAnimatedCard(
                      scenarioId: 2,
                      imagePath: 'assets/images/Scenario_2.png',
                      targetScreen: const Scenario2IntroScreen(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedCard({
    required int scenarioId,
    required String imagePath,
    required Widget targetScreen,
  }) {
    final bool isSelected = _selectedScenario == scenarioId;
    final bool isOtherSelected = _selectedScenario != null && !isSelected;

    double cardScale = 1.0;
    double cardOpacity = 1.0;

    if (isSelected) {
      cardScale = _selectedCardScaleAnim!.value;
    } else if (isOtherSelected) {
      cardScale = 0.85;
      cardOpacity = _unselectedCardFadeAnim!.value;
    }

    return IgnorePointer(
      ignoring: _selectedScenario != null,
      child: Opacity(
        opacity: cardOpacity,
        child: Transform.scale(
          scale: cardScale,
          child: InteractiveScenarioCard(
            imagePath: imagePath,
            onTap: () => _onSelectScenario(scenarioId, targetScreen),
          ),
        ),
      ),
    );
  }
}

class InteractiveScenarioCard extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const InteractiveScenarioCard({
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  @override
  State<InteractiveScenarioCard> createState() => _InteractiveScenarioCardState();
}

class _InteractiveScenarioCardState extends State<InteractiveScenarioCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;
    if (_isPressed) {
      scale = 0.95;
    } else if (_isHovered) {
      scale = 1.05;
    }

    final isSvg = widget.imagePath.toLowerCase().endsWith('.svg');

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            child: isSvg
                ? SvgPicture.asset(
                    widget.imagePath,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    widget.imagePath,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}
