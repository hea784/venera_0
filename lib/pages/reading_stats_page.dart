import 'package:flutter/material.dart';
import 'package:venera/components/components.dart';
import 'package:venera/foundation/app.dart';
import 'package:venera/foundation/history.dart';
import 'package:venera/utils/translations.dart';

/// Reading statistics derived from the history database.
///
/// ponytail: history only stores the last-read state per comic, so the daily
/// chart counts comics whose last read happened that day, not pages per day.
/// A real event log (pages read per day) needs a new table; add one if users
/// ask for accurate daily page counts.
class ReadingStatsPage extends StatelessWidget {
  const ReadingStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final comics = HistoryManager().getAll();
    int chaptersRead = 0;
    final activeDays = <String>{};
    final dailyCounts = List.filled(30, 0);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final c in comics) {
      chaptersRead += c.readEpisode.length;
      final day = DateTime(c.time.year, c.time.month, c.time.day);
      activeDays.add(
        '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}',
      );
      final diff = today.difference(day).inDays;
      if (diff >= 0 && diff < 30) {
        dailyCounts[29 - diff]++;
      }
    }
    final maxCount = dailyCounts.fold<int>(0, (a, b) => a > b ? a : b);

    return Scaffold(
      body: SmoothCustomScrollView(
        slivers: [
          SliverAppbar(title: Text('Reading Stats'.tl)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  _StatCard(
                    value: comics.length,
                    label: 'Comics read'.tl,
                  ),
                  _StatCard(
                    value: chaptersRead,
                    label: 'Chapters read'.tl,
                  ),
                  _StatCard(value: activeDays.length, label: 'Active days'.tl),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily reading'.tl,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Last 30 days'.tl,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var i = 0; i < 30; i++)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1,
                              ),
                              child: SizedBox(
                                height:
                                    dailyCounts[i] == 0
                                        ? 2
                                        : 4 + 140 * dailyCounts[i] / maxCount,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color:
                                        dailyCounts[i] == 0
                                            ? context
                                                .colorScheme
                                                .surfaceContainerHighest
                                            : context.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
