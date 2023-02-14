import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniqe/services/grammar_service.dart';

part 'uniqe_words_event.dart';
part 'uniqe_words_state.dart';

class UniqeWordsBloc extends Bloc<UniqeWordsEvent, UniqeWordsState> {
  late GrammarService grammarService;
  final _maxLength = "pneumonoultramicroscopicsilicovolcanoconiosis".length;
  UniqeWordsBloc({required this.grammarService}) : super(UniqeWordsLoading()) {
    on<LoadUniqeWords>(_load);
    on<AddWord>(_add);
    on<ClearWords>(_clear);
  }

  void _load(LoadUniqeWords event, Emitter<UniqeWordsState> emit) {
    emit(UniqeWordsLoaded(uniqeWords: event.uniqeWords, latest: event.latest));
  }

  Future<void> _add(AddWord event, Emitter<UniqeWordsState> emit) async {
    final state = this.state;
    emit(UniqeWordsLoading());
    try {
      final newWords = await filterWords(event.words, state.uniqeWords);
      emit(UniqeWordsLoaded(
          uniqeWords: [...state.uniqeWords, ...newWords], latest: newWords));
    } catch (e) {
      emit(UniqeWordsError(uniqeWords: state.uniqeWords));
    }
  }

  void _clear(ClearWords event, Emitter<UniqeWordsState> emit) {
    if (state is UniqeWordsLoaded) {
      emit(const UniqeWordsLoaded());
    }
  }

  Future<List<String>> filterWords(
      List<String> words, List<String> uniqeWords) async {
    final newWords = <String>[];

    for (final w in words) {
      if (!newWords.contains(w) &&
          w.length <= _maxLength &&
          w.isNotEmpty &&
          !uniqeWords.contains(w)) {
        final wordIsCorrect = await grammarService.checkForGrammar(w);
        if (wordIsCorrect) {
          newWords.add(w);
        }
      }
    }

    return newWords;
  }
}
