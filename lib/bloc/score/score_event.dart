part of 'score_bloc.dart';

abstract class ScoreEvent extends Equatable {
  const ScoreEvent();

  @override
  List<Object> get props => [];
}

class LoadScore extends ScoreEvent {
  final List<String> words;
  final int score;
  final Map<String, int> wordScores;

  const LoadScore(
      {this.words = const [], this.score = 0, this.wordScores = const {}});

  @override
  List<Object> get props => [words, score, wordScores];
}

class CalculateScore extends ScoreEvent {
  const CalculateScore();

  @override
  List<Object> get props => [];
}
