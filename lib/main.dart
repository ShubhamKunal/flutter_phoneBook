import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        "/add": (context) => const NewContactView(),
      },
      initialRoute: "/",
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: (context, index) {
          final contact = contactBook.itemAtIndex(index: index)!;
          return ListTile(
            title: Text(contact.name),
            tileColor: Color(Colors.white60.value),
            contentPadding: const EdgeInsets.all(8),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed("/add");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Contact {
  final String name;

  Contact({required this.name});
}

class ContactBook {
  //Singleton class
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  //THIS IS THE ESTABLISHED PATTERN TO CREATE SINGLETONS IN FLUTTER
  factory ContactBook() => _shared;
  final List<Contact> _contacts = [
    Contact(name: "Shubham"),
    Contact(name: "Simran"),
  ];

  int get length => _contacts.length;
  void add({required Contact contact}) {
    _contacts.add(contact);
  }

  void remove({required Contact contact}) {
    _contacts.remove(contact);
  }

  Contact? itemAtIndex({required int index}) =>
      (index < length) ? _contacts.elementAt(index) : null;
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new contact"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "Enter a new contact"),
          ),
          ElevatedButton(
              onPressed: () {
                final contact = Contact(name: _controller.text);
                ContactBook().add(contact: contact);
                Navigator.of(context).pop();
              },
              child: const Text("Add Contact"))
        ],
      ),
    );
  }
}
