import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';

void main() {
  testWidgets('Simulate user interacting with WhatsApp redesigned ChatListItem', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: FluffyThemes.buildTheme(Brightness.light),
        home: Scaffold(
          body: ChatListItem(
            title: 'Jim (Test User)',
            body: 'Hello, this is a test message',
            time: '10:45 AM',
            unreadCount: 3,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // 1. 验证用户在聊天列表中看到名称、消息内容和未读消息数
    expect(find.text('Jim (Test User)'), findsOneWidget);
    expect(find.text('Hello, this is a test message'), findsOneWidget);
    expect(find.text('10:45 AM'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    // 2. 模拟用户点击该聊天项
    await tester.tap(find.byType(ChatListItem));
    await tester.pump();

    // 3. 验证触发了 onTap 回调进入聊天
    expect(tapped, isTrue);
  });
}
