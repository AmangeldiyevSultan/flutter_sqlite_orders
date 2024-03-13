import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sqlite/core/common/widgets/loader.dart';
import 'package:flutter_sqlite/core/utils/helpers/show_toaster.dart';
import 'package:flutter_sqlite/src/app/di/app_scope.export.dart';
import 'package:flutter_sqlite/src/orders/bloc/order_bloc.dart';
import 'package:flutter_sqlite/src/orders/model/order_model.dart';
import 'package:flutter_sqlite/src/products/bloc/product_bloc.dart';
import 'package:flutter_sqlite/src/products/model/product_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductBloc _productBloc;
  late final OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _productBloc = context.read<IAppScope>().productBloc
      ..add(const ProductEvent.fetchProducts());

    _orderBloc = context.read<IAppScope>().orderBloc
      ..add(const OrderEvent.fetchOrders());
  }

  Future<void> _onRefresh() async {
    _productBloc.add(const ProductEvent.fetchProducts());
    _orderBloc.add(const OrderEvent.fetchOrders());
  }

  Future<void> _onRemoveFromCart(int? orderId) async {
    if (orderId == null || _orderBloc.state.isProcessing) return;
    _orderBloc.add(OrderEvent.deleteOrder(orderId));
  }

  Future<void> _onAddToCart(Product product) async {
    if (_orderBloc.state.isProcessing) return;
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
    _orderBloc.add(OrderEvent.addOrder(product));
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
          return BlocBuilder<ProductBloc, ProductState>(
            bloc: _productBloc,
            builder: (context, productState) {
              final products = productState.products;
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Stack(
                    children: [
                      if (productState.error == null)
                        Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: orderState.orders?.length ?? 0,
                              itemBuilder: (context, index) {
                                final order = orderState.orders![index];
                                return _orderListTile(order);
                              },
                            ),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: products?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final product = productState.products![index];
                                  return GestureDetector(
                                    onTap: () => _onAddToCart(product),
                                    child: ProductCard(product: product),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      if (productState.isProcessing || orderState.isProcessing)
                        const Loader(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  ListTile _orderListTile(Order order) {
    return ListTile(
      title: Text(order.productName),
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
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                if (product.amount == 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.red,
                      child: const Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(product.name),
          Text('${product.price} \$'),
        ],
      ),
    );
  }
}
