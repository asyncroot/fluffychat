// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:material_ui/material_ui.dart';

import 'chat_list_body.dart';

class ChatListView extends StatefulWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return PopScope(
      canPop: !controller.isSearchMode && controller.activeSpaceId == null,
      onPopInvokedWithResult: (pop, _) {
        if (pop) return;
        if (controller.activeSpaceId != null) {
          controller.clearActiveSpace();
          return;
        }
        if (controller.isSearchMode) {
          controller.cancelSearch();
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: FluffyThemes.whatsappPrimaryGreen,
          elevation: 0,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                if (!controller.isSearchMode) {
                  controller.startSearch();
                }
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {},
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'new_group', child: Text('New group')),
                const PopupMenuItem(value: 'community', child: Text('New community')),
                const PopupMenuItem(value: 'settings', child: Text('Settings')),
              ],
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            ChatListViewBody(controller),
            const Center(
              child: Text(
                'Updates / Status',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const Center(
              child: Text(
                'Communities',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const Center(
              child: Text(
                'Calls',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          indicatorColor: FluffyThemes.whatsappSecondaryGreen.withAlpha(50),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              selectedIcon: Icon(Icons.chat, color: FluffyThemes.whatsappPrimaryGreen),
              label: 'Chats',
            ),
            NavigationDestination(
              icon: Icon(Icons.update_outlined),
              selectedIcon: Icon(Icons.update, color: FluffyThemes.whatsappPrimaryGreen),
              label: 'Updates',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups, color: FluffyThemes.whatsappPrimaryGreen),
              label: 'Communities',
            ),
            NavigationDestination(
              icon: Icon(Icons.call_outlined),
              selectedIcon: Icon(Icons.call, color: FluffyThemes.whatsappPrimaryGreen),
              label: 'Calls',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: FluffyThemes.whatsappSecondaryGreen,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(Icons.message),
        ),
      ),
    );
  }
}
