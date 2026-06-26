import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:girls_rise/widgets/dialogue_text_box.dart';
import '../models/game_stats.dart';
import '../services/game_state_manager.dart';
import 'typewriter_text.dart';

class ReflectionTextBox extends StatefulWidget {
  final double scale;
  final String headerTabAsset;
  final String quoteText;
  final String reflectionText;
  final List<StatDelta>? statChanges;

  const ReflectionTextBox({
    required this.scale,
    required this.headerTabAsset,
    required this.quoteText,
    required this.reflectionText,
    this.statChanges,
    super.key,
  });

  @override
  State<ReflectionTextBox> createState() => _ReflectionTextBoxState();
}

class _ReflectionTextBoxState extends State<ReflectionTextBox> {
  @override
  void initState() {
    super.initState();
    if (widget.statChanges != null && widget.statChanges!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          GameStateManager.instance.applyDeltas(widget.statChanges!);
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.statChanges != null && widget.statChanges!.isNotEmpty) {
      GameStateManager.instance.undo();
    }
    super.dispose();
  }

  String _formatDelta(StatDelta d) {
    final prefix = d.delta > 0 ? '+' : '';
    return '${d.type.title} ($prefix${d.delta})';
  }

  Color _getDeltaColor(int delta) {
    if (delta < 0) return const Color(0xFFDB2B2C); // Merah
    if (delta > 0) return const Color(0xFF43A047); // Hijau
    return const Color(0xFF765E54); // Coklat netral
  }

  @override
  Widget build(BuildContext context) {
    final double scale = widget.scale;

    return DialogueTextBox(
      autoAnimateStoryText: false,
      scale: scale,
      width: 303.5,
      height: 225.9,
      headerTabAsset: widget.headerTabAsset,
      headerTabWidth: 255.0,
      headerTabHeight: 52.0,
      headerTabLeft: 18.0,
      headerTabTop: -47.0,
      contentPadding: EdgeInsets.fromLTRB(
        12.0 * scale,
        18.0 * scale,
        12.0 * scale,
        16.0 * scale,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Small Dialogue Quote Box
              Container(
                width: 273.0 * scale,
                constraints: BoxConstraints(minHeight: 50.0 * scale),
                padding: EdgeInsets.symmetric(horizontal: 14.0 * scale, vertical: 8.0 * scale),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7F0).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12.0 * scale),
                  border: Border.all(
                    color: const Color(0xFF765E54).withValues(alpha: 0.3),
                    width: 1.5 * scale,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.quoteText,
                  style: GoogleFonts.lora(
                    fontSize: 12.0 * scale,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF765E54),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Parameter Impact Summary Badge
              if (widget.statChanges != null && widget.statChanges!.isNotEmpty) ...[
                SizedBox(height: 7.0 * scale),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0 * scale, vertical: 4.0 * scale),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF1E9),
                    borderRadius: BorderRadius.circular(8.0 * scale),
                    border: Border.all(
                      color: const Color(0xFF9C6C69).withValues(alpha: 0.4),
                      width: 1.0 * scale,
                    ),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0 * scale,
                    runSpacing: 2.0 * scale,
                    children: [
                      for (final d in widget.statChanges!)
                        Text(
                          _formatDelta(d),
                          style: GoogleFonts.lora(
                            fontSize: 10.5 * scale,
                            fontWeight: FontWeight.w700,
                            color: _getDeltaColor(d.delta),
                          ),
                        ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 7.0 * scale),

              // Reflection Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0 * scale),
                child: TypewriterText(
                  widget.reflectionText,
                  style: GoogleFonts.lora(
                    fontSize: 13.0 * scale,
                    height: 1.35,
                    color: const Color(0xFF765E54),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
