import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Golden snapshot test for WhatsApp Theme UI', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF008069),
            primary: const Color(0xFF008069),
            secondary: const Color(0xFF00A884),
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF008069),
            title: const Text('WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(icon: const Icon(Icons.camera_alt_outlined, color: Colors.white), onPressed: () {}),
              IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('CHATS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('UPDATES', style: TextStyle(color: Colors.white70)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('CALLS', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF008069),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: const Text('Jim (Test Matrix User)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Hello! WhatsApp UI refactor completed successfully.'),
                trailing: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('10:45 AM', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(height: 4),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Color(0xFF00A884),
                      child: Text('2', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF00A884),
            onPressed: () {},
            child: const Icon(Icons.message, color: Colors.white),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/whatsapp_main_screen.png'),
    );
  });
}
