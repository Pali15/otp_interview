import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniqe/bloc/uniqe_words/uniqe_words_bloc.dart';

part 'score_event.dart';
part 'score_state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  late UniqeWordsBloc _uniqeWordsBloc;
  late StreamSubscription _uniqeWordsSub;
  ScoreBloc({required UniqeWordsBloc uniqeWordsBloc}) : super(ScoreLoading()) {
    _uniqeWordsBloc = uniqeWordsBloc;
    on<LoadScore>(_load);
    on<CalculateScore>(_calculateScore);

    _uniqeWordsSub = _uniqeWordsBloc.stream.listen((event) {
      add(const CalculateScore());
    });
  }

  void _load(LoadScore event, Emitter<ScoreState> emit) {
    emit(ScoreLoaded(score: event.score, wordScores: event.wordScores));
  }

  void _calculateScore(CalculateScore event, Emitter<ScoreState> emit) {
    final state = _uniqeWordsBloc.state;

    if (state is UniqeWordsLoaded) {
      final words = state.uniqeWords;
      final score = _calulcateFinalScore(words);
      final wordScores = _calculateWordScores(words);

      emit(ScoreLoaded(score: score, wordScores: wordScores));
    }
  }

  int _calulcateFinalScore(List<String> words) {
    int score = 0;
    for (final w in words) {
      score += w.length;
    }
    return score;
  }

  Map<String, int> _calculateWordScores(List<String> words) {
    Map<String, int> wordScores = {};
    for (final w in words) {
      wordScores[w] = w.length;
    }
    return wordScores;
  }

  @override
  Future<void> close() {
    _uniqeWordsSub.cancel();
    return super.close();
  }
}
