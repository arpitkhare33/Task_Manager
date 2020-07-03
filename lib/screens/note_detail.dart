import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
class NoteDetail extends StatefulWidget {
  NoteDetail(this.note,this.appBarTitle);
  final String appBarTitle;
  final Note note;
  @override
  _NoteDetailState createState() => _NoteDetailState(note,appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  _NoteDetailState(this.note,this.appBarTitle);
  String appBarTitle;
  Note note;
  DatabaseHelper databaseHelper = DatabaseHelper();
  static var _priorities=['High','Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    TextStyle textFieldStyle=  Theme.of(context).textTheme.headline6;
    titleController.text= note.title;
    descriptionController.text= note.description;
    return WillPopScope(

      onWillPop: () {
        moveToLastScreen();
      },
        child: Scaffold(
          appBar: AppBar(
            title: Text('$appBarTitle'),
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
              moveToLastScreen();
            },),


          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15,bottom: 15),
            child: ListView(
              children: <Widget>[
                ListTile(
                    title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) => DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      )).toList(),
                      onChanged: (valueSelectedByUser){
                        setState(() {
                          //debugPrint('User selected $valueSelectedByUser');
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      },
                      style: textStyle,
                      value: getPriorityAsString(note.priority),
                    )
                ),
                //Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15,bottom: 15),
                  child: TextField(
                    controller: titleController,
                    style: textFieldStyle,
                    onChanged: (titleEntered){
                     // debugPrint('User entered $titleEntered');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        )
                    ),
                  ),
                ),
                //Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15,bottom: 15),
                  child: TextField(
                    controller: descriptionController,
                    style: textFieldStyle,

                    onChanged: (descriptionEntered){
                      //debugPrint('User entered $descriptionEntered');
                      updateDescription();
                    },

                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15,bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text('Save',textScaleFactor: 1.5,),
                          onPressed: (){
                            setState(() {
                              debugPrint('Save Button Clicked!');

                                _saveData();


                            });
                          },
                        ),
                      ),
                      Container(width: 5.0,),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text('Delete',textScaleFactor: 1.5,),
                          onPressed: (){
                            setState(() {
                              debugPrint('Delete Button Clicked!');
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),

          ),
        ),

    );
  }
  void moveToLastScreen(){
    Navigator.pop(context,true);
}



//Convert the String priority into int priority
  int updatePriorityAsInt(String value){
  switch(value){
    case 'High':
      note.priority=1;
      break;
    case 'Low':
      note.priority=2;
      break;


  }
  }


  //Convert the int priority into String priority to display in the drop down list


  String getPriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority=_priorities[0]; //High
        break;
      case 2:
        priority= _priorities[1];  //low
        break;

    }
    return priority;

  }


  //update the title of note object
  void updateTitle(){
    note.title=titleController.text;
  }



  //update the description of note object
  void updateDescription(){
    note.description= descriptionController.text;
  }


  //save data to the database
    void _saveData()async{



    //note.date = DateFormat.yMMMd().format(DateTime.now());
    note.date=DateFormat('d/MMM/y hh:mm aaa' ).format(DateTime.now());
      var result;
      if(note.title.isNotEmpty) {
        moveToLastScreen();
        if (note.id != null) { // case 1: update operation

          result = await databaseHelper.updateNote(note);
        }
        else { //case 2: insert new entry operation
          result = await databaseHelper.insertNote(note);
        }
        if(result!=0){

          _showAlertDialog('Status','Note Saved Successfully!');
        }
        else{

          _showAlertDialog('Status','Problem saving Note!');
        }
      }
      else{
        _showAlertDialog('Error', 'Please enter a TASK!');
      }



    }
    void _delete()async{
      //case 1: if the user is trying to delete the new note, i.e. he has come to note_detail page by clicking FAB button of NoteList Page

      moveToLastScreen();
      if(note.id==null){
        _showAlertDialog('Status', 'No Note was deleted');
        return;
      }
      // case 2: user is trying to delete an existing note, which has a valid id

     int result= await databaseHelper.deleteNote(note.id);
      if(result!=0)
        {
          _showAlertDialog('Status','Note was Deleted Successfully');

        }
      else
        _showAlertDialog('Status','Error occured while Deleting Note');
      }

    void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(title: Text(title),content: Text(message),);
    showDialog(context: context,builder:(_)=> alertDialog);
    }
}
