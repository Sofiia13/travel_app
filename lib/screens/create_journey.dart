import 'package:flutter/material.dart';

class CreateJourneyScreen extends StatefulWidget {
  const CreateJourneyScreen({super.key});

  @override
  State<CreateJourneyScreen> createState() => _CreateJourneyState();
}

class _CreateJourneyState extends State<CreateJourneyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your journey'),
      ),
      body: Container(
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.all(20),
        // decoration: BoxDecoration(
        //     border: Border.all(width: 4),
        //   ),
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
