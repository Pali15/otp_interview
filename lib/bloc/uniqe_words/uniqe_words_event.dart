part of 'uniqe_words_bloc.dart';

abstract class UniqeWordsEvent extends Equatable {
  const UniqeWordsEvent();

  @override
  List<Object> get props => [];
}

class LoadUniqeWords extends UniqeWordsEvent {
  final List<String> uniqeWords;
  final List<String> latest;
  const LoadUniqeWords({this.uniqeWords = const [], this.latest = const []});

  @override
  List<Object> get props => [uniqeWords, latest];
}

class AddWord extends UniqeWordsEvent {
  final List<String> words;

  const AddWord({required this.words});

  @override
  List<Object> get props => [words];
}

class ClearWords extends UniqeWordsEvent {}
