import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/student.dart';

class DatabaseHelper{
  //database
  DatabaseHelper._privateConstructor(); // Name constructor to create database
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  //getter for database

  Future<Database> get database async {
    _database ??= await initializeDatabase();


    return _database!;

  }
  Future<Database> initializeDatabase() async {
    // get the directory path for both Android and iOS
    // to store database

    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/students.db';

    // open create database at a given path
    var studentsDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,

    );
    return studentsDatabase;
  }
// create table for student
  void _createDb(Database db, int newVersion) async{
    await db.execute('''Create TABLE tbl_student (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  course TEXT,
  mobile TEXT,
  totalFee INTEGER,
  feePaid INTEGER,
  date TEXT
  )
  ''');
  }
  Future<int> insertStudent( Student s) async {
    // add student to table

    Database db = await instance.database;
    // int result = await db.rawInsert('INSERT INTO tbl_student (name, course, mobile, totalFee, feePaid) VALUES (?, ?, ?, ?, ?)',[s.name, s.course, s.mobile, s.totalFee, s.feePaid]);
    int result = await db.insert('tbl_student', s.toMap());
    return result;
  }
  //read
  Future<List<Student>> getAllStudents() async {
    List<Student> students = [];

    //read data from table
    Database db = await instance.database;
    //db.rawQuery('SELECT * from tbl_student');
    List<Map<String, dynamic>> listMap = await db.query('tbl_student');
    for( var studentMap in listMap){

      Student s = Student.fromMap(studentMap);
      students.add(s);
    }
    await Future.delayed(const Duration(seconds: 1));
    return students;
  }
  // Update
  Future<int> updateStudent( Student s) async {
    Database db = await instance.database;
    /* int result = await db.rawUpdate('UPDATE tbl_student set name=?, course=?, mobile=?, totalFee=?, FeePaid=?,where id=?',
    [s.name, s.course, s.mobile, s.totalFee, s.feePaid, s.id]
    );
    */
    int result = await db.update('tbl_student', s.toMap(), where: 'id=?', whereArgs: [s.id]);
    return result;
  }

// delete
  Future<int> deleteStudent( int id) async {
    Database db = await instance.database;
    int result = await db.rawDelete('DELETE from tbl_student where id=?', [id] );
    //int result = await db.delete('tbl_student', where: 'id=?', whereArgs: [id]);
    return result;
  }
// search operation
  Future<List<Student>> searchStudents({required String name}) async {
    List<Student> students = [];

    Database db = await instance.database;

    // read data from table
    // we will get list of map
    // wild card search
    List<Map<String, dynamic>> listMap = await db.query('tbl_Student, where: name like ?', whereArgs: ['%$name%']);

    // List<Map<String, dynamic>> listOfStudents = await db.rawQuery('SELECT * from $tableStudent');

    // converting map to object and then adding to the list
    for (var studentMap in listMap) {
      Student s = Student.fromMap(studentMap);
      students.add(s);
    }

    //await Future.delayed(const Duration(seconds: 2));

    return students;
  }

}
// Future<void> _startPrint(BluetoothDevice device) async {
//   await BluetoothPrintPlus.connect(device);
//   if (!mounted) return ;
//   // Preparing print data
//   List<Map<String, dynamic>> printData = [
//     {'type': 'text', 'content': "Student Details", 'align': 'center', 'linefeed': 1},
//     {'type': 'text', 'content': "Name: ${widget.student.name}", 'linefeed': 1},
//     {'type': 'text', 'content': "Course: ${widget.student.course}", 'linefeed': 1},
//     {'type': 'text', 'content': "Mobile: ${widget.student.mobile}", 'linefeed': 1},
//     {'type': 'text', 'content': "Total Fee: ${widget.student.totalFee}", 'linefeed': 1},
//     {'type': 'text', 'content': "Fee Paid: ${widget.student.feePaid}", 'linefeed': 2},
//   ];
//
//   try {
//     // Use printReceipt to send data
//     await BluetoothPrintPlus.printData;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Printing successful!')),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Printing failed: $e')),
//     );
//   } finally {
//     await BluetoothPrintPlus.disconnect();
//   }
// }