import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../globalWidgets/custom_appbar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../models/noteModel/note_model.dart';
import '../../../providers/notesProvider/notes_provider.dart';

class AddEditNoteView extends StatefulWidget {
  final NoteModel? note;

  const AddEditNoteView({super.key, this.note});

  @override
  State<AddEditNoteView> createState() => _AddEditNoteViewState();
}

class _AddEditNoteViewState extends State<AddEditNoteView> {
  final _contentController = TextEditingController();
  final _focusNode = FocusNode();
  final _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isEdit = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _isEdit = true;
      _contentController.text = widget.note!.content;
      _selectedImagePath = widget.note!.imagePath;
    }

    // Auto-focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Track changes
    _contentController.addListener(() {
      if (!_hasChanges && _contentController.text.isNotEmpty) {
        setState(() => _hasChanges = true);
      }
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: customAppBar(
          title: _isEdit ? 'edit_note'.tr : 'add_note'.tr,
          leading: IconButton(
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              tooltip: 'Add Image',
            ),
            IconButton(
              onPressed: _saveNote,
              icon: const Icon(Icons.check),
              tooltip: 'save'.tr,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_selectedImagePath != null) ...[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_selectedImagePath!),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImagePath = null;
                            _hasChanges = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: TextField(
                  controller: _contentController,
                  focusNode: _focusNode,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'write_your_note_here'.tr,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle back button press
  Future<bool> _onWillPop() async {
    final content = _contentController.text.trim();

    // If no changes or content is empty, allow pop
    if (!_hasChanges || content.isEmpty) {
      return true;
    }

    // If editing and content hasn't changed, allow pop
    if (_isEdit &&
        content == widget.note!.content &&
        _selectedImagePath == widget.note!.imagePath) {
      return true;
    }

    // Show confirmation dialog
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('discard_changes'.tr),
          content: Text('discard_note_message'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'discard'.tr,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    return shouldDiscard ?? false;
  }

  /// Save the note
  void _saveNote() async {
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'note_content_empty'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final provider = context.read<NotesProvider>();
    final now = DateTime.now().toIso8601String();

    try {
      if (_isEdit) {
        // Update existing note
        final updatedNote = widget.note!.copyWith(
          content: content,
          imagePath: _selectedImagePath,
          updatedAt: now,
        );
        await provider.updateNote(widget.note!.id!, updatedNote);
        Get.back();
        Get.snackbar(
          'success'.tr,
          'note_updated'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Create new note
        final newNote = NoteModel(
          content: content,
          imagePath: _selectedImagePath,
          createdAt: now,
          updatedAt: now,
        );
        await provider.addNote(newNote);
        Get.back();
        Get.snackbar(
          'success'.tr,
          'note_added'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'failed_to_save_note'.tr}: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
          _hasChanges = true;
        });
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
