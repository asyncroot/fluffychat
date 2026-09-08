// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:go_router/go_router.dart';
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
          title: Text(
            controller.isSearchMode ? '' : 'WaTalk',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          actions: [
            if (!controller.isSearchMode) ...[
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: controller.startSearch,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'settings') {
                    context.go('/settings');
                  } else if (value == 'new_group') {
                    context.go('/newgroup');
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'new_group',
                    child: Text('New group'),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Text(L10n.of(context).settings),
                  ),
                ],
              ),
            ] else ...[
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: controller.cancelSearch,
              ),
            ],
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            ChatListViewBody(controller),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.update_outlined, size: 64, color: FluffyThemes.whatsappPrimaryGreen),
                  const SizedBox(height: 16),
                  Text(
                    L10n.of(context).edit,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.groups_outlined, size: 64, color: FluffyThemes.whatsappPrimaryGreen),
                  const SizedBox(height: 16),
                  Text(
                    L10n.of(context).space,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.call_outlined, size: 64, color: FluffyThemes.whatsappPrimaryGreen),
                  const SizedBox(height: 16),
                  const Text(
                    'Calls',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
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
          indicatorColor: FluffyThemes.whatsappSecondaryGreen.withAlpha(80),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.chat_outlined),
              selectedIcon: const Icon(Icons.chat, color: FluffyThemes.whatsappPrimaryGreen),
              label: L10n.of(context).chats,
            ),
            NavigationDestination(
              icon: const Icon(Icons.update_outlined),
              selectedIcon: const Icon(Icons.update, color: FluffyThemes.whatsappPrimaryGreen),
              label: L10n.of(context).edit,
            ),
            NavigationDestination(
              icon: const Icon(Icons.groups_outlined),
              selectedIcon: const Icon(Icons.groups, color: FluffyThemes.whatsappPrimaryGreen),
              label: L10n.of(context).space,
            ),
            const NavigationDestination(
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
