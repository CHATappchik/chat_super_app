import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Text(
                'button to chat:',
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: () {
              //TODO Navigation on HomePAge
              //Navigator.of(context).push(route);
              print('OK');
            }, child: const Text('CHATS')),
          ],
        ),
      ),
    );
  }
}
