import java.util.*;
import java.util.stream.*;

Table subjectData;
Table idData;
Table deweyData;
Table deweyList;

ArrayList<Subject> subjects = new ArrayList<Subject>();
int subject_row;

ArrayList<SubjectDict> subjectDict = new ArrayList<SubjectDict>();
int id_row;

ArrayList<DeweyDict> deweyDict = new ArrayList<DeweyDict>();
int dewey_row;


void ReadData(){
  subjectData = loadTable("subject_co-occurrency.csv", "header");
  subject_row = subjectData.getRowCount();
  
  idData = loadTable("subjectList.csv", "header");
  id_row = idData.getRowCount();
  
  deweyData = loadTable("deweyList.csv", "header");
  dewey_row = deweyData.getRowCount();
  
  
  //import subject data
  for (int i=0; i<subject_row; i++)
  {
    int id = Integer.parseInt(subjectData.getString(i,0));
    String name = subjectData.getString(i,1);
    List<Integer> A_dewey = getIntegerArray(subjectData.getString(i,2));
    List<Integer> A_subject = getIntegerArray(subjectData.getString(i,3));
    List<Integer> A_subject_frequency = getIntegerArray(subjectData.getString(i,4));
    List<Integer> B_dewey = getIntegerArray(subjectData.getString(i,5));
    List<Integer> B_subject = getIntegerArray(subjectData.getString(i,6));
    List<Integer> B_subject_frequency = getIntegerArray(subjectData.getString(i,7));

    subjects.add(new Subject(id, name, A_dewey, A_subject, A_subject_frequency, B_dewey, B_subject, B_subject_frequency));
  }
  
  //import subject list data
  for (int i=0; i<id_row; i++)
  {
    int id = Integer.parseInt(idData.getString(i,0));
    String name = idData.getString(i,1);

    subjectDict.add(new SubjectDict(id, name));
  }

  //import dewey list data
  for (int i=0; i<dewey_row; i++)
  {
    int id = Integer.parseInt(deweyData.getString(i,0));
    String name = deweyData.getString(i,1);

    deweyDict.add(new DeweyDict(id, name));
  }
}

//transform string to int
private List<Integer> getIntegerArray(String stringArray) {
  stringArray = stringArray.substring(1, stringArray.length()-1);
  try{
    List<Integer> output = Arrays.asList(stringArray.split(",")).stream().map(s -> Integer.parseInt(s.trim())).collect(Collectors.toList());
    return output;
  }
   catch(Exception ex) 
  {
    return List.of();
  }
}



//class information
class Subject
{
  int id;
  String name;
  List<Integer> A_dewey = new ArrayList<Integer>();
  List<Integer> A_subject = new ArrayList<Integer>();
  List<Integer> A_subject_frequency = new ArrayList<Integer>();
  List<Integer> B_dewey = new ArrayList<Integer>();
  List<Integer> B_subject = new ArrayList<Integer>();
  List<Integer> B_subject_frequency = new ArrayList<Integer>();
  
  Subject(int id, String name, List<Integer> A_dewey,  List<Integer> A_subject, List<Integer> A_subject_frequency, List<Integer> B_dewey, List<Integer> B_subject, List<Integer> B_subject_frequency)
  {
    this.id = id;
    this.name = name;
    this.A_dewey = A_dewey;
    this.A_subject = A_subject;
    this.A_subject_frequency = A_subject_frequency;
    this.B_dewey = B_dewey;
    this.B_subject = B_subject;
    this.B_subject_frequency = B_subject_frequency;
  }
}

class SubjectDict
{
  int id;
  String name;
  
  SubjectDict(int id, String name)
  {
    this.id = id;
    this.name = name;
  }
}

class DeweyDict
{
  int id;
  String name;
  
  DeweyDict(int id, String name)
  {
    this.id = id;
    this.name = name;
  }
}
