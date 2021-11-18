import 'dart:ffi';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3/open.dart';

void testSqflite() async {
  // Override to tizen specific name
  open.overrideForAll(() => DynamicLibrary.open('libsqlite3.so.0'));

  sqfliteFfiInit();

  // Use noIsolate to avoid non-root isolate issue
  var databaseFactory = createDatabaseFactoryFfi(noIsolate: true);
  var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

  await db.execute('''
  CREATE TABLE Product (
      id INTEGER PRIMARY KEY,
      title TEXT
  )
  ''');
  await db.insert('Product', <String, Object?>{'title': 'Product 1'});
  await db.insert('Product', <String, Object?>{'title': 'Product 1'});

  var result = await db.query('Product');
  print(result);
  // prints [{id: 1, title: Product 1}, {id: 2, title: Product 1}]
  await db.close();
}

void main() {
  testSqflite();
}
