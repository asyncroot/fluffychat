// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:emoji_picker_flutter/locales/default_emoji_set_locale.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/recording_input_row.dart';
import 'package:fluffychat/pages/chat/recording_view_model.dart';
import 'package:fluffychat/utils/other_party_can_receive.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

import '../../config/themes.dart';
import 'chat.dart';
import 'input_bar.dart';

class ChatInputRow extends StatelessWidget {
  final ChatController controller;

  static const double height = 56.0;

  const ChatInputRow(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textMessageOnly =
        controller.sendController.text.isNotEmpty ||
        controller.replyEvent != null ||
        controller.editEvent != null;

    if (!controller.room.otherPartyCanReceiveMessages) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            L10n.of(context).otherPartyNotLoggedIn,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final selectedTextButtonStyle = TextButton.styleFrom(
      foregroundColor: theme.colorScheme.onTertiaryContainer,
    );

    return RecordingViewModel(
      builder: (context, recordingViewModel) {
        if (recordingViewModel.isRecording) {
          return RecordingInputRow(
            state: recordingViewModel,
            onSend: controller.onVoiceMessageSend,
          );
        }
        if (controller.selectMode) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (controller.selectedEvents.every(
                (event) => event.status == EventStatus.error,
              ))
                SizedBox(
                  height: height,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    onPressed: controller.deleteErrorEventsAction,
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.delete_forever_outlined),
                        Text(L10n.of(context).delete),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  height: height,
                  child: TextButton(
                    style: selectedTextButtonStyle,
                    onPressed: controller.forwardEventsAction,
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.keyboard_arrow_left_outlined),
                        Text(L10n.of(context).forward),
                      ],
                    ),
                  ),
                ),
              controller.selectedEvents.length == 1
                  ? controller.selectedEvents.first
                            .getDisplayEvent(controller.timeline!)
                            .status
                            .isSent
                        ? SizedBox(
                            height: height,
                            child: TextButton(
                              style: selectedTextButtonStyle,
                              onPressed: controller.replyAction,
                              child: Row(
                                children: <Widget>[
                                  Text(L10n.of(context).reply),
                                  const Icon(Icons.keyboard_arrow_right),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: height,
                            child: TextButton(
                              style: selectedTextButtonStyle,
                              onPressed: controller.sendAgainAction,
                              child: Row(
                                children: <Widget>[
                                  Text(L10n.of(context).tryToSendAgain),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.send_outlined, size: 16),
                                ],
                              ),
                            ),
                          )
                  : const SizedBox.shrink(),
            ],
          );
        }

        final isDark = theme.brightness == Brightness.dark;
        final inputBgColor = isDark ? FluffyThemes.whatsappDarkSurface : Colors.white;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: inputBgColor,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: L10n.of(context).emojis,
                        color: Colors.grey[600],
                        icon: Icon(
                          controller.showEmojiPicker
                              ? Icons.keyboard
                              : Icons.sentiment_satisfied_alt_outlined,
                        ),
                        onPressed: controller.emojiPickerAction,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InputBar(
                            room: controller.room,
                            minLines: 1,
                            maxLines: 6,
                            autofocus: !PlatformInfos.isMobile,
                            keyboardType: TextInputType.multiline,
                            textInputAction:
                                AppSettings.sendOnEnter.value == true &&
                                    PlatformInfos.isMobile
                                ? TextInputAction.send
                                : null,
                            onSubmitted: controller.onInputBarSubmitted,
                            onSubmitImage: controller.sendImageFromClipBoard,
                            focusNode: controller.inputFocus,
                            controller: controller.sendController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                              hintText: 'Message',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                            ),
                            onChanged: controller.onInputBarChanged,
                            suggestionEmojis: getDefaultEmojiLocale(
                              AppSettings.emojiSuggestionLocale.value.isNotEmpty
                                  ? Locale(AppSettings.emojiSuggestionLocale.value)
                                  : Localizations.localeOf(context),
                            ).fold(
                              [],
                              (emojis, category) => emojis..addAll(category.emoji),
                            ),
                          ),
                        ),
                      ),
                      PopupMenuButton<AddPopupMenuActions>(
                        useRootNavigator: true,
                        icon: const Icon(Icons.attach_file, color: Colors.grey),
                        onSelected: controller.onAddPopupMenuButtonSelected,
                        itemBuilder: (BuildContext context) => [
                          if (PlatformInfos.isMobile)
                            PopupMenuItem(
                              value: AddPopupMenuActions.location,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: theme.colorScheme.onPrimaryContainer,
                                  foregroundColor: theme.colorScheme.primaryContainer,
                                  child: const Icon(Icons.gps_fixed_outlined),
                                ),
                                title: Text(L10n.of(context).shareLocation),
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ),
                          PopupMenuItem(
                            value: AddPopupMenuActions.poll,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: theme.colorScheme.onPrimaryContainer,
                                foregroundColor: theme.colorScheme.primaryContainer,
                                child: const Icon(Icons.poll_outlined),
                              ),
                              title: Text(L10n.of(context).startPoll),
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          const PopupMenuDivider(),
                          if (PlatformInfos.isMobile) ...[
                            PopupMenuItem(
                              value: AddPopupMenuActions.videoCamera,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: theme.colorScheme.onPrimaryContainer,
                                  foregroundColor: theme.colorScheme.primaryContainer,
                                  child: const Icon(Icons.videocam_outlined),
                                ),
                                title: Text(L10n.of(context).recordAVideo),
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ),
                            PopupMenuItem(
                              value: AddPopupMenuActions.photoCamera,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: theme.colorScheme.onPrimaryContainer,
                                  foregroundColor: theme.colorScheme.primaryContainer,
                                  child: const Icon(Icons.camera_alt_outlined),
                                ),
                                title: Text(L10n.of(context).takeAPhoto),
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ),
                            const PopupMenuDivider(),
                          ],
                          PopupMenuItem(
                            value: AddPopupMenuActions.media,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: theme.colorScheme.onPrimaryContainer,
                                foregroundColor: theme.colorScheme.primaryContainer,
                                child: const Icon(Icons.image_outlined),
                              ),
                              title: Text(L10n.of(context).openGallery),
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          PopupMenuItem(
                            value: AddPopupMenuActions.file,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: theme.colorScheme.onPrimaryContainer,
                                foregroundColor: theme.colorScheme.primaryContainer,
                                child: const Icon(Icons.attachment_outlined),
                              ),
                              title: Text(L10n.of(context).sendFile),
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                      if (!textMessageOnly)
                        IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.grey),
                          onPressed: controller.openCameraAction,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Material(
                color: FluffyThemes.whatsappSecondaryGreen,
                shape: const CircleBorder(),
                elevation: 1,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: PlatformInfos.platformCanRecord &&
                          !textMessageOnly &&
                          controller.editEvent == null
                      ? HoverBuilder(
                          builder: (context, hovered) => IconButton(
                            tooltip: L10n.of(context).voiceMessage,
                            onPressed: hovered
                                ? () => recordingViewModel.startRecording(
                                    controller.room,
                                  )
                                : () => ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          L10n.of(context).longPressToRecordVoiceMessage,
                                        ),
                                      ),
                                    ),
                            onLongPress: () => recordingViewModel.startRecording(
                              controller.room,
                            ),
                            icon: const Icon(Icons.mic, color: Colors.white),
                          ),
                        )
                      : IconButton(
                          key: const Key('send_button'),
                          tooltip: L10n.of(context).send,
                          onPressed: controller.send,
                          icon: const Icon(Icons.send, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
