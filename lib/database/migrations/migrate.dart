import 'dart:io';
import 'package:vania/vania.dart';
import 'package:vania_api/database/migrations/create_personal_access_tokens_table.dart';
import 'customers.dart';
import 'orders.dart';
import 'products.dart';
import 'vendors.dart';
import 'productnotes.dart';
import 'orderitems.dart';
import 'users.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreatePersonalAccessTokensTable().up();
    await Customers().up();
    await Orders().up();
    await Vendors().up();
    await Products().up();
    await Productnotes().up();
    await Orderitems().up();
    await Users().up();
  }

  dropTables() async {
    await Users().down();
    await Orderitems().down();
    await Productnotes().down();
    await Products().down();
    await Vendors().down();
    await Orders().down();
    await Customers().down();
  }
}
