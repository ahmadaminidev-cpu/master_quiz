import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressData {
  final int currentCredits;
  final int maxCredits;
  final int currentLevel;
  final int maxLevel;
  final List<String> unlockedRewards;
  final Map<String, double> milestones; // key → progress 0.0–1.0
  final DateTime? lastDailyChallengeAt;
  final int totalQuizzes;
  final int currentStreak;
  final DateTime? lastActivityAt;

  const ProgressData({
    required this.currentCredits,
    required this.maxCredits,
    required this.currentLevel,
    required this.maxLevel,
    required this.unlockedRewards,
    required this.milestones,
    this.lastDailyChallengeAt,
    this.totalQuizzes = 0,
    this.currentStreak = 0,
    this.lastActivityAt,
  });

  /// Default starting state for a new user.
  factory ProgressData.initial() => const ProgressData(
        currentCredits: 0,
        maxCredits: 1200,
        currentLevel: 1,
        maxLevel: 6,
        unlockedRewards: [],
        milestones: {
          'credit_goal': 0.0,
          'quiz_master': 0.0,
          'streak_hunter': 0.0,
        },
        lastDailyChallengeAt: null,
        totalQuizzes: 0,
        currentStreak: 0,
        lastActivityAt: null,
      );

  factory ProgressData.fromMap(Map<String, dynamic> map) {
    return ProgressData(
      currentCredits: (map['currentCredits'] as num?)?.toInt() ?? 0,
      maxCredits: (map['maxCredits'] as num?)?.toInt() ?? 1200,
      currentLevel: (map['currentLevel'] as num?)?.toInt() ?? 1,
      maxLevel: (map['maxLevel'] as num?)?.toInt() ?? 6,
      unlockedRewards: List<String>.from(map['unlockedRewards'] ?? []),
      milestones: Map<String, double>.from(
        (map['milestones'] as Map<String, dynamic>? ?? {}).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
      lastDailyChallengeAt: map['lastDailyChallengeAt'] != null
          ? (map['lastDailyChallengeAt'] as Timestamp).toDate()
          : null,
      totalQuizzes: (map['totalQuizzes'] as num?)?.toInt() ?? 0,
      currentStreak: (map['currentStreak'] as num?)?.toInt() ?? 0,
      lastActivityAt: map['lastActivityAt'] != null
          ? (map['lastActivityAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'currentCredits': currentCredits,
        'maxCredits': maxCredits,
        'currentLevel': currentLevel,
        'maxLevel': maxLevel,
        'unlockedRewards': unlockedRewards,
        'milestones': milestones,
        'lastDailyChallengeAt': lastDailyChallengeAt != null
            ? Timestamp.fromDate(lastDailyChallengeAt!)
            : null,
        'totalQuizzes': totalQuizzes,
        'currentStreak': currentStreak,
        'lastActivityAt': lastActivityAt != null
            ? Timestamp.fromDate(lastActivityAt!)
            : null,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  /// Recalculates level from credits.
  ProgressData withCredits(int credits) {
    const creditsPerLevel = 200;
    final level = (credits ~/ creditsPerLevel) + 1;
    return ProgressData(
      currentCredits: credits,
      maxCredits: maxCredits,
      currentLevel: level.clamp(1, maxLevel),
      maxLevel: maxLevel,
      unlockedRewards: unlockedRewards,
      milestones: {
        ...milestones,
        'credit_goal': (credits / maxCredits).clamp(0.0, 1.0),
      },
      lastDailyChallengeAt: lastDailyChallengeAt,
      totalQuizzes: totalQuizzes,
      currentStreak: currentStreak,
      lastActivityAt: lastActivityAt,
    );
  }

  ProgressData withQuizCompletion() {
    final newTotal = totalQuizzes + 1;
    const goal = 100; // Quiz Master goal
    return ProgressData(
      currentCredits: currentCredits,
      maxCredits: maxCredits,
      currentLevel: currentLevel,
      maxLevel: maxLevel,
      unlockedRewards: unlockedRewards,
      milestones: {
        ...milestones,
        'quiz_master': (newTotal / goal).clamp(0.0, 1.0),
      },
      lastDailyChallengeAt: lastDailyChallengeAt,
      totalQuizzes: newTotal,
      currentStreak: currentStreak,
      lastActivityAt: DateTime.now(),
    );
  }

  ProgressData withStreakUpdate() {
    final now = DateTime.now();
    int newStreak = currentStreak;

    if (lastActivityAt != null) {
      final lastDate = DateTime(lastActivityAt!.year, lastActivityAt!.month, lastActivityAt!.day);
      final today = DateTime(now.year, now.month, now.day);
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        newStreak++;
      } else if (difference > 1) {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    const goal = 7; // Streak Hunter goal
    return ProgressData(
      currentCredits: currentCredits,
      maxCredits: maxCredits,
      currentLevel: currentLevel,
      maxLevel: maxLevel,
      unlockedRewards: unlockedRewards,
      milestones: {
        ...milestones,
        'streak_hunter': (newStreak / goal).clamp(0.0, 1.0),
      },
      lastDailyChallengeAt: lastDailyChallengeAt,
      totalQuizzes: totalQuizzes,
      currentStreak: newStreak,
      lastActivityAt: now,
    );
  }

  ProgressData withDailyChallenge(DateTime time) {
    return ProgressData(
      currentCredits: currentCredits,
      maxCredits: maxCredits,
      currentLevel: currentLevel,
      maxLevel: maxLevel,
      unlockedRewards: unlockedRewards,
      milestones: milestones,
      lastDailyChallengeAt: time,
      totalQuizzes: totalQuizzes,
      currentStreak: currentStreak,
      lastActivityAt: lastActivityAt,
    );
  }
}

class ProgressRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference _doc(String uid) =>
      _db.collection('users').doc(uid).collection('progress').doc('data');

  /// Loads progress for [uid]. Creates a default document if none exists.
  Future<ProgressData> load(String uid) async {
    final snap = await _doc(uid).get();
    if (!snap.exists) {
      final initial = ProgressData.initial();
      await _doc(uid).set(initial.toMap());
      return initial;
    }
    return ProgressData.fromMap(snap.data() as Map<String, dynamic>);
  }

  /// Saves progress for [uid].
  Future<void> save(String uid, ProgressData data) async {
    await _doc(uid).set(data.toMap(), SetOptions(merge: true));
  }
}
