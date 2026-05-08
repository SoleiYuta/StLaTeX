class Strategy {
  const Strategy({
    required this.mainGoal,
    required this.prioritySubjects,
    required this.priorityUnits,
    required this.discardUnits,
    required this.riskAlerts,
    required this.weeklyPlan,
    required this.aiReasoningSummary,
  });

  final String mainGoal;
  final List<String> prioritySubjects;
  final List<PriorityUnit> priorityUnits;
  final List<DiscardUnit> discardUnits;
  final List<RiskAlert> riskAlerts;
  final List<WeeklyPlanItem> weeklyPlan;
  final String aiReasoningSummary;

  factory Strategy.fromJson(Map<String, dynamic> json) {
    return Strategy(
      mainGoal: json['mainGoal'] as String,
      prioritySubjects: (json['prioritySubjects'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      priorityUnits: (json['priorityUnits'] as List<dynamic>)
          .map((item) => PriorityUnit.fromJson(item as Map<String, dynamic>))
          .toList(),
      discardUnits: (json['discardUnits'] as List<dynamic>)
          .map((item) => DiscardUnit.fromJson(item as Map<String, dynamic>))
          .toList(),
      riskAlerts: (json['riskAlerts'] as List<dynamic>)
          .map((item) => RiskAlert.fromJson(item as Map<String, dynamic>))
          .toList(),
      weeklyPlan: (json['weeklyPlan'] as List<dynamic>)
          .map((item) => WeeklyPlanItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      aiReasoningSummary: json['aiReasoningSummary'] as String,
    );
  }

  factory Strategy.fallback() {
    return Strategy.fromJson(const {
      'mainGoal': '数学III 微積分を重点強化する',
      'prioritySubjects': ['math', 'english'],
      'priorityUnits': [
        {
          'subject': 'math',
          'unit': '微積分',
          'reason': '志望校頻出かつ現在の正答率が低いため',
          'recommendedMinutes': 420,
        },
      ],
      'discardUnits': [
        {
          'subject': 'math',
          'unit': '整数',
          'reason': '頻度が低く、短期得点期待値が低いため',
          'risk': '出題された場合に失点リスクあり',
          'reviewTiming': '7月以降に再評価',
        },
      ],
      'riskAlerts': [
        {
          'type': 'pace_delay',
          'message': '化学の学習量が2週間連続で不足しています',
          'severity': 'medium',
        },
      ],
      'weeklyPlan': [
        {
          'day': 'Monday',
          'tasks': ['数学 微積分 90分', '英語 長文 60分'],
        },
      ],
      'aiReasoningSummary':
          'APIに接続できない場合でも、デモ用の固定戦略を表示します。数学IIIの微積分を今週の最優先に設定しています。',
    });
  }
}

class PriorityUnit {
  const PriorityUnit({
    required this.subject,
    required this.unit,
    required this.reason,
    required this.recommendedMinutes,
  });

  final String subject;
  final String unit;
  final String reason;
  final int recommendedMinutes;

  factory PriorityUnit.fromJson(Map<String, dynamic> json) {
    return PriorityUnit(
      subject: json['subject'] as String,
      unit: json['unit'] as String,
      reason: json['reason'] as String,
      recommendedMinutes: json['recommendedMinutes'] as int,
    );
  }
}

class DiscardUnit {
  const DiscardUnit({
    required this.subject,
    required this.unit,
    required this.reason,
    required this.risk,
    required this.reviewTiming,
  });

  final String subject;
  final String unit;
  final String reason;
  final String risk;
  final String reviewTiming;

  factory DiscardUnit.fromJson(Map<String, dynamic> json) {
    return DiscardUnit(
      subject: json['subject'] as String,
      unit: json['unit'] as String,
      reason: json['reason'] as String,
      risk: json['risk'] as String,
      reviewTiming: json['reviewTiming'] as String,
    );
  }
}

class RiskAlert {
  const RiskAlert({
    required this.type,
    required this.message,
    required this.severity,
  });

  final String type;
  final String message;
  final String severity;

  factory RiskAlert.fromJson(Map<String, dynamic> json) {
    return RiskAlert(
      type: json['type'] as String,
      message: json['message'] as String,
      severity: json['severity'] as String,
    );
  }
}

class WeeklyPlanItem {
  const WeeklyPlanItem({required this.day, required this.tasks});

  final String day;
  final List<String> tasks;

  factory WeeklyPlanItem.fromJson(Map<String, dynamic> json) {
    return WeeklyPlanItem(
      day: json['day'] as String,
      tasks: (json['tasks'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
    );
  }
}
