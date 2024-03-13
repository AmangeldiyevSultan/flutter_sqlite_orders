import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sqlite/core/utils/logger.dart';
import 'package:flutter_sqlite/src/orders/data/order_repository.dart';
import 'package:flutter_sqlite/src/orders/model/order_model.dart';
import 'package:flutter_sqlite/src/products/model/product_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_bloc.freezed.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.fetchOrders() = _FetchOrderEvent;

  const factory OrderEvent.addOrder(Product product) = _AddOrderEvent;

  const factory OrderEvent.deleteOrder(int orderId) = _DeleteOrderEvent;
}

@freezed
class OrderState with _$OrderState {
  const OrderState._();

  const factory OrderState.idle({
    List<Order>? orders,
    Object? error,
  }) = _SuccessOrderState;

  /// Processing state.
  const factory OrderState.processing({
    List<Order>? orders,
    Object? error,
  }) = _ProcessingOrderState;

  /// Returns whether the state is processing or not.
  bool get isProcessing => maybeMap(
        orElse: () => false,
        processing: (_) => true,
      );
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    required OrderRepository orderRepository,
  })  : _orderRepository = orderRepository,
        super(const OrderState.processing()) {
    on<_FetchOrderEvent>(_fetchOrderHandler);
    on<_AddOrderEvent>(_addOrderHandler);
    on<_DeleteOrderEvent>(_deleteOrderHandler);
  }

  final OrderRepository _orderRepository;

  Future<void> _deleteOrderHandler(
    _DeleteOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      OrderState.processing(
        orders: state.orders,
        error: state.error,
      ),
    );

    try {
      final order =
          state.orders?.firstWhereOrNull((order) => order.id == event.orderId);

      if (order != null) {
        if (order.quantity > 1) {
          await _orderRepository.updateOrder(
            order.copyWith(
              quantity: order.quantity - 1,
              priceAtOrder: order.priceAtOrder - order.productPrice,
              updatedAt: DateTime.now().toUtc(),
            ),
          );
        } else {
          await _orderRepository.deleteOrder(event.orderId);

          emit(
            OrderState.idle(
              orders: state.orders
                  ?.where((order) => order.id != event.orderId)
                  .toList(),
            ),
          );
        }
        emit(
          OrderState.idle(
            orders: state.orders?.map((order) {
              if (order.id == event.orderId) {
                return order.copyWith(
                  quantity: order.quantity - 1,
                  priceAtOrder: order.priceAtOrder - order.productPrice,
                  updatedAt: DateTime.now().toUtc(),
                );
              }
              return order;
            }).toList(),
          ),
        );
      }

      return;
    } on Object catch (e, stackTrace) {
      logger.error('Error while deleting order: $e', stackTrace: stackTrace);
      emit(
        OrderState.idle(
          orders: state.orders,
          error: e,
        ),
      );
      rethrow;
    }
  }

  Future<void> _addOrderHandler(
    _AddOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      OrderState.processing(
        orders: state.orders,
        error: state.error,
      ),
    );

    try {
      final order = state.orders?.firstWhereOrNull(
        (order) => order.productId == event.product.id,
      );

      if (order == null) {
        final orderId = await _orderRepository.addOrder(
          Order(
            productId: event.product.id,
            productName: event.product.name,
            productPrice: event.product.price,
            priceAtOrder: event.product.price,
            quantity: 1,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
        final updatedOrders = List<Order>.from(state.orders ?? []);
        updatedOrders.add(
          Order(
            id: orderId,
            productId: event.product.id,
            productName: event.product.name,
            productPrice: event.product.price,
            priceAtOrder: event.product.price,
            quantity: 1,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );

        emit(
          OrderState.idle(
            orders: updatedOrders,
          ),
        );
      } else {
        await _orderRepository.updateOrder(
          order.copyWith(
            quantity: order.quantity + 1,
            priceAtOrder: order.priceAtOrder + event.product.price,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
        emit(
          OrderState.idle(
            orders: state.orders?.map((order) {
              if (order.productId == event.product.id) {
                return order.copyWith(
                  quantity: order.quantity + 1,
                  priceAtOrder: order.priceAtOrder + event.product.price,
                  updatedAt: DateTime.now().toUtc(),
                );
              }
              return order;
            }).toList(),
          ),
        );
      }

      return;
    } on Object catch (e, stackTrace) {
      logger.error('Error while adding order: $e', stackTrace: stackTrace);
      emit(
        OrderState.idle(
          orders: state.orders,
          error: e,
        ),
      );
      rethrow;
    }
  }

  Future<void> _fetchOrderHandler(
    _FetchOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      OrderState.processing(
        orders: state.orders,
        error: state.error,
      ),
    );

    try {
      final orders = await _orderRepository.getOrders();

      emit(
        OrderState.idle(
          orders: orders,
        ),
      );

      return;
    } on Object catch (e, stackTrace) {
      logger.error('Error while fetching order: $e', stackTrace: stackTrace);
      emit(
        OrderState.idle(
          orders: state.orders,
          error: e,
        ),
      );
      rethrow;
    }
  }
}
