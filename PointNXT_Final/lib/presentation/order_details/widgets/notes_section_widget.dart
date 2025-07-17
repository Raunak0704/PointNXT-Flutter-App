import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotesSectionWidget extends StatefulWidget {
  final String notes;
  final Function(String) onNotesChanged;

  const NotesSectionWidget({
    super.key,
    required this.notes,
    required this.onNotesChanged,
  });

  @override
  State<NotesSectionWidget> createState() => _NotesSectionWidgetState();
}

class _NotesSectionWidgetState extends State<NotesSectionWidget> {
  late TextEditingController _notesController;
  bool _isEditing = false;
  bool _hasChanges = false;
  String _originalNotes = '';

  @override
  void initState() {
    super.initState();
    _originalNotes = widget.notes;
    _notesController = TextEditingController(text: widget.notes);
    _notesController.addListener(_onNotesChanged);
  }

  @override
  void dispose() {
    _notesController.removeListener(_onNotesChanged);
    _notesController.dispose();
    super.dispose();
  }

  void _onNotesChanged() {
    final String currentText = _notesController.text;
    final bool hasChanges = currentText != _originalNotes;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });

    // Focus the text field after a short delay to ensure it's built
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  void _saveNotes() {
    HapticFeedback.lightImpact();

    setState(() {
      _isEditing = false;
      _originalNotes = _notesController.text;
      _hasChanges = false;
    });

    widget.onNotesChanged(_notesController.text);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notes saved successfully'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2)));
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _notesController.text = _originalNotes;
      _hasChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Order Notes',
                    style: AppTheme.lightTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                if (!_isEditing)
                  IconButton(
                      onPressed: _startEditing,
                      icon: CustomIconWidget(
                          iconName: 'edit',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20),
                      padding: EdgeInsets.all(2.w),
                      constraints: const BoxConstraints()),
              ]),
              SizedBox(height: 3.w),
              if (_isEditing) ...[
                // Editing Mode
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 2),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                        controller: _notesController,
                        maxLines: 5,
                        minLines: 3,
                        autofocus: true,
                        decoration: InputDecoration(
                            hintText: 'Add notes about this order...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(3.w),
                            hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.7))),
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                        textCapitalization: TextCapitalization.sentences)),
                SizedBox(height: 3.w),

                // Action Buttons
                Row(children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: _cancelEditing,
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 3.w)),
                          child: Text('Cancel'))),
                  SizedBox(width: 3.w),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: _hasChanges ? _saveNotes : null,
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 3.w)),
                          child: Text('Save'))),
                ]),
              ] else ...[
                // Display Mode
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3))),
                    child: widget.notes.isEmpty
                        ? Column(children: [
                            CustomIconWidget(
                                iconName: 'note_add',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 32),
                            SizedBox(height: 2.w),
                            Text('No notes added yet',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant)),
                            SizedBox(height: 1.w),
                            Text('Tap the edit button to add notes',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: 0.7))),
                          ])
                        : Text(widget.notes,
                            style: AppTheme.lightTheme.textTheme.bodyMedium)),

                if (widget.notes.isNotEmpty) ...[
                  SizedBox(height: 3.w),
                  Row(children: [
                    CustomIconWidget(
                        iconName: 'info_outline',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16),
                    SizedBox(width: 2.w),
                    Expanded(
                        child: Text('Tap edit to modify notes',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant))),
                  ]),
                ],
              ],
            ])));
  }
}
