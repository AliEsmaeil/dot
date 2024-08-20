class Task{
  String title;
  String time;
  String date;

  Task({
    required this.title,
    required this.time,
    required this.date,
  });

  Map<String,String> toMap(){
    return {
      'title':title,
      'time':time,
      'date':date
    };
  }
  @override
  String toString()=> 'title : $title, time: $time, date : $date';

}