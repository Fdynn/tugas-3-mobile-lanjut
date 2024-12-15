import 'package:vania/vania.dart';

class Orders extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orders', () {
      integer('order_num', length: 11);
      date('order_date');
      char('cust_id', length: 5);

      primary('order_num');
      index(ColumnIndex.indexKey, 'cust_id_foreign', ['cust_id']);

      foreign('cust_id', 'customers', 'cust_id',
          constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
