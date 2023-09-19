import 'package:flutter/material.dart';

// Sealed class to represent different states
abstract class ViewState {}

class LoadingState extends ViewState {}

class ErrorState extends ViewState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

class DataLoadedState extends ViewState {
  final List<HomeItem> data;

  DataLoadedState(this.data);
}

class HomeItem {
  final String todo;
  final bool isDone;

  HomeItem(this.todo, this.isDone);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sealed Class Example'),
        ),
        body: const MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  // Simulate a network call
  Future<ViewState> fetchData() async {
    final homeId = HomeItem('todo', false);
    List<HomeItem> home = [homeId];
    // Simulate loading
    await Future.delayed(const Duration(seconds: 2));

    // Simulate an error
    // Uncomment the line below to simulate an error
    // throw Exception('Failed to load data');

    // Simulate successful data loading
    return DataLoadedState(home);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<ViewState>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Handle the data loaded state
            final dataLoadedState = snapshot.data as DataLoadedState;
            return Text('Data: ${dataLoadedState.data.first.todo}');
          }
        },
      ),
    );
  }
}
