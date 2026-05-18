import 'package:flutter/material.dart';

import '../models/kit_catalog_entry.dart';
import '../models/kit_type.dart';
import '../providers/catalog_provider.dart';

class CatalogSearchSheet extends StatefulWidget {
  const CatalogSearchSheet({
    super.key,
    required this.catalog,
    required this.onSelected,
  });

  final List<KitCatalogEntry> catalog;
  final ValueChanged<KitCatalogEntry> onSelected;

  @override
  State<CatalogSearchSheet> createState() => _CatalogSearchSheetState();
}

class _CatalogSearchSheetState extends State<CatalogSearchSheet> {
  final _teamController = TextEditingController();
  final _seasonController = TextEditingController();
  KitType? _kitType;

  @override
  void dispose() {
    _teamController.dispose();
    _seasonController.dispose();
    super.dispose();
  }

  List<KitCatalogEntry> get _results {
    final season = _seasonController.text.trim();
    return searchKitCatalog(
      widget.catalog,
      teamQuery: _teamController.text,
      season: season.isEmpty ? null : season,
      kitType: _kitType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Catalog\'dan ara',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('catalog_search_team'),
            controller: _teamController,
            decoration: const InputDecoration(
              labelText: 'Takım',
              hintText: 'örn. Gala, Manchester',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('catalog_search_season'),
            controller: _seasonController,
            decoration: const InputDecoration(
              labelText: 'Sezon (isteğe bağlı)',
              hintText: '2024-25',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<KitType?>(
            key: const Key('catalog_search_type'),
            initialValue: _kitType,
            decoration: const InputDecoration(labelText: 'Tip (isteğe bağlı)'),
            items: [
              const DropdownMenuItem(value: null, child: Text('Tümü')),
              ...KitType.values.map(
                (t) => DropdownMenuItem(value: t, child: Text(t.label)),
              ),
            ],
            onChanged: (v) => setState(() => _kitType = v),
          ),
          const SizedBox(height: 12),
          if (_teamController.text.trim().isEmpty)
            const Text('Aramak için takım adı girin.')
          else if (results.isEmpty)
            const Text('Sonuç bulunamadı.')
          else
            SizedBox(
              height: 240,
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (_, i) {
                  final entry = results[i];
                  return ListTile(
                    key: Key('catalog_result_${entry.id}'),
                    title: Text(entry.teamName),
                    subtitle: Text(
                      '${entry.season} · ${entry.kitType.label}',
                    ),
                    onTap: () => widget.onSelected(entry),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

Future<KitCatalogEntry?> showCatalogSearchSheet({
  required BuildContext context,
  required List<KitCatalogEntry> catalog,
}) {
  return showModalBottomSheet<KitCatalogEntry>(
    context: context,
    isScrollControlled: true,
    builder: (_) => CatalogSearchSheet(
      catalog: catalog,
      onSelected: (entry) => Navigator.pop(context, entry),
    ),
  );
}
