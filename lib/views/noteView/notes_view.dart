import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:finance_manager_app/globalWidgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../providers/notesProvider/notes_provider.dart';
import 'pages/add_edit_note_view.dart';
import 'widgets/note_card.dart';
import 'package:finance_manager_app/utils/custom_loader.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  void initState() {
    super.initState();
    // Load notes when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notesProvider = context.watch<NotesProvider>();

    return Scaffold(
      appBar: customAppBar(
        title: 'note'.tr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: notesProvider.isLoading
          ? const Center(child: CustomLoader())
          : notesProvider.notes.isEmpty
          ? _buildEmptyState(theme)
          : _buildNotesGrid(notesProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddEditNoteView());
        },
        child: const Icon(Icons.add, color: AppColors.textPrimary),
      ),
    );
  }

  /// Build empty state when no notes are present
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'no_notes_yet'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'create_first_note'.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Build staggered grid of notes
  Widget _buildNotesGrid(NotesProvider notesProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 12.0,
      ),
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final note = notesProvider.notes[index];
              return NoteCard(
                note: note,
                onTap: () {
                  Get.to(AddEditNoteView(note: note));
                },
                onLongPress: () {
                  _showNoteOptions(context, note.id!);
                },
              );
            }, childCount: notesProvider.notes.length),
          ),
        ],
      ),
    );
  }

  /// Show options menu for a note (Edit/Delete)
  void _showNoteOptions(BuildContext context, int noteId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text('edit'.tr),
                onTap: () {
                  Navigator.pop(context);
                  final note = context.read<NotesProvider>().getNoteById(
                    noteId,
                  );
                  if (note != null) {
                    Get.to(AddEditNoteView(note: note));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text('delete'.tr, style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, noteId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Confirm delete dialog
  void _confirmDelete(BuildContext context, int noteId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('delete_note_title'.tr),
          content: Text('delete_note_message'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await context.read<NotesProvider>().deleteNote(noteId);
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('note_deleted'.tr)));
                }
              },
              child: Text('delete'.tr, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
