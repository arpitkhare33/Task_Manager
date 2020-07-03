class Note{
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  Note(this._title,this._date,this._priority,[this._description]);
  Note.withID(this._date,this._title,this._priority,[this._description]);
  int get id =>_id;
  String get title => _title;
  String get description =>_description;
  String get date => _date;
  int get priority=>_priority;


  set title(String newTitle){
    if(newTitle.length <255){
      this._title=newTitle;
    }
  }

  set description(String newDescription){
    if(newDescription.length <255){
      this._description=newDescription;
    }
  }
  set date(String newDate){

      this._date=newDate;

  }

  set priority(int newPriority){
    if(newPriority>=1 && newPriority<=2){
      this._priority=newPriority;
    }
  }


  //Convert a Note object into a map object
  Map <String,dynamic>toMap(){
    var map = Map <String,dynamic>() ;//created an empty map object
    if(_id!=null) {
      map['id'] = _id;
    }
    map['title']=_title;
    map['description']= _description;
    map['priority']=_priority;
    map['date']=_date;
    return map;
  }


  //Extract a note object from a map object
    Note.fromMapObject(Map <String,dynamic>map){
    this._id=map['id'];
    this._priority= map['priority'];
    this._description=map['description'];
    this._title=map['title'];
    this._date=map['date'];
    }
}