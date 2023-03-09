import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/chat_object_provider.dart';
import '../../providers/user_provider.dart';
import 'message_menu_button.dart';

class ShareMessageMenuButton extends MessageMenuButton {
  ///
  const ShareMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '分享';

  ///
  @override
  IconData get icon => Icons.share;

  @override
  State<ShareMessageMenuButton> createState() => _ShareMessageMenuButtonState();
}

class _ShareMessageMenuButtonState
    extends MessageMenuButtonState<ShareMessageMenuButton> {
  ///
  get content => message.content;

  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.messageType}');
    super.onTap();

    var senderInfo = context.read<ChatObjectProvider>().get(message.senderId);

    var sendName = '${senderInfo?.name}';
    switch (message.messageType) {
      case MessageTypeEnum.file:
        var fileContent = content as FileContentDto;
        Share.shareFiles([fileContent.path!],
            text: '$sendName 发送的文件[${fileContent.fileName}]');
        break;
      case MessageTypeEnum.video:
        var videoContent = content as VideoContentDto;
        Share.shareFiles([videoContent.path!], text: '$sendName 发送的视频');
        break;
      case MessageTypeEnum.sound:
        var soundContent = content as SoundContentDto;
        Share.shareFiles([soundContent.path!], text: '$sendName 发送的语音');
        break;
      case MessageTypeEnum.image:
        var imageContent = content as ImageContentDto;
        Share.shareFiles([imageContent.path!], text: '$sendName 发送的图片');
        break;
      default:
    }
  }
}
