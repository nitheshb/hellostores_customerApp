import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/model/local_cart_model.dart';
import 'package:goshops/infrastructure/model/response/cart_calculate_response.dart';
import 'package:goshops/infrastructure/model/response/cart_response.dart';
import 'package:goshops/infrastructure/model/response/product_calculate_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';

part 'cart_event.dart';

part 'cart_state.dart';

part 'cart_bloc.freezed.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<GetCart>(getCart);

    on<AcceptTerm>(acceptTerm);

    on<InsertCart>(insertCart);

    on<RemoveProductCart>(removeProductCart);

    on<SetNotes>(setNotes);

    on<CheckCoupon>(checkCoupon);

    on<UpdateState>(updateState);

    on<CalculateCart>(calculateCart);

    on<CalculateCartWithCoupon>(calculateCartWithCoupon);

    on<StartGroupOrder>(startGroupOrder);

    on<CreateLink>(createLink);

    on<DeleteCart>(deleteCart);

    on<DeleteUser>(deleteUser);

    on<ChangeReady>(changeReady);
  }

  acceptTerm(event, emit) async {
    emit(state.copyWith(isAcceptTerm: !state.isAcceptTerm));
  }

  getCart(event, emit) async {
    if (event.refresh ?? false) {
      emit(state.copyWith(isButtonLoading: true));
    } else {
      emit(state.copyWith(isLoading: true));
    }
    if (LocalStorage.getGroupOrder().id == null &&
        LocalStorage.getCartList().isNotEmpty) {
      cartRepository.insertCart();
    } else {
      cartRepository.insertGroupCart();
    }

    final res = LocalStorage.getGroupOrder().id == null
        ? await cartRepository.getCart()
        : await cartRepository.getGroupCart();
    res.fold((l) {
      emit(state.copyWith(
          isLoading: false, isButtonLoading: false, cart: l.cart, notes: []));
      if (!(state.cart?.group ?? false)) {
        LocalStorage.deleteGroupOrder();
      }
      List<LocalCartModel> list = [];
      l.cart?.userCarts?.first.cartDetails?.forEach((element) {
        element.cartDetailProducts?.forEach((e) {
          if (!(e.bonus ?? false)) {
            list.add(LocalCartModel(
                productId: e.stocks?.product?.id,
                stockId: e.stocks?.id ?? 0,
                count: e.quantity ?? 0));
          }
        });
      });
      LocalStorage.setTotalCartList(list: list);
    }, (r) {
      emit(state.copyWith(
        isLoading: false,
        isButtonLoading: false,
      ));
      if (r != "Item's not found.") {
        AppHelpers.errorSnackBar(context: event.context, message: r);
      }
    });
  }

  insertCart(event, emit) async {
    if (LocalStorage.getCartList().isNotEmpty) {
      if (event.refresh ?? false) {
        emit(state.copyWith(isButtonLoading: true));
      } else {
        emit(state.copyWith(isLoading: true));
      }

      if (LocalStorage.getGroupOrder().id != null) {
        final res = await cartRepository.insertGroupCart();
        res.fold((l) {
          emit(state.copyWith(
              isLoading: false,
              isButtonLoading: false,
              cart: l.cart,
              notes: []));

          event.onSuccess.call();
        }, (r) {
          emit(state.copyWith(
            isLoading: false,
            isButtonLoading: false,
          ));
          AppHelpers.errorSnackBar(context: event.context, message: r);
        });
        return;
      }

      if (LocalStorage.getToken().isNotEmpty) {
        final res = await cartRepository.insertCart();
        res.fold((l) {
          emit(state.copyWith(
              isLoading: false,
              isButtonLoading: false,
              cart: l.cart,
              notes: []));
          if (!(state.cart?.group ?? false)) {
            LocalStorage.deleteGroupOrder();
          }
          List<LocalCartModel> list = [];
          l.cart?.userCarts?.first.cartDetails?.forEach((element) {
            element.cartDetailProducts?.forEach((e) {
              if (!(e.bonus ?? false)) {
                list.add(LocalCartModel(
                    productId: e.stocks?.product?.id,
                    stockId: e.stocks?.id ?? 0,
                    count: e.quantity ?? 0));
              }
            });
          });

          LocalStorage.setTotalCartList(list: list);
          event.onSuccess.call();
        }, (r) {
          emit(state.copyWith(
            isLoading: false,
            isButtonLoading: false,
          ));
          AppHelpers.errorSnackBar(context: event.context, message: r);
        });
      } else {
        if (LocalStorage.getCartList()
            .where((element) => element.count > 0)
            .isEmpty) {
          emit(state.copyWith(
            isLoading: false,
            isButtonLoading: false,
          ));
          return;
        }
        final res = await cartRepository.productCalculateCart();
        res.fold((p) {
          emit(state.copyWith(
              isLoading: false,
              isButtonLoading: false,
              productCalculate: p,
              notes: []));

          List<LocalCartModel> list = [];
          p.data?.shops?.forEach((element) {
            element.stocks?.forEach((e) {
              list.add(LocalCartModel(
                  productId: e.stock?.product?.id,
                  stockId: e.stock?.id ?? 0,
                  count: e.quantity ?? 0));
            });
          });

          LocalStorage.setTotalCartList(list: list);
          event.onSuccess.call();
        }, (r) {
          emit(state.copyWith(
            isLoading: false,
            isButtonLoading: false,
          ));
          AppHelpers.errorSnackBar(context: event.context, message: r);
        });
      }
    } else {
      emit(state.copyWith(
        isLoading: true,
      ));
      emit(state.copyWith(
        isLoading: false,
        isButtonLoading: false,
      ));
    }
  }

  removeProductCart(event, emit) async {
    if (LocalStorage.getToken().isNotEmpty && (state.cart?.group ?? false)) {
      return;
    }
    emit(state.copyWith(isButtonLoading: true));
    final res = await cartRepository.removeProductCart(
        cartDetailId: event.cartDetailId ?? 0);
    res.fold((l) {
      emit(state.copyWith(isButtonLoading: false, cart: l.cart));
      List<LocalCartModel> list = [];
      l.cart?.userCarts?.first.cartDetails?.forEach((element) {
        element.cartDetailProducts?.forEach((e) {
          if (!(e.bonus ?? false)) {
            list.add(LocalCartModel(
                productId: e.stocks?.product?.id,
                stockId: e.stocks?.id ?? 0,
                count: e.quantity ?? 0));
          }
        });
      });

      LocalStorage.setTotalCartList(list: list);
      if (LocalStorage.getToken().isNotEmpty) {
        add(CartEvent.calculateCartWithCoupon(context: event.context));
      }
    }, (r) {
      emit(state.copyWith(
        isButtonLoading: false,
      ));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  setNotes(event, emit) {
    emit(state.copyWith(isButtonLoading: true));
    List<ProductNote> list = List.from(state.notes ?? []);
    bool isAdd = true;
    for (int i = 0; i < list.length; i++) {
      if (list[i].stockId == event.stockId) {
        list[i].comment = event.note;
        isAdd = false;
        break;
      }
    }
    if (isAdd) {
      list.add(ProductNote(stockId: event.stockId, comment: event.note));
    }
    emit(state.copyWith(notes: list, isButtonLoading: false));
  }

  checkCoupon(event, emit) async {
    if (event.clear ?? false) {
      emit(state.copyWith(coupons: {}));
      return;
    }

    final res = await cartRepository.checkCoupon(
        coupon: event.coupon, shopId: event.shopId);
    res.fold((l) {
      Map<int, String> coupons = Map.from(state.coupons);
      coupons[event.shopId] = event.coupon;
      emit(state.copyWith(coupons: coupons));
    }, (r) {
      Map<int, String> coupons = Map.from(state.coupons);
      coupons.remove(event.shopId);
      emit(state.copyWith(coupons: coupons));
      if (event.coupon.trim().isNotEmpty) {
        AppHelpers.errorSnackBar(
          context: event.context,
          message: r,
        );
      }
    });
  }

  updateState(event, emit) {
    emit(state.copyWith(isLoading: !state.isLoading));
    emit(state.copyWith(isLoading: !state.isLoading));
  }

  calculateCart(event, emit) async {
    emit(state.copyWith(
      isLoading: true,
      cartCalculate: null,
    ));
    final res = await cartRepository.calculateCart(
      cartId: state.cart?.id ?? 0,
      pointId: event.pointId,
      deliveryPriceId: event.deliveryPriceId,
      coupon: state.coupons,
      fullDigital: event.fullDigital,
      type: event.type,
    );
    res.fold((l) {
      emit(state.copyWith(isLoading: false, cartCalculate: l.data));
    }, (r) {
      emit(state.copyWith(isLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  calculateCartWithCoupon(event, emit) async {
    if (LocalStorage.getToken().isEmpty) return;
    if (state.cart?.id == null) return;
    emit(state.copyWith(
      isLoading: true,
      cartCalculate: null,
    ));
    final res = await cartRepository.calculateCart(
      fullDigital: true,
      cartId: state.cart?.id ?? 0,
      withoutDeliveryFee: true,
      coupon: state.coupons,
      type: 1,
    );
    res.fold((l) {
      emit(state.copyWith(isLoading: false, cartCalculate: l.data));
    }, (r) {
      emit(state.copyWith(isLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r);
    });
  }

  startGroupOrder(event, emit) async {
    emit(state.copyWith(isButtonLoading: true));

    final res = await cartRepository.startGroupOrder(cartId: state.cart?.id);
    res.fold((l) {
      emit(state.copyWith(cart: l.cart));
      event.onSuccess.call();
    }, (r) {
      emit(state.copyWith(
        isButtonLoading: false,
      ));
    });
  }

  createLink(event, emit) async {
    if (state.cart?.group ?? false) {
      final res = await cartRepository.createLink(cartId: state.cart?.id ?? 0);
      res.fold((l) {
        emit(state.copyWith(isButtonLoading: false, groupOrderLink: l));
      }, (r) {
        emit(state.copyWith(
          isButtonLoading: false,
        ));
      });
    }
  }

  deleteCart(event, emit) async {
    emit(state.copyWith(isButtonLoading: true));
    final res = await cartRepository.deleteCart(cartId: state.cart?.id ?? 0);
    res.fold((l) {
      LocalStorage.deleteCartList();
      emit(state.copyWith(isButtonLoading: false, cart: null));
    }, (r) {
      emit(state.copyWith(isButtonLoading: false));
    });
  }

  deleteUser(event, emit) async {
    emit(state.copyWith(isButtonLoading: true));
    final res = await cartRepository.deleteUser(
        cartId: state.cart?.id ?? 0, uuid: event.uuid);
    event.onSuccess.call();
    res.fold((l) {
      emit(state.copyWith(isButtonLoading: false));
    }, (r) {
      emit(state.copyWith(isButtonLoading: false));
    });
  }

  changeReady(event, emit) async {
    emit(state.copyWith(isButtonLoading: true));
    final res = await cartRepository.changeStatus(
        cartId: state.cart?.id ?? 0, uuid: event.uuid);
    event.onSuccess.call();
    res.fold((l) {
      emit(state.copyWith(isButtonLoading: false));
    }, (r) {
      emit(state.copyWith(isButtonLoading: false));
    });
  }
}
