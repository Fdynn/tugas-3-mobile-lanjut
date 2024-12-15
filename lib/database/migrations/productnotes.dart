import 'package:vania/vania.dart';

class Productnotes extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('productnotes', () {
      char('note_id', length: 10);
      char('prod_id', length: 10);
      date('note_date');
      text('note_text');

      primary('note_id');
      index(ColumnIndex.indexKey, 'prod_id_foreign', ['prod_id']);

      foreign('prod_id', 'products', 'prod_id',
          constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('productnotes');
  }
}
