import 'package:bisnisku/shared/constants/app_colors.dart';
import 'package:bisnisku/shared/constants/app_spacing.dart';
import 'package:flutter/material.dart';

Future<String?> showColorPickerDialog(
  BuildContext context, {
  String? initialColor,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _ColorPickerDialog(initialColor: initialColor),
  );
}

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({this.initialColor});

  final String? initialColor;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late TextEditingController _hexController;
  late Color _previewColor;

  static const _presetColors = <String>[
    'EF4444',
    'F97316',
    'F59E0B',
    '10B981',
    '22D3EE',
    '3B82F6',
    '6366F1',
    '8B5CF6',
    'EC4899',
    '14B8A6',
    '0EA5E9',
    '84CC16',
    'F472B6',
    'A855F7',
    'FB7185',
    'D946EF',
    'A3E635',
    'FDE047',
    'F97316',
    '94A3B8',
  ];

  @override
  void initState() {
    super.initState();
    _hexController = TextEditingController(
      text: widget.initialColor ?? '3B82F6',
    );
    _previewColor = _parseColor(_hexController.text);
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Warna',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: _previewColor,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.border),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _hexController,
                      maxLength: 6,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        counterText: '',
                        labelText: 'Hex code',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        prefixText: '#',
                        prefixStyle: TextStyle(color: AppColors.textSecondary),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _previewColor = _parseColor(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Preset',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _presetColors.map((hex) {
                final color = _parseColor(hex);
                final isSelected = _hexController.text.toUpperCase() == hex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _hexController.text = hex;
                      _previewColor = color;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.border,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(_hexController.text.toUpperCase());
                },
                child: const Text(
                  'Pilih',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final sanitized = hex.replaceAll('#', '').padRight(6, '0').substring(0, 6);
    return Color(int.parse('0xFF$sanitized'));
  }
}
