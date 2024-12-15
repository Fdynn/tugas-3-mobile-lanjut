import 'package:vania/vania.dart';

class Products extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      char('prod_id', length: 5);
      char('vend_id', length: 10);
      string('prod_name', length: 25);
      integer('prod_price');
      text('prod_desc');

      primary('prod_id');
      index(ColumnIndex.indexKey, 'vend_id_foreign', ['vend_id']);

      foreign('vend_id', 'vendors', 'vend_id',
          constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
