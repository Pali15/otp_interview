import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniqe/bloc/score/score_bloc.dart';

class ScoreWidget extends StatefulWidget {
  const ScoreWidget({Key? key}) : super(key: key);

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  bool sortAsc = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoreBloc, ScoreState>(
      builder: (context, state) {
        if (state is ScoreLoaded) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    _buildOverallScore(state),
                    const SizedBox(
                      height: 30,
                    ),
                    ..._buildWordScore(state)
                  ],
                ),
              ),
            ),
          );
        }
        return const Text("asd");
      },
    );
  }

  Widget _buildOverallScore(ScoreLoaded state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(5),
      child: Center(
        child: DefaultTextStyle(
          style: const TextStyle(
              fontSize: 30.0, fontFamily: 'Agne', color: Colors.black),
          child: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              TyperAnimatedText(
                  'Your overall score is: ${state.score.toString()}',
                  speed: const Duration(milliseconds: 50)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildWordScore(ScoreLoaded state) {
    return [
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Word",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(
                thickness: 1,
                color: Colors.black,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Point",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      if (state.score > 0)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    sortAsc = !sortAsc;
                  });
                },
                child: sortAsc
                    ? const Text("Descending")
                    : const Text("Ascending")),
          ],
        ),
      const SizedBox(
        height: 10,
      ),
      _buildWordScoreListView(state.wordScores.entries.toList())
    ];
  }

  Widget _buildWordScoreListView(List<MapEntry<String, int>> entries) {
    if (sortAsc) {
      entries.sort(((a, b) => a.key.length.compareTo(b.key.length)));
    } else {
      entries.sort(((a, b) => b.key.length.compareTo(a.key.length)));
    }

    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: entries.length,
          itemBuilder: ((context, index) {
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          entries[index].key,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          entries[index].value.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }
}
