import 'dart:io';
import 'package:vania/vania.dart';
import 'create_users_table.dart';
import 'create_products_table.dart';

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
		 await CreateUserTable().up();
		 await CreateProductsTable().up();
	}

  dropTables() async {
		 await CreateProductsTable().down();
		 await CreateUserTable().down();
	 }
}
