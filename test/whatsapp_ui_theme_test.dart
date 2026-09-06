import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluffychat/config/themes.dart';

void main() {
  testWidgets('Simulate user experiencing WhatsApp theme & color scheme', (WidgetTester tester) async {
    // 1. 构建亮色与暗色 WhatsApp 主题
    final lightTheme = FluffyThemes.buildTheme(ThemeMode.light, null);
    final darkTheme = FluffyThemes.buildTheme(ThemeMode.dark, null);

    // 2. 模拟渲染 WhatsApp 导航栏与主按钮
    await tester.pumpWidget(
      MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('WhatsApp'),
            actions: [
              IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          body: const Column(
            children: [
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Jim'),
                subtitle: Text('WhatsApp UI 重构测试中...'),
                trailing: Text('10:45 AM'),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.message),
          ),
        ),
      ),
    );

    // 3. 断言验证 UI 元素正常呈现
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.text('Jim'), findsOneWidget);
    expect(find.text('WhatsApp UI 重构测试中...'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // 4. 验证 WhatsApp 标志性配色方案（#008069 / #00A884）
    expect(lightTheme.colorScheme.primary, const Color(0xFF008069));
    expect(lightTheme.colorScheme.secondary, const Color(0xFF00A884));

    // 5. 模拟用户交互：点击 FAB 发起新聊天
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
  });
}
