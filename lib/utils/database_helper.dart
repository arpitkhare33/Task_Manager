import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;  //singleton object of DatabaseHelper class
  static Database _database;    //singleton Database

  String noteTable = 'note_table';
  String colId='id';
  String colTitle='title';
  String colDescription='description';
  String colPriority='priority';
  String colDate= 'date';
//above are the column names for the table

  DatabaseHelper._createInstance();  //Named constructor to create an instance of database helper
//singleton means throughout the application only one object will be created
 factory DatabaseHelper(){
   if(_databaseHelper==null) {
     _databaseHelper = DatabaseHelper._createInstance();
   }
     return _databaseHelper;

 }
 Future<Database> get database async{
   if(_database==null){
     _database=await initialiseDB();
   }
   return _database;
 }


 Future<Database> initialiseDB()async{
   //get the directory path for both ANDROID AND IOS for storing DB
   Directory directory = await getApplicationDocumentsDirectory();
   String path = directory.path +'notes.db';


   //open/create the database at this given path
   var notesDatabase = await openDatabase(path,version: 1,onCreate: _createDB);
   return notesDatabase;
 }

 void _createDB(Database db, int newVersion)async{
   await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)');

 }
 
 
 
 
 
 //fetch operation to get all the notes from the database
  Future<List<Map<String,dynamic>>> getNoteMapList()async{
  Database db = await this.database;
 // var result = db.rawQuery('SELECT * FROM $noteTable AS $colPriority ASC');
  var result = db.query(noteTable,orderBy: '$colPriority ASC');
  return result;  // we get a list of map in return
  }

  //insert note object into db
  Future<int> insertNote(Note note)async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }



  //update an existing note in the db
  Future<int> updateNote(Note note) async{
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),where: '$colId=?', whereArgs: [note.id]);
    return result;
  }



  //delete an existing note from the database
  Future<int> deleteNote(int id) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId =$id');
    return result;
  }



  // get the number of records present in the table
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT count(*) FROM $noteTable ');
    int result = Sqflite.firstIntValue(x);
    return result;
  }



  //get the List<Map> and convert it into List<Note>
  Future <List<Note>> getNoteList()async{
  var noteMapList= await getNoteMapList();// get map list from the database
    int count = noteMapList.length;
    List<Note> noteList = List<Note>(); // empty list of notes are created


    //for loop to create a note list from a map list
    for(int i=0;i<count;i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}