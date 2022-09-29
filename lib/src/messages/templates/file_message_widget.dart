import 'package:bubble/bubble.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';

import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';

import '../../app.dart';
import '../../commons/utils.dart';
import '../../models/message_arguments.dart';

import '../../widgets/message_menu_buttons_all.dart';
import '../containers/bubble_container.dart';
import 'message_template_widget.dart';
import '../message_widget.dart';

class FileMessageWidget extends MessageTemplateWidget {
  const FileMessageWidget({
    super.key,
    required super.arguments,
  });

  @override
  State<FileMessageWidget> createState() => _FileMessageWidgetState();
}

class _FileMessageWidgetState extends MessageWidgetState<FileMessageWidget> {
  ///文本
  FileContentDto get fileContent =>
      arguments.message.getContent<FileContentDto>();

  ///
  TextDirection get textDirection =>
      widget.isSelf ? TextDirection.rtl : TextDirection.ltr;

  ///
  @override
  List<MessageMenuButton> buildMessageMenus(MessageArguments arguments) => [
        CopyMessageMenuButton(arguments),
        QuoteMessageMenuButton(arguments),
        // SoundPlayMessageMenuButton(arguments),
        // ForwardMessageMenuButton(arguments),
        FavoriteMessageMenuButton(arguments),
        ReminderMessageMenuButton(arguments),
        // HeadphonesMessageMenuButton(arguments),
        ChoiceMessageMenuButton(arguments),
        RollbackMessageMenuButton(arguments),
        ShareMessageMenuButton(arguments),
      ];

  ///
  @override
  Widget buildMessageContentWidget(BuildContext context) {
    // return Text('data');

    return bodyGestureDetector(
      child: BubbleContainer(
        color: const Color.fromARGB(219, 255, 255, 255),
        padding: const BubbleEdges.symmetric(vertical: 4, horizontal: 4),
        isSelf: widget.isSelf,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 240,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: FileIcon('${fileContent.suffix}', size: 36),
                    ),
                    Expanded(
                      child: Text(
                        '${fileContent.fileName}',
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 0.5,
                color: Colors.black12,
              ),
              footerWidget()
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget footerWidget() {
    var textStyle = const TextStyle(
      color: Colors.black26,
      fontSize: 12,
    );
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formatSize(fileContent.contentLength),
            style: textStyle,
          ),
          Text(
            '${fileContent.suffix}',
            style: textStyle,
          ),
        ],
      ),
    );
  }

  @override
  Future<void> onMessageTap() async {
    super.onMessageTap();
    try {
      var a = await OpenFile.open(fileContent.path);
      Logger().d(a.message);
      Logger().d(a.type);
    } catch (err) {
      Logger().e(err);
      hideToast();
      showToast(msg: '打开文件失败');
    }
  }
}
