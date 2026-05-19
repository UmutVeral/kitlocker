import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../catalog/models/kit_catalog_entry.dart';
import '../../catalog/providers/catalog_provider.dart';
import '../../catalog/widgets/catalog_search_sheet.dart';
import '../../photos/photo_providers.dart';
import '../../photos/providers/image_picker_provider.dart';
import '../../recognition/locker_entry_recognition_applier.dart';
import '../../recognition/providers/recognition_provider.dart';
import '../models/locker_condition.dart';
import '../models/locker_entry.dart';
import '../providers/locker_entries_notifier.dart';

class LockerEntryFormScreen extends ConsumerStatefulWidget {
  const LockerEntryFormScreen({super.key, this.existing});

  final LockerEntry? existing;

  @override
  ConsumerState<LockerEntryFormScreen> createState() =>
      _LockerEntryFormScreenState();
}

class _LockerEntryFormScreenState
    extends ConsumerState<LockerEntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _teamName;
  late final TextEditingController _season;
  late final TextEditingController _playerName;
  late final TextEditingController _number;
  late final TextEditingController _notes;
  late LockerCondition _condition;
  late List<String> _existingPhotoUrls;
  final List<XFile> _newPhotos = [];
  bool _isUploading = false;
  bool _isRecognizing = false;
  KitCatalogEntry? _selectedCatalog;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _teamName = TextEditingController(text: e?.teamName ?? '');
    _season = TextEditingController(text: e?.season ?? '');
    _playerName = TextEditingController(text: e?.playerName ?? '');
    _number = TextEditingController(text: e?.number ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _condition = e?.condition ?? LockerCondition.mint;
    _existingPhotoUrls = List.of(e?.photos ?? []);
  }

  @override
  void dispose() {
    _teamName.dispose();
    _season.dispose();
    _playerName.dispose();
    _number.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _openCatalogSearch() async {
    final catalog = await ref.read(kitCatalogProvider.future);
    if (!mounted) return;
    final selected = await showCatalogSearchSheet(
      context: context,
      catalog: catalog,
    );
    if (selected == null || !mounted) return;
    setState(() {
      _selectedCatalog = selected;
      _teamName.text = selected.teamName;
      _season.text = selected.season;
    });
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ref.read(imagePickerServiceProvider);
    final file = await picker.pickImage(source);
    if (file == null || !mounted) return;

    setState(() => _newPhotos.add(file));
    await _runRecognition(file);
  }

  Future<void> _runRecognition(XFile file) async {
    if (widget.existing != null) return;

    setState(() => _isRecognizing = true);
    try {
      final catalog = await ref.read(kitCatalogProvider.future);
      final rawBytes = await file.readAsBytes();
      final compressor = ref.read(photoCompressorProvider);
      final bytes = await compressor.compress(rawBytes);
      final coordinator = ref.read(recognitionCoordinatorProvider);
      final outcome = await coordinator.recognize(
        imageBytes: bytes,
        catalog: catalog,
      );

      if (!mounted) return;

      final applyResult = LockerEntryRecognitionApplier.apply(
        outcome: outcome,
        currentTeamName: _teamName.text,
        currentSeason: _season.text,
      );

      switch (applyResult.kind) {
        case RecognitionApplyKind.prefill:
          _applyPrefill(applyResult);
        case RecognitionApplyKind.manual:
          if (applyResult.hadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Kit tanınamadı. Bilgileri manuel girebilir veya '
                  'Catalog\'dan arayabilirsiniz.',
                ),
              ),
            );
          }
        case RecognitionApplyKind.skipped:
          break;
      }
    } finally {
      if (mounted) setState(() => _isRecognizing = false);
    }
  }

  void _applyPrefill(RecognitionApplyResult result) {
    final values = result.formValues!;
    setState(() {
      _teamName.text = values.teamName;
      _season.text = values.season;
      if (values.playerName != null) {
        _playerName.text = values.playerName!;
      }
      if (values.number != null) {
        _number.text = values.number!;
      }
      if (result.catalogEntry != null) {
        _selectedCatalog = result.catalogEntry;
      }
    });
  }

  void _showPhotoPicker() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isUploading = true);

    try {
      final notifier = ref.read(lockerEntriesProvider.notifier);
      final teamName = _teamName.text.trim();
      final season = _season.text.trim();
      final playerName =
          _playerName.text.trim().isEmpty ? null : _playerName.text.trim();
      final number =
          _number.text.trim().isEmpty ? null : _number.text.trim();
      final notes =
          _notes.text.trim().isEmpty ? null : _notes.text.trim();

      if (widget.existing == null) {
        await notifier.addWithPhotos(
          newPhotos: _newPhotos,
          existingUrls: _existingPhotoUrls,
          teamName: teamName,
          season: season,
          condition: _condition,
          kitCatalogId: _selectedCatalog?.id,
          leagueId: _selectedCatalog?.leagueId,
          playerName: playerName,
          number: number,
          notes: notes,
        );
      } else {
        await notifier.updateEntryWithPhotos(
          existing: widget.existing!,
          newPhotos: _newPhotos,
          existingUrls: _existingPhotoUrls,
          teamName: teamName,
          season: season,
          condition: _condition,
          playerName: playerName,
          number: number,
          notes: notes,
        );
      }

      if (mounted) Navigator.of(context).maybePop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fotoğraf yüklenemedi. Lütfen tekrar deneyin.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final hasPhotos = _existingPhotoUrls.isNotEmpty || _newPhotos.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Kiti Düzenle' : 'Kit Ekle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // — Fotoğraf bölümü —
            if (hasPhotos)
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._existingPhotoUrls.map(
                      (url) => _PhotoThumbnail.network(
                        url,
                        onRemove: () =>
                            setState(() => _existingPhotoUrls.remove(url)),
                      ),
                    ),
                    ..._newPhotos.map(
                      (f) => _PhotoThumbnail.file(
                        f,
                        onRemove: () => setState(() => _newPhotos.remove(f)),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: const Key('form_add_photo_button'),
              onPressed: _isRecognizing ? null : _showPhotoPicker,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Fotoğraf Ekle'),
            ),
            if (_isRecognizing) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(
                key: Key('form_recognition_loading'),
              ),
              const SizedBox(height: 4),
              Text(
                'Kit tanınıyor…',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              key: const Key('form_catalog_search_button'),
              onPressed: _openCatalogSearch,
              icon: const Icon(Icons.search),
              label: const Text('Catalog\'dan ara'),
            ),
            if (_selectedCatalog != null) ...[
              const SizedBox(height: 8),
              Text(
                'Catalog: ${_selectedCatalog!.teamName} · '
                '${_selectedCatalog!.season} · '
                '${_selectedCatalog!.kitType.label}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            // — Form alanları —
            TextFormField(
              key: const Key('form_team_name'),
              controller: _teamName,
              decoration: const InputDecoration(labelText: 'Takım *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Takım adı zorunlu' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('form_season'),
              controller: _season,
              decoration: const InputDecoration(labelText: 'Sezon *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Sezon zorunlu' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<LockerCondition>(
              key: const Key('form_condition'),
              initialValue: _condition,
              decoration: const InputDecoration(labelText: 'Durum *'),
              items: LockerCondition.values
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.name),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) _condition = v;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('form_player_name'),
              controller: _playerName,
              decoration:
                  const InputDecoration(labelText: 'Oyuncu adı (isteğe bağlı)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('form_number'),
              controller: _number,
              decoration:
                  const InputDecoration(labelText: 'Numara (isteğe bağlı)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('form_notes'),
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notlar'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('form_submit_button'),
              onPressed: _isUploading ? null : _submit,
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEdit ? 'Güncelle' : 'Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  const _PhotoThumbnail._({required this.child, required this.onRemove});

  factory _PhotoThumbnail.network(String url, {required VoidCallback onRemove}) =>
      _PhotoThumbnail._(
        onRemove: onRemove,
        child: Image.network(url, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 40)),
      );

  factory _PhotoThumbnail.file(XFile file, {required VoidCallback onRemove}) =>
      _PhotoThumbnail._(
        onRemove: onRemove,
        child: _isFlutterTest
            ? const ColoredBox(color: Color(0xFFE0E0E0))
            : Image.file(File(file.path), fit: BoxFit.cover),
      );

  static bool get _isFlutterTest =>
      !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(width: 90, height: 110, child: child),
            ),
            Positioned(
              top: 2,
              right: 10,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      );
}
