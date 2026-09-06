// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/mxc_image_viewer.dart';
import 'settings.dart';

class SettingsView extends StatelessWidget {
  final SettingsController controller;

  const SettingsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeRoute = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.path;

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).settings),
        elevation: 0,
        leading: Center(
          child: BackButton(onPressed: () => context.go('/rooms')),
        ),
      ),
      body: ListTileTheme(
        iconColor: theme.colorScheme.onSurfaceVariant,
        child: ListView(
          key: const Key('SettingsListViewContent'),
          children: <Widget>[
            // WhatsApp style Profile Header Tile
            FutureBuilder<Profile>(
              future: controller.profileFuture,
              builder: (context, snapshot) {
                final profile = snapshot.data;
                final avatar = profile?.avatarUrl;
                final mxid =
                    Matrix.of(context).client.userID ?? L10n.of(context).user;
                final displayname =
                    profile?.displayName ?? mxid.localpart ?? mxid;
                return InkWell(
                  onTap: controller.setDisplaynameAction,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Avatar(
                              mxContent: avatar,
                              name: displayname,
                              size: 64,
                              onTap: avatar != null
                                  ? () => showDialog(
                                      context: context,
                                      builder: (_) => MxcImageViewer(avatar),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: const Color(0xFF00A884),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 14,
                                  color: Colors.white,
                                  icon: const Icon(Icons.camera_alt),
                                  onPressed: controller.setAvatarAction,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayname,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mxid,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.qr_code_2_outlined, color: Color(0xFF00A884)),
                          onPressed: () => FluffyShare.share(mxid, context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            // WhatsApp Category List Items
            ListTile(
              leading: const Icon(Icons.key_outlined),
              title: const Text('Account'),
              subtitle: const Text('Security notifications, account management'),
              onTap: () => context.go('/rooms/settings/security'),
            ),
            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: Text(L10n.of(context).chat),
              subtitle: const Text('Theme, wallpapers, chat history'),
              tileColor: activeRoute.startsWith('/rooms/settings/chat')
                  ? theme.colorScheme.surfaceContainerHigh
                  : null,
              onTap: () => context.go('/rooms/settings/chat'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(L10n.of(context).notifications),
              subtitle: const Text('Message, group & call tones'),
              tileColor: activeRoute.startsWith('/rooms/settings/notifications')
                  ? theme.colorScheme.surfaceContainerHigh
                  : null,
              onTap: () => context.go('/rooms/settings/notifications'),
            ),
            ListTile(
              leading: const Icon(Icons.devices_outlined),
              title: Text(L10n.of(context).devices),
              subtitle: const Text('Linked devices, active sessions'),
              onTap: () => context.go('/rooms/settings/devices'),
              tileColor: activeRoute.startsWith('/rooms/settings/devices')
                  ? theme.colorScheme.surfaceContainerHigh
                  : null,
            ),
            SwitchListTile.adaptive(
              controlAffinity: ListTileControlAffinity.trailing,
              value: controller.cryptoIdentityConnected == true,
              secondary: const Icon(Icons.backup_outlined),
              title: Text(L10n.of(context).chatBackup),
              subtitle: const Text('Encrypted key backup'),
              onChanged: controller.firstRunBootstrapAction,
              contentPadding: const EdgeInsets.only(left: 16, right: 8),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Privacy'),
              subtitle: Text(L10n.of(context).privacy),
              onTap: () => launchUrlString(AppSettings.privacyPolicy.value),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(L10n.of(context).about),
              subtitle: Text(
                Matrix.of(context).client.userID?.domain ?? 'App info',
              ),
              onTap: () => PlatformInfos.showDialog(context),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout_outlined, color: Colors.redAccent),
              title: Text(
                L10n.of(context).logout,
                style: const TextStyle(color: Colors.redAccent),
              ),
              onTap: controller.logoutAction,
            ),
          ],
        ),
      ),
    );
  }
}
