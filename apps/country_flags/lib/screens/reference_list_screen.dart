import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_app_core/shared_app_core.dart';

import '../data/countries.dart';
import '../models/country.dart';
import '../widgets/flag_widget.dart';

class ReferenceListScreen extends StatefulWidget {
  const ReferenceListScreen({super.key});

  @override
  State<ReferenceListScreen> createState() => _ReferenceListScreenState();
}

class _ReferenceListScreenState extends State<ReferenceListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Country> get _filtered {
    final q = _query.toLowerCase().trim();
    final list = q.isEmpty
        ? CountriesData.all
        : CountriesData.all
            .where((c) => c.name.toLowerCase().contains(q))
            .toList();
    return [...list]..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Flags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outlined),
            tooltip: 'About',
            onPressed: () => context.push('/about'),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search countries…',
              leading: Icon(
                Icons.search,
                color: AppColors.onBackgroundSecondary,
              ),
              trailing: _query.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                    ]
                  : null,
              onChanged: (value) => setState(() => _query = value),
              backgroundColor: WidgetStatePropertyAll(
                isDark ? AppColors.surfaceDark : AppColors.surface,
              ),
              elevation: const WidgetStatePropertyAll(1),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // ── Country count ───────────────────────────────────────────────
          if (_query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filtered.length} result${filtered.length == 1 ? '' : 's'}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),

          // ── Flag list ───────────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: AppColors.onBackgroundSecondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No countries match "$_query"',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.onBackgroundSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final country = filtered[index];
                      return _FlagListTile(country: country);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FlagListTile extends StatelessWidget {
  final Country country;
  const _FlagListTile({required this.country});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          FlagWidget(
            isoCode: country.isoCode,
            height: 40,
            width: 60,
            borderRadius: 4,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country.name,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  country.region,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
