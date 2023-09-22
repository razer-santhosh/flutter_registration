

// ignore_for_file: file_names, non_constant_identifier_names

//Course Concept Model Starts
class CourseConceptModel {
  final int id;
  final String name;

  const CourseConceptModel(
      {required this.id,
        required this.name,
      });

  //Json to Model
  factory CourseConceptModel.fromMap(Map<String, dynamic> json) => CourseConceptModel(
      id: (json["id"] != null) ? json["id"] :0,
      name: (json["name"] != null) ? json["name"] : "");

  //Model to Json
  Map toJson() => {
    'id': id,
    'name': name
  };
}
//Course Concept Ends


// Course Detail Model Starts
class CourseDetailModel {
  final int id;
  final String name;
  final String? max_amount_without_gst;
  final String? max_amount_with_gst;
  final String? maximum_installment_count;
  final String? duration;

  const CourseDetailModel(
      {required this.id,
        required this.name,
        this.max_amount_without_gst,
        this.max_amount_with_gst,
        this.maximum_installment_count,
        this.duration,
      });

  //Json to Model
  factory CourseDetailModel.fromMap(Map<String, dynamic> json) => CourseDetailModel(
      id: (json["id"] != null) ? json["id"] : 0,
      name: (json["name"] != null) ? json["name"] : "",
      max_amount_without_gst: (json["max_amount_without_gst"] != null) ? json["max_amount_without_gst"].toString() : "",
      max_amount_with_gst: (json["max_amount_with_gst"] != null) ? json["max_amount_with_gst"].toString() : "",
      maximum_installment_count: (json["maximum_installment_count"] != null) ? json["maximum_installment_count"].toString() : "",
      duration: (json["duration"] != null) ? json["duration"].toString() : ""
  );

  //Model to Json
  Map toJson() => {
    'id': id,
    'name': name,
    'max_amount_without_gst': max_amount_without_gst,
    'max_amount_with_gst': max_amount_with_gst,
    'maximum_installment_count': maximum_installment_count,
    'duration': duration
  };
}
// Course Detail Model Ends



// Course Register Detail Model Starts
  class CourseRegisterDetailModel {
  final int course_title_code_id;
  final int course_criteria_title_id;
  final String course_criteria_title_name;
  final String? max_amount_without_gst;
  final String? duration;
  final String? max_amount_with_gst;
  final String? min_token_amount_with_gst;
  final List<CourseConceptForRegisterModel>? course_concept_levels;

  const CourseRegisterDetailModel(
      {required this.course_title_code_id,
        required this.course_criteria_title_id,
        required this.course_criteria_title_name,
        this.max_amount_without_gst,
        this.duration,
        this.max_amount_with_gst,
        this.min_token_amount_with_gst,
        this.course_concept_levels
      });

  //Json to Model
  factory CourseRegisterDetailModel.fromMap(Map<String, dynamic> json) => CourseRegisterDetailModel(
      course_title_code_id: (json["course_title_code_id"] != null) ? json["course_title_code_id"] : 0,
      course_criteria_title_id: (json["course_criteria_title_id"] != null) ? json["course_criteria_title_id"] : 0,
      course_criteria_title_name: (json["course_criteria_title_name"] != null) ? json["course_criteria_title_name"] : "",
      max_amount_without_gst: (json["max_amount_without_gst"] != null) ? json["max_amount_without_gst"].toString() : "0",
      duration: (json["duration"] != null) ? json["duration"].toString() : "0",
      max_amount_with_gst: (json["max_amount_with_gst"] != null) ? json["max_amount_with_gst"].toString() : "0",
      min_token_amount_with_gst: (json["min_token_amount_with_gst"] != null) ? json["min_token_amount_with_gst"].toString() : "0",
      course_concept_levels:json["course_concept_levels"]

  );

  //Model to Json
  Map toJson() => {
    'course_title_code_id': course_title_code_id,
    'course_criteria_title_id': course_criteria_title_id,
    'course_criteria_title_name': course_criteria_title_name,
    'max_amount_without_gst': max_amount_without_gst,
    'duration': duration,
    'max_amount_with_gst': max_amount_with_gst,
    'min_token_amount_with_gst': min_token_amount_with_gst,
    'course_concept_levels': course_concept_levels
  };
}
// Course Register Detail Model Ends

// Course Concept for Registration Detail Model Ends
class CourseConceptForRegisterModel {
  final int course_concept_level_id;
  final int course_level_id;
  final String? course_level_name;
  final int? course_concept_id;
  final String? course_concept_name;
  final List<DeliverablesModel>? course_deliverables;
  const CourseConceptForRegisterModel(
      {required this.course_concept_level_id,
        required this.course_level_id,
        this.course_level_name,
        this.course_concept_id,
        this.course_concept_name,
        this.course_deliverables,
      });

  //Json to Model
  factory CourseConceptForRegisterModel.fromMap(Map<String, dynamic> json) => CourseConceptForRegisterModel(
      course_concept_level_id: (json["course_concept_level_id"] != null) ? json["course_concept_level_id"] : 0,
      course_level_id: (json["course_level_id"] != null) ? json["course_level_id"] : 0,
      course_level_name: (json["course_level_name"] != null) ? json["course_level_name"] : "",
      course_concept_id: json["course_concept_id"],
      course_concept_name: (json["course_concept_name"] != null) ? json["course_concept_name"].toString() : "",
      course_deliverables:  json["course_deliverables"]
  );

  //Model to Json
  Map toJson() => {
    'course_concept_level_id': course_concept_level_id,
    'course_level_id': course_level_id,
    'course_level_name': course_level_name,
    'course_concept_id': course_concept_id,
    'course_concept_name': course_concept_name,
    'course_deliverables': course_deliverables
  };
}

class DeliverablesModel {
  final int id;
  final String? name;
  final String? book_code;
  final int? course_deliverable_type_id;
  final String? course_deliverable_type_name;
  final String? amount;
  const DeliverablesModel(
      {required this.id,
        this.name,
        this.book_code,
        this.course_deliverable_type_id,
        this.course_deliverable_type_name,
        this.amount,
      });

  //Json to Model
  factory DeliverablesModel.fromMap(Map<String, dynamic> json) => DeliverablesModel(
      id: (json["id"] != null) ? json["id"] : 0,
      name: (json["name"] != null) ? json["name"] : "",
      book_code: (json["book_code"] != null) ? json["book_code"].toString() : "",
      course_deliverable_type_id: json["course_deliverable_type_id"],
      course_deliverable_type_name: (json["course_deliverable_type_name"] != null) ? json["course_deliverable_type_name"].toString() : "",
      amount: (json["amount"] != null) ? json["amount"].toString() : ""
  );

  //Model to Json
  Map toJson() => {
    'id': id,
    'name': name,
    'book_code': book_code,
    'course_deliverable_type_id': course_deliverable_type_id,
    'course_deliverable_type_name': course_deliverable_type_name,
    'amount': amount
  };
}


// Stream Model Starts
class StreamModel {
  final String? product_owner;
  final String? stream_name;
  final int id;
  final String name;
  final int? status;


  const StreamModel(
      {this.product_owner,
        this.stream_name,
        required this.id,
        required this.name,
        this.status,
      });

  //Json to Model
  factory StreamModel.fromMap(Map<String, dynamic> json) => StreamModel(
      product_owner: (json["product_owner"] != null) ? json["product_owner"] : "",
      stream_name: (json["stream_name"] != null) ? json["stream_name"] : "",
    id: (json["id"] != null) ? json["id"] : 0,
    name: (json["name"] != null) ? json["name"] : "",
    status: (json["status"] != null) ? json["status"] : 0

  );

  //Model to Json
  Map toJson() => {
    'product_owner': product_owner,
    'stream_name': stream_name,
    'id': id,
    'name': name,
    'status': status
  };
}
//Stream Model Ends



// Center List Model Starts
class CentreListModel {
  final int id;
  final String? centre_firm_name;
  final String? centre_name;
  final String? centre_code;
  final String? centre_status;
  final String? centre_email_id;
  final String? centre_contact_no;
  final String? centre_address;
  final int? centre_state_code;
  final int? centre_state_id;
  final int? centre_district_id;
  final int? master_company_type_id;
  final int? centre_country_id;
  final String? company_type;
  final String? company_plan;
  final String? division_name;
  final int? division_id;
  final int? partner_user_id;
  final String? partner_name;
  final String? partner_contact_no;
  final String? partner_email_id;
  final int? master_franchise_status_id;


  const CentreListModel(
      {required this.id,
        this.centre_firm_name,
        this.centre_name,
        this.centre_code,
        this.centre_status,
        this.centre_email_id,
        this.centre_contact_no,
        this.centre_address,
        this.centre_state_code,
        this.centre_state_id,
        this.centre_district_id,
        this.master_company_type_id,
        this.centre_country_id,
        this.company_type,
        this.company_plan,
        this.division_name,
        this.division_id,
        this.partner_user_id,
        this.partner_name,
        this.partner_contact_no,
        this.partner_email_id,
        this.master_franchise_status_id,
      });

  //Json to Model
  factory CentreListModel.fromMap(Map<String, dynamic> json) => CentreListModel(
      id: (json["id"] != null) ? json["id"] : 0,
      centre_firm_name: (json["centre_firm_name"] != null) ? json["centre_firm_name"] : "",
      centre_name: (json["centre_name"] != null) ? json["centre_name"] :"",
      centre_code: (json["centre_code"] != null) ? json["centre_code"] :"",
    centre_status: (json["centre_status"] != null) ? json["centre_status"] :"",
    centre_email_id: (json["centre_email_id"] != null) ? json["centre_email_id"] :"",
    centre_contact_no: (json["centre_contact_no"] != null) ? json["centre_contact_no"] :"",
    centre_address: (json["centre_address"] != null) ? json["centre_address"] :"",
    centre_state_code: json["centre_state_code"] ,
    centre_state_id: json["centre_state_id"] ,
    centre_district_id: json["centre_district_id"] ,
    master_company_type_id: json["master_company_type_id"] ,
    centre_country_id: json["centre_country_id"] ,
    company_type: (json["company_type"] != null) ? json["company_type"] :"",
    company_plan: (json["company_plan"] != null) ? json["company_plan"] :"",
    division_name: (json["division_name"] != null) ? json["division_name"] :"",
    division_id: json["division_id"] ,
    partner_user_id: json["partner_user_id"] ,
    partner_name: (json["partner_name"] != null) ? json["partner_name"] :"",
      partner_contact_no: (json["partner_contact_no"] != null) ? json["partner_contact_no"] :"",
      partner_email_id: (json["partner_email_id"] != null) ? json["partner_email_id"] :"",
      master_franchise_status_id: (json["master_franchise_status_id"] != null) ? json["master_franchise_status_id"] : 0
  );

  //Model to Json
  Map toJson() => {
    "id": id,
    "centre_firm_name": centre_firm_name,
    "centre_name": centre_name,
    "centre_code": centre_code,
    "centre_status": centre_status,
    "centre_email_id": centre_email_id,
    "centre_contact_no": centre_contact_no,
    "centre_address": centre_address,
    "centre_state_code": centre_state_code,
    "centre_state_id": centre_state_id,
    "centre_district_id": centre_district_id,
    "master_company_type_id": master_company_type_id,
    "centre_country_id": centre_country_id,
    "company_type": company_type,
    "company_plan": company_plan,
    "division_name": division_name,
    "division_id":division_id,
    "partner_user_id": partner_user_id,
    "partner_name":partner_name,
    "partner_contact_no":partner_contact_no,
    "partner_email_id": partner_email_id,
    "master_franchise_status_id": master_franchise_status_id
  };
}
// Center List Model Ends

