/// Tracks progress for a single mini-game.
class GameProgress {
  final String gameId;
  final int highScore;
  final int totalPlays;
  final DateTime lastPlayed;

  const GameProgress({
    required this.gameId,
    this.highScore = 0,
    this.totalPlays = 0,
    required this.lastPlayed,
  });

  GameProgress copyWith({
    int? highScore,
    int? totalPlays,
    DateTime? lastPlayed,
  }) {
    return GameProgress(
      gameId: gameId,
      highScore: highScore ?? this.highScore,
      totalPlays: totalPlays ?? this.totalPlays,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'highScore': highScore,
        'totalPlays': totalPlays,
        'lastPlayed': lastPlayed.toIso8601String(),
      };

  factory GameProgress.fromJson(Map<String, dynamic> json) => GameProgress(
        gameId: json['gameId'] as String,
        highScore: json['highScore'] as int? ?? 0,
        totalPlays: json['totalPlays'] as int? ?? 0,
        lastPlayed: DateTime.parse(json['lastPlayed'] as String),
      );
}
