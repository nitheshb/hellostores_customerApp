

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/request/create_order_model.dart';
import 'package:goshops/infrastructure/model/model/order_model.dart';
import 'package:goshops/infrastructure/model/response/payments_response.dart';
import 'package:goshops/infrastructure/model/response/refund_pagination_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/presentation/route/app_route.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'order_event.dart';

part 'order_state.dart';

part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  int active = 0;
  int refund = 0;

  OrderBloc() : super(const OrderState()) {
    on<FetchActiveOrders>(fetchActiveOrders);

    on<FetchRefundOrders>(fetchRefundOrders);

    on<FetchOrderById>(fetchOrderById);

    on<FetchRefundOrderById>(fetchRefundOrderById);

    on<CreateOrder>(createOrder);

    on<CancelOrder>(cancelOrder);

    on<RefundOrder>(refundOrder);
  }

  fetchActiveOrders(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      active = 0;
      emit(state.copyWith(activeOrders: [], isLoadingActive: true));
    }
    final res =
        await ordersRepository.getOrders(page: ++active, type: "active");
    res.fold((l) {
      List<OrderShops> list = List.from(state.activeOrders);
      list.addAll(l.data ?? []);
      emit(state.copyWith(isLoadingActive: false, activeOrders: list));
      if (event.isRefresh ?? false) {
        event.controller?.refreshCompleted();
        return;
      } else if (l.data?.isEmpty ?? true) {
        event.controller?.loadNoData();
        return;
      }
      event.controller?.loadComplete();
      return;
    }, (r) {
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      emit(state.copyWith(isLoadingActive: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchRefundOrders(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      refund = 0;
      emit(state.copyWith(refundOrders: [], isLoadingRefund: true));
    }
    final res = await ordersRepository.getRefundOrders(
      page: ++refund,
    );
    res.fold((l) {
      List<RefundModel> list = List.from(state.refundOrders);
      list.addAll(l.data ?? []);
      emit(state.copyWith(isLoadingRefund: false, refundOrders: list));
      if (event.isRefresh ?? false) {
        event.controller?.refreshCompleted();
        return;
      } else if (l.data?.isEmpty ?? true) {
        event.controller?.loadNoData();
        return;
      }
      event.controller?.loadComplete();
      return;
    }, (r) {
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();
      emit(state.copyWith(isLoadingRefund: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchOrderById(event, emit) async {
    emit(state.copyWith(
        order: event.order, isLoading: true, anotherOrder: false));
    final res = await ordersRepository.getOrderDetails(event.id);
    res.fold((order) {
      emit(state.copyWith(isLoading: false, order: order));
    }, (r) {
      emit(state.copyWith(isLoading: false));
      if (r == 404) {
        emit(state.copyWith(anotherOrder: true));
        return;
      }
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  fetchRefundOrderById(event, emit) async {
    emit(state.copyWith(
        refundOrder: event.refund, isLoading: true, anotherOrder: false));
    final res = await ordersRepository.getRefundOrderDetails(event.id);
    res.fold((order) {
      emit(state.copyWith(isLoading: false, refundOrder: order));
    }, (r) {
      emit(state.copyWith(isLoading: false));
      if (r == 404) {
        emit(state.copyWith(anotherOrder: true));
        return;
      }
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  createOrder(event, emit) async {
    emit(state.copyWith(isLoading: true));
    final num wallet = LocalStorage.getUser().wallet?.price ?? 0;
    if (event.payment.tag == "wallet" && wallet < event.totalPrice) {
      AppHelpers.errorSnackBar(
        context: event.context,
        message: AppHelpers.getTranslation(TrKeys.notEnoughMoney),
      );
      emit(state.copyWith(isLoading: false));
      return;
    }
    if (event.payment.tag == "maksekeskus") {
      emit(state.copyWith(isLoading: false));
      final isPay =
          await AppRoute.goWebView(url: event.link, context: event.context);
      if (!isPay) {
        event.onFailure.call();
        return;
      } else {
        event.onSuccess.call();
      }
      return;
    } else if (event.payment.tag != "cash" && event.payment.tag != "wallet") {
      final res = await paymentsRepository.paymentWebView(
          name: event.payment.tag ?? "", order: event.order);
      res.fold((l) async {
        emit(state.copyWith(isLoading: false));
        final isPay = await AppRoute.goWebView(url: l, context: event.context);
        if (!isPay) {
          event.onFailure.call();
          return;
        } else {
          event.onSuccess.call();
        }
      }, (r) {
        emit(state.copyWith(isLoading: false));
        AppHelpers.errorSnackBar(context: event.context, message: r);
      });
      return;
    }
    final res = await ordersRepository.createOrder(order: event.order);
    res.fold((success) async {
      emit(state.copyWith(isLoading: false));
      event.onSuccess();
    }, (r) {
      emit(state.copyWith(isLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  cancelOrder(event, emit) async {
    emit(state.copyWith(isButtonLoading: true));
    final res = await ordersRepository.cancelOrder(orderId: event.id);
    res.fold((data) {
      event.onSuccess.call();
      emit(state.copyWith(isButtonLoading: false));
    }, (r) {
      emit(state.copyWith(isButtonLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  refundOrder(event, emit) async {
    emit(state.copyWith(isButtonLoading: true));
    final res = await ordersRepository.refundOrder(
        orderId: event.id, title: event.reason);
    res.fold((data) {
      event.onSuccess.call();
      emit(state.copyWith(isButtonLoading: false));
    }, (r) {
      emit(state.copyWith(isButtonLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }
}
