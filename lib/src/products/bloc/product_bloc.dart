import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sqlite/core/utils/logger.dart';
import 'package:flutter_sqlite/src/products/data/product_repository.dart';
import 'package:flutter_sqlite/src/products/model/product_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_bloc.freezed.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.fetchProducts() = _FetchProductEvent;
}

@freezed
class ProductState with _$ProductState {
  const ProductState._();

  const factory ProductState.idle({
    List<Product>? products,
    Object? error,
  }) = _SuccessProductState;

  /// Processing state.
  const factory ProductState.processing({
    List<Product>? products,
    Object? error,
  }) = _ProcessingProductState;

  /// Returns whether the state is processing or not.
  bool get isProcessing => maybeMap(
        orElse: () => false,
        processing: (_) => true,
      );
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(const ProductState.processing()) {
    on<_FetchProductEvent>(_fetchProductHandler);
  }

  final ProductRepository _productRepository;

  Future<void> _fetchProductHandler(
    _FetchProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      ProductState.processing(
        products: state.products,
        error: state.error,
      ),
    );

    try {
      final products = await _productRepository.getProducts();

      emit(
        ProductState.idle(
          products: products,
        ),
      );

      return;
    } on Object catch (e, stackTrace) {
      logger.error('Error while fetching product: $e', stackTrace: stackTrace);
      emit(
        ProductState.idle(
          products: state.products,
          error: e,
        ),
      );
      rethrow;
    }
  }
}
