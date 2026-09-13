// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? FluffyThemes.whatsappDarkSurface
              : Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            controller.isSearchMode ? '' : 'WaTalk',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Color(0xFF008069),
              letterSpacing: -0.5,
            ),
          ),
          actions: [
            if (!controller.isSearchMode) ...[
              IconButton(
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1F2C34),
                ),
                onPressed: () async {
                  try {
                    await ImagePicker().pickImage(source: ImageSource.camera);
                  } catch (_) {}
                },
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1F2C34),
                ),
                onSelected: (value) {
                  if (value == 'settings') {
                    context.go('/rooms/settings');
                  } else if (value == 'new_group') {
                    context.go('/rooms/newgroup');
                  } else if (value == 'spaces') {
                    context.go('/rooms/createspace');
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'new_group',
                    child: Text(L10n.of(context).createGroup),
                  ),
                  PopupMenuItem(
                    value: 'spaces',
                    child: Text(L10n.of(context).createNewSpace),
                  ),
                  PopupMenuItem(
                    value: 'devices',
                    child: Text(L10n.of(context).devices),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Text(L10n.of(context).settings),
                  ),
                ],
              ),
            ] else ...[
              IconButton(
                icon: const Icon(Icons.close),
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
                    L10n.of(context).status,
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
                  Text(
                    L10n.of(context).calls,
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
              label: L10n.of(context).status,
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
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(bottom: 12),
              child: FloatingActionButton(
                heroTag: 'ai_fab',
                elevation: 2,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF202C33)
                    : const Color(0xFFF0F2F5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () => context.go('/rooms/newprivatechat'),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF00A884), size: 22),
              ),
            ),
            FloatingActionButton(
              heroTag: 'chat_fab',
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onPressed: () => context.go('/rooms/newprivatechat'),
              child: const Icon(Icons.chat, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
