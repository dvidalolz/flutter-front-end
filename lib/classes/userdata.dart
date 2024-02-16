import 'package:circle_app/classes/surveydata.dart';

import 'contact.dart';

class UserData {
  String? email;
  String? password;
  String? address;
  String? number;
  String? name;
  String? gender;
  String? civilStatus;
  DateTime? birthday;
  List<Contact>? trustedContacts;
  SurveyData? surveyData;

  UserData({
    this.email,
    this.password,
    this.address,
    this.number,
    this.name,
    this.gender,
    this.civilStatus,
    this.birthday,
    this.trustedContacts,
    this.surveyData,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'address': address,
      'number': number,
      'name': name,
      'gender': gender,
      'civilStatus': civilStatus,
      'birthday': birthday?.toIso8601String(),
      'trustedContacts':
          trustedContacts?.map((contact) => contact.toJson()).toList(),
      'surveyData': surveyData
    };
  }
}
