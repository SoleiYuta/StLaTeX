import 'package:flutter/material.dart';

import '../../models/strategy.dart';
import '../../services/strategy_api.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final Future<Strategy> _strategyFuture;

  @override
  void initState() {
    super.initState();
    _strategyFuture = StrategyApi().fetchLatestStrategy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StLaTeX'),
        centerTitle: false,
      ),
      body: FutureBuilder<Strategy>(
        future: _strategyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final strategy = snapshot.data ?? Strategy.fallback();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeroStrategyCard(strategy: strategy),
              const SizedBox(height: 16),
              _SectionCard(
                title: '優先単元',
                children: strategy.priorityUnits
                    .map(
                      (unit) => _UnitTile(
                        title: '${unit.subject} / ${unit.unit}',
                        subtitle:
                            '${unit.recommendedMinutes}分 - ${unit.reason}',
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: '今週は優先度を下げる単元',
                children: strategy.discardUnits
                    .map(
                      (unit) => _UnitTile(
                        title: '${unit.subject} / ${unit.unit}',
                        subtitle:
                            '${unit.reason}\nリスク: ${unit.risk}\n再評価: ${unit.reviewTiming}',
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'リスク',
                children: strategy.riskAlerts
                    .map(
                      (alert) => _UnitTile(
                        title: alert.severity.toUpperCase(),
                        subtitle: alert.message,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: '週間プラン',
                children: strategy.weeklyPlan
                    .map(
                      (plan) => _UnitTile(
                        title: plan.day,
                        subtitle: plan.tasks.join(' / '),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroStrategyCard extends StatelessWidget {
  const _HeroStrategyCard({required this.strategy});

  final Strategy strategy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今週の戦略', style: textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(strategy.mainGoal, style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: strategy.prioritySubjects
                  .map((subject) => Chip(label: Text(subject)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(strategy.aiReasoningSummary),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  const _UnitTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(subtitle),
        ],
      ),
    );
  }
}
