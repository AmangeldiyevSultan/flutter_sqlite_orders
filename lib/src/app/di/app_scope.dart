part of 'app_scope.export.dart';

class AppScope implements IAppScope {
  /// Create an instance [AppScope].
  AppScope();

  late final ProductBloc _productBloc;
  late final OrderBloc _orderBloc;

  @override
  late VoidCallback applicationRebuilder;

  @override
  Future<sql.Database> get database => _initDatabase();

  @override
  ProductBloc get productBloc => _productBloc;

  @override
  OrderBloc get orderBloc => _orderBloc;

  @override
  Future<void> initServices() async {
    final database = await _initDatabase();
    await _productService(database);
    await _orderService(database);
  }

  Future<sql.Database> _initDatabase() async {
    return sql.openDatabase(
      'flutter_sqlite.db',
      version: 1,
      onCreate: (db, version) async {
        await SQLHelper.createProductsTable(db);
        await SQLHelper.createOrdersTable(db);
      },
    );
  }

  Future<void> _productService(sql.Database db) async {
    final dataSource = ProductDataSourceImpl(db: db);
    final productRepository = ProductRepositoryImpl(dataSource);
    _productBloc = ProductBloc(productRepository: productRepository);
  }

  Future<void> _orderService(sql.Database db) async {
    final dataSource = OrderDataSourceImpl(db: db);
    final orderRepository = OrderRepositoryImpl(dataSource);
    _orderBloc = OrderBloc(orderRepository: orderRepository);
  }
}

abstract class IAppScope {
  /// Callback to rebuild the whole application.
  VoidCallback get applicationRebuilder;

  /// Database instance.
  Future<sql.Database> get database;

  /// Get instance of [ProductBloc]
  ProductBloc get productBloc;

  /// Get instance of [OrderBloc]
  OrderBloc get orderBloc;

  /// Init repo to use it later
  Future<void> initServices();
}
