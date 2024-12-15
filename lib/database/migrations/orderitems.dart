import 'package:vania/vania.dart';

class Orderitems extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      integer('order_item', length: 11);
      integer('order_num', length: 11);
      char('prod_id', length: 10);
      integer('quantity', length: 11);
      integer('size', length: 11);

      primary('order_item');
      index(ColumnIndex.indexKey, 'order_num_foreign', ['order_num']);
      index(ColumnIndex.indexKey, 'prod_id_foreign', ['prod_id']);

      foreign('order_num', 'orders', 'order_num',
          constrained: true, onDelete: 'CASCADE');
      foreign('prod_id', 'products', 'prod_id',
          constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
