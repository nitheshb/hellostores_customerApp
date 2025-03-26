

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/model/chat_model.dart';
import 'package:goshops/infrastructure/model/model/message_model.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';

part 'chat_event.dart';

part 'chat_state.dart';

part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<CheckChatId>(checkChatId);

    on<CreateAndSendMessage>(createAndSendMessage);

    on<SendMessage>(sendMessage);

    on<SendImage>(sendImage);

    on<EditMessage>(editMessage);

    on<ReplyMessage>(replyMessage);

    on<DeleteMessage>(deleteMessage);
  }

  checkChatId(event, emit) async {
    emit(state.copyWith(
      isMessageLoading: true,
    ));
    final res = await chatRepository.getChat(sellerId: event.sellerId);
    res.fold((l) {
      emit(state.copyWith(
        chatModel: l,
        isMessageLoading: false,
      ));
    }, (r) {
      emit(state.copyWith(
        isMessageLoading: false,
      ));
    });
  }

  createAndSendMessage(event, emit) async {
    final res = await chatRepository.createChat(id: event.userId);
    res.fold((l) async {
      emit(state.copyWith(chatModel: l));
      event.onSuccess();
    }, (r) {
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  sendMessage(event, emit) {
    chatRepository.sendMessage(
        chatDocId: event.chatId ?? state.chatModel?.docId ?? "",
        message: MessageModel(
            message: event.message,
            senderId: LocalStorage.getUser().id ?? 0,
            doc: ""));
  }

  sendImage(event, emit) async {
    emit(state.copyWith(isButtonLoading: true));
    final res =
        await galleryRepository.uploadImage(event.file, UploadType.chats);
    res.fold((image) {
      chatRepository.sendMessage(
          chatDocId: event.chatId ?? state.chatModel?.docId ?? "",
          message: MessageModel(
              message: image.imageData?.title,
              senderId: LocalStorage.getUser().id ?? 0,
              type: "image",
              doc: ""));
      emit(state.copyWith(isButtonLoading: false));
    }, (r) {
      emit(state.copyWith(isButtonLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  editMessage(event, emit) {
    chatRepository.editMessage(
        chatDocId: event.chatId ?? state.chatModel?.docId ?? "",
        message: event.message,
        docId: event.messageId);
  }

  replyMessage(event, emit) {
    chatRepository.replyMessage(
      chatDocId: event.chatId ?? state.chatModel?.docId ?? "",
      message: MessageModel(
          message: event.message,
          senderId: LocalStorage.getUser().id ?? 0,
          doc: "",
          replyDocId: event.messageId),
    );
  }

  deleteMessage(event, emit) {
    chatRepository.deleteMessage(
        chatDocId: event.chatId ?? state.chatModel?.docId ?? "",
        docId: event.messageId);
  }
}
