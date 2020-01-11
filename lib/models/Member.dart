
class Member {

  Name name = new Name() ;
  Contact contactInfo = new Contact();
  Profession profession = new Profession();
  String dob = "";
  String batch = "";
  String status = "active";
  String clusterId = "";
}

class Name {
  String firstName = "";
  String lastName = "";
  String middleInitial = "";
  String nickname ="";
}

class Contact {
  String email = "";
  String mobile = "";
}

class Profession {
  String jobTitle = "";
  String employer = "";
  String field = "";
}