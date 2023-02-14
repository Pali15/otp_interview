import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:uniqe/bloc/uniqe_words/uniqe_words_bloc.dart';

class Inputwidget extends StatefulWidget {
  const Inputwidget({Key? key}) : super(key: key);

  @override
  State<Inputwidget> createState() => _InputwidgetState();
}

class _InputwidgetState extends State<Inputwidget> {
  late FormGroup form;
  FormControl<String> input = FormControl(
    value: "",
  );

  @override
  void initState() {
    form = FormGroup({"input": input});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UniqeWordsBloc, UniqeWordsState>(
      builder: (context, state) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _inputField(),
                  const SizedBox(
                    height: 10,
                  ),
                  _filterBtn(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildResult(state)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _inputField() {
    return Row(
      children: [
        Expanded(
          child: ReactiveTextField(
            formControl: input,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z\b ]")),
            ],
            decoration: const InputDecoration(
                labelText: "Type your text here!",
                border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
            onPressed: () {
              context.read<UniqeWordsBloc>().add(ClearWords());
              input.value = "";
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), fixedSize: const Size(65, 65)),
            child: const Text("Clear"))
      ],
    );
  }

  Widget _filterBtn() {
    return ElevatedButton(
      onPressed: () {
        context
            .read<UniqeWordsBloc>()
            .add(AddWord(words: input.value!.split(" ")));
        input.value = "";
      },
      style: ElevatedButton.styleFrom(
          elevation: 5, minimumSize: const Size(150, 50)),
      child: const Text("Filter uniqe words!"),
    );
  }

  Widget _buildResult(UniqeWordsState state) {
    if (state is UniqeWordsLoading) {
      return const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (state is UniqeWordsLoaded) {
      return Expanded(
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: buildWords(state.uniqeWords
                        .where((element) => !state.latest.contains(element))
                        .toList()),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  text: buildWords(state.latest),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Expanded(
        child: Text(
          "Something went wrong",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 40),
        ),
      );
    }
  }

  String buildWords(List<String> words) {
    String res = "";
    for (final word in words) {
      res = "$res\n$word";
    }

    return res;
  }
}
