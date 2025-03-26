import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:intl/intl.dart';
import '../model/location_model.dart';

class CreateParcelModel {
  final int typeId;
  final LocationModel from;
  final String fromTitle;
  final LocationModel to;
  final String toTitle;
  final String time;
  final String note;
  final String phoneFrom;
  final String phoneTo;
  final String usernameTo;
  final String usernameFrom;
  final String floorTo;
  final String floorFrom;
  final String houseFrom;
  final String houseTo;
  final String comment;
  final String value;
  final String instruction;
  final bool notify;
  final int? paymentId;

  CreateParcelModel(
      {required this.typeId,
      required this.from,
      required this.fromTitle,
      required this.to,
      required this.toTitle,
      required this.time,
      required this.note,
      required this.phoneFrom,
      required this.phoneTo,
      required this.usernameTo,
      required this.usernameFrom,
      required this.floorTo,
      required this.floorFrom,
      required this.houseFrom,
      required this.houseTo,
      required this.comment,
      required this.value,
      required this.instruction,
      required this.notify,
      required this.paymentId});

  factory CreateParcelModel.fromJson({
    required int typeId,
    required LocationModel from,
    required String fromTitle,
    required LocationModel to,
    required String toTitle,
    required String time,
    required String note,
    required String phoneFrom,
    required String phoneTo,
    required String usernameTo,
    required String usernameFrom,
    required String floorTo,
    required String floorFrom,
    required String houseFrom,
    required String houseTo,
    required String comment,
    required String value,
    required String instruction,
    required bool notify,
    required int? paymentId,
  }) {
    return CreateParcelModel(
        typeId: typeId,
        from: from,
        fromTitle: fromTitle,
        to: to,
        toTitle: toTitle,
        time: time,
        note: note,
        phoneFrom: phoneFrom,
        phoneTo: phoneTo,
        usernameTo: usernameTo,
        usernameFrom: usernameFrom,
        floorTo: floorTo,
        floorFrom: floorFrom,
        houseFrom: houseFrom,
        houseTo: houseTo,
        comment: comment,
        value: value,
        instruction: instruction,
        notify: notify,
        paymentId: paymentId);
  }

  Map<String, dynamic> toJson() {
    return {
      'lang': LocalStorage.getLanguage()?.locale,
      'type_id': typeId,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      if (paymentId != null) "payment_id": paymentId,
      "address_from": {
        "address": fromTitle,
        "latitude": from.latitude,
        "longitude": from.longitude,
        if (floorFrom.isNotEmpty) 'stage': floorFrom,
        if (houseFrom.isNotEmpty) 'house': houseFrom,
      },
      "address_to": {
        "address": toTitle,
        "latitude": to.latitude,
        "longitude": to.longitude,
        if (floorTo.isNotEmpty) 'stage': floorTo,
        if (houseTo.isNotEmpty) 'house': houseTo,
      },
      'rate': LocalStorage.getSelectedCurrency()?.rate,
      'delivery_date':
          "${DateFormat("yyyy-MM-dd").format(DateTime.now())} $time",
      if (comment.isNotEmpty) 'note': comment,
      if (instruction.isNotEmpty) 'instruction': instruction,
      if (note.isNotEmpty) 'description': note,
      if (value.isNotEmpty) 'qr_value': value,
      'phone_from': phoneFrom,
      'phone_to': phoneTo,
      'notify': notify ? 1 : 0,
      'username_from': usernameFrom,
      'username_to': usernameTo,
    };
  }
}
