import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uniqe/bloc/score/score_bloc.dart';
import 'package:uniqe/bloc/uniqe_words/uniqe_words_bloc.dart';
import 'package:uniqe/services/grammar_service.dart';
import 'uniqe_words_bloc_test.mocks.dart';

void main() {
  group('Uniqe words bloc tests', () {
    late UniqeWordsBloc uniqeWordsBloc;
    late ScoreBloc scoreBloc;
    late GrammarService grammarService;

    setUp(() {
      grammarService = MockGrammarService();
      uniqeWordsBloc = UniqeWordsBloc(grammarService: grammarService)
        ..add(const LoadUniqeWords());
      scoreBloc = ScoreBloc(uniqeWordsBloc: uniqeWordsBloc);
    });

    blocTest<ScoreBloc, ScoreState>("Load score",
        build: () => scoreBloc,
        act: ((bloc) => bloc.add(const LoadScore())),
        expect: () => const <ScoreState>[ScoreLoaded()]);

    blocTest<ScoreBloc, ScoreState>("Load score",
        build: () => scoreBloc,
        act: ((bloc) {
          when(grammarService.checkForGrammar("a")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(grammarService.checkForGrammar("bc")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          uniqeWordsBloc.add(const AddWord(words: ["a", "bc"]));
        }),
        expect: () => const <ScoreState>[
              ScoreLoaded(),
              ScoreLoaded(score: 3, wordScores: {"a": 1, "bc": 2})
            ]);
  });
}
