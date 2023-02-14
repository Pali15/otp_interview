part of 'uniqe_words_bloc.dart';

abstract class UniqeWordsState extends Equatable {
  final List<String> uniqeWords;
  const UniqeWordsState({this.uniqeWords = const []});

  @override
  List<Object> get props => [];
}

class UniqeWordsLoading extends UniqeWordsState {}

class UniqeWordsError extends UniqeWordsState {
  const UniqeWordsError({uniqeWords = const <String>[]})
      : super(uniqeWords: uniqeWords);
}

class UniqeWordsLoaded extends UniqeWordsState {
  final List<String> latest;

  const UniqeWordsLoaded(
      {uniqeWords = const <String>[], this.latest = const []})
      : super(uniqeWords: uniqeWords);

  @override
  List<Object> get props => [uniqeWords, latest];
}
