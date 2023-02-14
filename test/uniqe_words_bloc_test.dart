import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uniqe/bloc/uniqe_words/uniqe_words_bloc.dart';
import 'package:uniqe/services/grammar_service.dart';

import 'uniqe_words_bloc_test.mocks.dart';

@GenerateMocks([GrammarService])
void main() {
  group('Uniqe words bloc tests', () {
    late UniqeWordsBloc uniqeWordsBloc;
    late GrammarService grammarService;

    setUp(() {
      grammarService = MockGrammarService();
      uniqeWordsBloc = UniqeWordsBloc(grammarService: grammarService)
        ..add(const LoadUniqeWords());
    });

    blocTest<UniqeWordsBloc, UniqeWordsState>("Add words without duplicate",
        build: () => uniqeWordsBloc,
        act: ((bloc) {
          when(grammarService.checkForGrammar("a")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(grammarService.checkForGrammar("b")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          bloc.add(const AddWord(words: ["a", "b"]));
        }),
        expect: () => <UniqeWordsState>[
              UniqeWordsLoading(),
              const UniqeWordsLoaded(uniqeWords: ["a", "b"], latest: ["a", "b"])
            ]);

    blocTest<UniqeWordsBloc, UniqeWordsState>("Add words with duplicate",
        build: () => uniqeWordsBloc,
        act: ((bloc) {
          when(grammarService.checkForGrammar("a")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(grammarService.checkForGrammar("b")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          bloc.add(const AddWord(words: [
            "a",
            "b",
            "b",
            "b",
          ]));
        }),
        expect: () => <UniqeWordsState>[
              UniqeWordsLoading(),
              const UniqeWordsLoaded(uniqeWords: ["a", "b"], latest: ["a", "b"])
            ]);

    blocTest<UniqeWordsBloc, UniqeWordsState>("Add word which is too long",
        build: () => uniqeWordsBloc,
        act: ((bloc) {
          when(grammarService.checkForGrammar("a")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(grammarService.checkForGrammar(
                  "pneumonoultramicroscopicsilicovolcanoconiosisa"))
              .thenAnswer(
            (realInvocation) => Future.value(true),
          );
          bloc.add(const AddWord(
              words: ["a", "pneumonoultramicroscopicsilicovolcanoconiosisa"]));
        }),
        expect: () => <UniqeWordsState>[
              UniqeWordsLoading(),
              const UniqeWordsLoaded(uniqeWords: ["a"], latest: ["a"])
            ]);

    blocTest<UniqeWordsBloc, UniqeWordsState>("Add word which is incorrect",
        build: () => uniqeWordsBloc,
        act: ((bloc) {
          when(grammarService.checkForGrammar("a")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(grammarService.checkForGrammar("b")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(grammarService.checkForGrammar("asd")).thenAnswer(
            (realInvocation) => Future.value(false),
          );
          bloc.add(const AddWord(words: ["a", "b", "asd"]));
        }),
        expect: () => <UniqeWordsState>[
              UniqeWordsLoading(),
              const UniqeWordsLoaded(uniqeWords: ["a", "b"], latest: ["a", "b"])
            ]);

    blocTest<UniqeWordsBloc, UniqeWordsState>("Check for exception",
        build: () => uniqeWordsBloc,
        act: ((bloc) {
          when(grammarService.checkForGrammar("asd"))
              .thenThrow(Exception("Failed to fetch"));
          bloc.add(const AddWord(words: ["a", "b"]));
        }),
        expect: () =>
            <UniqeWordsState>[UniqeWordsLoading(), const UniqeWordsError()]);

    blocTest<UniqeWordsBloc, UniqeWordsState>("Add words multiple times",
        build: () => uniqeWordsBloc,
        act: ((bloc) {
          when(grammarService.checkForGrammar("d")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(grammarService.checkForGrammar("e")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(grammarService.checkForGrammar("a")).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          bloc.add(const LoadUniqeWords(
              uniqeWords: ["a", "b", "c"], latest: ["a", "b", "c"]));
          bloc.add(const AddWord(words: ["d", "e", "a"]));
        }),
        expect: () => <UniqeWordsState>[
              const UniqeWordsLoaded(
                  uniqeWords: ["a", "b", "c"], latest: ["a", "b", "c"]),
              UniqeWordsLoading(),
              const UniqeWordsLoaded(
                  uniqeWords: ["a", "b", "c", "d", "e"], latest: ["d", "e"])
            ]);

    blocTest<UniqeWordsBloc, UniqeWordsState>("Clear words",
        build: () => uniqeWordsBloc,
        act: ((bloc) {
          bloc
            ..add(const LoadUniqeWords(
                uniqeWords: ["a", "b", "c"], latest: ["a", "b", "c"]))
            ..add(ClearWords());
        }),
        expect: () => const <UniqeWordsState>[
              UniqeWordsLoaded(
                  uniqeWords: ["a", "b", "c"], latest: ["a", "b", "c"]),
              UniqeWordsLoaded()
            ]);

    blocTest<UniqeWordsBloc, UniqeWordsState>("Load words",
        build: () => uniqeWordsBloc,
        act: ((bloc) {
          bloc.add(const LoadUniqeWords(
              uniqeWords: ["a", "b", "c"], latest: ["a", "b", "c"]));
        }),
        expect: () => const <UniqeWordsState>[
              UniqeWordsLoaded(
                  uniqeWords: ["a", "b", "c"], latest: ["a", "b", "c"])
            ]);
  });
}
