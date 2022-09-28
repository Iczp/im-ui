import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:im_core/im_core.dart';
import '../commons/utils.dart';
import '../widgets/close_btn.dart';

/// 消息预览（引用等）
class MessagePreview extends StatefulWidget {
  const MessagePreview({
    Key? key,
    this.message,
    this.onClose,
    this.closeBtnSize = 18,
    this.isDisplayClose = false,
    this.onQuoteMessageTap,
    this.margin,
  }) : super(key: key);

  ///消息
  final MessageDto? message;

  ///
  final VoidCallback? onQuoteMessageTap;

  ///
  final bool isDisplayClose;

  ///
  final VoidCallback? onClose;

  ///
  final double closeBtnSize;

  ///
  final EdgeInsetsGeometry? margin;

  ///
  @override
  State<MessagePreview> createState() => _MessagePreviewState();
}

class _MessagePreviewState extends State<MessagePreview> {
  bool _isActive = false;

  void setIsActive(bool value) {
    setState(() {
      _isActive = value;
    });

    widget.onQuoteMessageTap?.call();
  }

  final TextStyle _textStyle = const TextStyle(
    color: Color.fromARGB(255, 97, 97, 97),
    fontSize: 12,
    // height: 1.6,
  );

  Widget _closeBtn() {
    if (!widget.isDisplayClose) {
      return const SizedBox();
    }
    return Positioned(
      right: 4,
      top: 3,
      child: CloseBtn(
        size: widget.closeBtnSize,
        onClose: widget.onClose,
      ),
    );
  }

  ///
  Widget textWidget(String text) {
    return Text(
      text,
      style: _textStyle,
      // maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// message content
  Widget buildMessageContent() {
    var message = widget.message!;
    switch (widget.message!.type) {
      case MessageTypeEnum.text:
        var textContent = message.content as TextContentDto;
        return textWidget(textContent.text);
      case MessageTypeEnum.sound:
        var videoContent = message.content as SoundContentDto;
        return textWidget(formatDuration(videoContent.time!));
      case MessageTypeEnum.image:
        var imageContentDto = message.content as ImageContentDto;
        return textWidget(' ${formatSize(imageContentDto.size)} ');
      case MessageTypeEnum.video:
        var videoContent = message.content as VideoContentDto;
        return textWidget(
            '${formatDuration(videoContent.duration)}/${formatSize(videoContent.size)}');
      case MessageTypeEnum.file:
        var fileContentDto = message.content as FileContentDto;
        return textWidget(
            '${fileContentDto.fileName} ${formatSize(fileContentDto.contentLength)}');
      default:
        return textWidget(widget.message!.type.toString());
    }
  }

  ///引用图标
  Widget quoteIcon() {
    return const Icon(
      Icons.format_quote_sharp,
      size: 14,
      color: Color.fromARGB(255, 186, 186, 186),
    );
  }

  ///消息类型图标
  Widget messageTypeIcon() {
    return Text(
      widget.message!.type.toText(),
      style: _textStyle,
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    if (widget.message == null) {
      return const SizedBox();
    }
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(8, 5, 8, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                // margin: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                padding: EdgeInsets.fromLTRB(10, 0,
                    widget.isDisplayClose ? widget.closeBtnSize + 10 : 10, 0),
                constraints: const BoxConstraints.tightFor(height: 24.0), //卡片大小
                alignment: Alignment.center, //卡片内文字居中
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: _isActive
                        ? const Color.fromARGB(255, 150, 150, 150)
                        : const Color.fromARGB(255, 183, 183, 183),
                    width: 0.5,
                  ),
                  boxShadow: _isActive
                      ? const [
                          //卡片阴影
                          BoxShadow(
                            color: Color.fromARGB(134, 230, 230, 230),
                            offset: Offset(0, 0),
                            blurRadius: 0.5,
                          )
                        ]
                      : null,
                ),
                child: Listener(
                  onPointerDown: (details) {
                    Logger().i(details);
                    setIsActive(true);
                  },
                  onPointerUp: (details) {
                    setIsActive(false);
                  },
                  onPointerCancel: (details) {
                    setIsActive(false);
                  },
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      quoteIcon(),
                      messageTypeIcon(),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: buildMessageContent(),
                      ),
                      quoteIcon(),
                    ],
                  ),
                ),
              ),
              _closeBtn()
            ],
          ),
        ],
      ),
    );
  }
}
