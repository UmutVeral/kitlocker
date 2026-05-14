import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(lockerEntriesProvider.notifier);
    if (widget.existing == null) {
      await notifier.add(
        teamName: _teamName.text.trim(),
        season: _season.text.trim(),
        condition: _condition,
        playerName: _playerName.text.trim().isEmpty
            ? null
            : _playerName.text.trim(),
        number:
            _number.text.trim().isEmpty ? null : _number.text.trim(),
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      );
    } else {
      await notifier.update(
        widget.existing!.copyWith(
          teamName: _teamName.text.trim(),
          season: _season.text.trim(),
          condition: _condition,
          playerName: _playerName.text.trim().isEmpty
              ? null
              : _playerName.text.trim(),
          number: _number.text.trim().isEmpty ? null : _number.text.trim(),
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        ),
      );
    }
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Kiti Düzenle' : 'Kit Ekle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
              onPressed: _submit,
              child: Text(isEdit ? 'Güncelle' : 'Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
