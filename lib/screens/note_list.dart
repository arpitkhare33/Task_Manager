import 'package:flutter/material.dart';
import 'package:note_keeper/main.dart';
import 'package:note_keeper/screens/note_detail.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
class NoteKeeper extends StatefulWidget {


  @override
  _NoteKeeperState createState() => _NoteKeeperState();
}

class _NoteKeeperState extends State<NoteKeeper> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count=0;
  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      noteList =List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),

      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          debugPrint('FAB Pressed');
          navigateToDetail(Note('','',2),'Add Note!');
        },
      ),
    );
  }
  ListView getNoteListView(){
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount:count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,

          child: ListTile(
            title: Text(this.noteList[position].title),
            subtitle: Text(this.noteList[position].date),
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),

            ),
            trailing: GestureDetector(
                child: Icon(Icons.delete_forever),
            onTap: (){
                  _delete(context, noteList[position]);
                  debugPrint('Deleting the note!');
            },),
            onTap: (){
              debugPrint('Icon pressed');
              navigateToDetail(this.noteList[position],'Edit Node!');
            },
          ),

        );

      },
    );
  }

  //returns the priority color
  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }


  //returns the priority icon
  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }


  void _delete(BuildContext context, Note note)async{
  int result = await databaseHelper.deleteNote(note.id);
  if (result!=0){
    _showSnackBar(context,'Note Deleted Successfully!');
    //TODO: Update the List view
    updateListView();
  }
  }

  void _showSnackBar(BuildContext context,String message){
    final snackbar= SnackBar(content: Text(message),duration: const Duration(seconds: 3),);
    Scaffold.of(context).showSnackBar(snackbar);
  }
  void navigateToDetail(Note note,String title)async{
    bool result=await Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteDetail(note,title)));

    if(result==true){
      updateListView();
    }
  }


  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initialiseDB();
    dbFuture.then((database){

      Future <List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count= noteList.length;
        });

      });
    });
  }
}
