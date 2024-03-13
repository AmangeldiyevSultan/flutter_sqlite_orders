import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sqlite/core/common/widgets/loader.dart';
import 'package:flutter_sqlite/core/utils/helpers/show_toaster.dart';
import 'package:flutter_sqlite/src/app/di/app_scope.export.dart';
import 'package:flutter_sqlite/src/orders/bloc/order_bloc.dart';
import 'package:flutter_sqlite/src/orders/model/order_model.dart';
import 'package:flutter_sqlite/src/products/bloc/product_bloc.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late final OrderBloc _orderBloc;
  late final ProductBloc _productBloc;

  @override
  void initState() {
    super.initState();
    _productBloc = context.read<IAppScope>().productBloc;

    _orderBloc = context.read<IAppScope>().orderBloc;
  }

  Future<void> _onRemoveFromCart(int? orderId) async {
    if (orderId == null || _orderBloc.state.isProcessing) return;
    _orderBloc.add(OrderEvent.deleteOrder(orderId));
  }

  Future<void> _onAddToCardWithOrderId(Order order) async {
    if (!_orderBloc.state.isProcessing && !_productBloc.state.isProcessing) {
      final product = _productBloc.state.products!.firstWhereOrNull(
        (product) => product.id == order.productId,
      );
      if (product != null) {
        if (product.amount != null) {
          if (product.amount == 0) {
            CtmToaster.showError(
              context,
              msg: 'Product is out of stock',
            );
            return;
          }
          final order = _orderBloc.state.orders?.firstWhereOrNull(
            (order) => order.productId == product.id,
          );
          if (product.amount == order?.quantity) {
            CtmToaster.showError(
              context,
              msg: 'You have reached the maximum amount of this product',
            );
            return;
          }
        }
        _orderBloc.add(
          OrderEvent.addOrder(
            product,
          ),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    _orderBloc.add(const OrderEvent.fetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductBloc, ProductState>(
          bloc: _productBloc,
          listener: (context, state) {
            state.mapOrNull(
              idle: (product) {
                if (product.error != null) {
                  CtmToaster.showError(
                    context,
                    msg: 'Error while Fetching Products',
                  );
                }
                if (product.error == null) {
                  CtmToaster.show(
                    context,
                    msg: 'Product Successfully Fetched',
                  );
                }
              },
            );
          },
        ),
        BlocListener<OrderBloc, OrderState>(
          bloc: _orderBloc,
          listener: (context, state) {
            state.mapOrNull(
              idle: (order) {
                if (order.error != null) {
                  CtmToaster.showError(
                    context,
                    msg: 'Error while Processing Order',
                  );
                }
              },
            );
          },
        ),
      ],
      child: BlocBuilder<OrderBloc, OrderState>(
        bloc: _orderBloc,
        builder: (context, orderState) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: orderState.orders?.length ?? 0,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final order = orderState.orders![index];
                            return _orderListTile(order);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          disabledForegroundColor: Colors.transparent,
                          backgroundColor: Colors.green,
                          minimumSize: Size(0.7.sw, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  if (orderState.isProcessing) const Loader(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _orderListTile(Order order) {
    final product = _productBloc.state.products!.firstWhereOrNull(
      (product) => product.id == order.productId,
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: ListTile(
          title: Text(order.productName),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
              ),
              image: DecorationImage(
                image: NetworkImage(product!.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          subtitle: Text(
            'Price of Order: ${order.priceAtOrder.toStringAsFixed(2)} \$',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline_sharp,
                  color: Colors.green,
                ),
                onPressed: () => _onAddToCardWithOrderId(order),
              ),
              Text(
                order.quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: () => _onRemoveFromCart(order.id),
                icon: const Icon(
                  Icons.remove_circle_outline_sharp,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
