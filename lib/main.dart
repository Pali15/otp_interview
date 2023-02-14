import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniqe/bloc/score/score_bloc.dart';
import 'package:uniqe/bloc/uniqe_words/uniqe_words_bloc.dart';
import 'package:uniqe/home_screen.dart';
import 'package:uniqe/services/grammar_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                UniqeWordsBloc(grammarService: GrammarService())
                  ..add(const LoadUniqeWords())),
        BlocProvider(
            create: ((context) => ScoreBloc(
                uniqeWordsBloc: BlocProvider.of<UniqeWordsBloc>(context))
              ..add(const CalculateScore())))
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: Home(),
      ),
    );
  }
}
