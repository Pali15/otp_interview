part of 'score_bloc.dart';

abstract class ScoreState extends Equatable {
  const ScoreState();

  @override
  List<Object> get props => [];
}

class ScoreLoading extends ScoreState {}

class ScoreLoaded extends ScoreState {
  final int score;
  final Map<String, int> wordScores;

  const ScoreLoaded({this.score = 0, this.wordScores = const {}});

  @override
  List<Object> get props => [score, wordScores];
}
