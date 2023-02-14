import 'package:flutter/material.dart';
import 'package:uniqe/tabs/input_tab.dart';
import 'package:uniqe/tabs/score_tab.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Interview Task"),
          centerTitle: true,
          bottom: const TabBar(tabs: [
            Tab(
              text: "Input",
            ),
            Tab(
              text: "Score",
            )
          ]),
        ),
        body: const TabBarView(children: [Inputwidget(), ScoreWidget()]),
      ),
    );
  }
}
