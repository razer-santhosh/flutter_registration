// ignore_for_file: non_constant_identifier_names, file_names
//Dashboard Model Starts
class DashboardModel {
  final int id;
  final String? start_date;
  final String? end_date;
  final String created_at;
  final String? sales_company_code;
  final int? master_logic_id;
  final int? master_course_enrollment_source_id;
  final String db_type;
  final int master_certificate_id;
  final String master_certificate_name;
  final String course_code;
  final int duration;
  final int? pdu;
  final int course_criteria_title_id;
  final String course_criteria_title_name;
  final int? course_affilation_id;
  final String course_affilation_name;
  final int free_course_eligible;
  final String? expired_date;
  final String? certificate_approved_at;
  final String? status;
  final String? session_link;
  final int nsdc_filled_status;

  const DashboardModel(
      {required this.id,
      this.start_date,
      this.end_date,
      required this.created_at,
      required this.master_certificate_id,
      required this.master_certificate_name,
      required this.course_code,
      required this.db_type,
      required this.duration,
      required this.course_criteria_title_id,
      required this.course_criteria_title_name,
      required this.course_affilation_id,
      required this.course_affilation_name,
      this.sales_company_code,
      this.expired_date,
      this.certificate_approved_at,
      this.master_course_enrollment_source_id,
      this.master_logic_id,
      this.status,
      this.pdu,
      required this.free_course_eligible,
      this.session_link,
      required this.nsdc_filled_status});
  //Json to Model
  factory DashboardModel.fromMap(Map<String, dynamic> json) => DashboardModel(
      id: int.tryParse(json["id"].toString()) ?? 0,
      start_date: json["start_date"],
      end_date: json["end_date"],
      created_at: json["created_at"] ?? "",
      sales_company_code: json["sales_company_code"] ?? "",
      master_logic_id: json["master_logic_id"] != null
          ? int.tryParse(json["master_logic_id"].toString())
          : null,
      master_course_enrollment_source_id:
          json["master_course_enrollment_source_id"] != null
              ? int.tryParse(
                  json["master_course_enrollment_source_id"].toString())
              : null,
      db_type: json["db_type"] ?? "old",
      master_certificate_id: json["master_certificate_id"] != null
          ? int.tryParse(json["master_certificate_id"].toString()) ?? 0
          : 0,
      master_certificate_name: json["master_certificate_name"] ?? "",
      course_code: json["course_code"] ?? "",
      duration: int.tryParse(json["duration"].toString()) ?? 0,
      pdu: json["pdu"] != null ? int.tryParse(json["pdu"].toString()) : null,
      course_criteria_title_id: json["course_criteria_title_id"] ?? 0,
      course_criteria_title_name: json["course_criteria_title_name"].toString(),
      course_affilation_id: json["course_affilation_id"] != null
          ? int.tryParse(json["course_affilation_id"].toString())
          : json["course_affilations_id"] != null
              ? int.tryParse(json["course_affilations_id"].toString())
              : 0,
      course_affilation_name: json["course_affilation_name"].toString(),
      free_course_eligible: json["free_course_eligible"] ?? 0,
      expired_date: json["expired_date"].toString(),
      certificate_approved_at: json["certificate_approved_at"].toString(),
      status: json["status"].toString(),
      session_link:
          json["session_link"] != null ? json["session_link"].toString() : "",
      nsdc_filled_status: json["nsdc_filled_status"]);

  //Model to Json
  toJson() => {
        'id': id,
        'start_date': start_date,
        'end_date': end_date,
        'created_at': created_at,
        'master_certificate_name': master_certificate_name,
        'master_certificate_id': master_certificate_id,
        'course_code': course_code,
        'db_type': db_type,
        'duration': duration,
        'course_criteria_title_id': course_criteria_title_id,
        'course_affilation_id': course_affilation_id,
        'course_affilation_name': course_affilation_name,
        'sales_company_code': sales_company_code,
        'pdu': pdu,
        'expired_date': expired_date,
        'certificate_approved_at': certificate_approved_at,
        'master_course_enrollment_source_id':
            master_course_enrollment_source_id,
        'master_logic_id': master_logic_id,
        'course_criteria_title_name': course_criteria_title_name,
        'free_course_eligible': free_course_eligible,
        'status': status,
        'session_link': session_link,
        'nsdc_filled_status': nsdc_filled_status
      };
}
//Dashboard Model Ends

//Course Concept Model Starts
class CourseConceptModel {
  final int id;
  final int status;
  final int course_learning_mode_id;
  final List<UserCoursePaymentModel> user_course_payment_deliverables;

  const CourseConceptModel(
      {required this.id,
      required this.status,
      required this.course_learning_mode_id,
      required this.user_course_payment_deliverables});

  //Json to Model
  factory CourseConceptModel.fromMap(Map<String, dynamic> json) =>
      CourseConceptModel(
          id: json["id"],
          status: json["status"],
          course_learning_mode_id: json["course_learning_mode_id"],
          user_course_payment_deliverables:
              json["user_course_payment_deliverables"]);

  //Model to Json
  Map toJson() => {
        'id': id,
        'status': status,
        'course_learning_mode_id': course_learning_mode_id,
        'user_course_payment_deliverables': user_course_payment_deliverables
      };
}
//Course Concept Model Ends

//Deliverables Model Starts
class UserCoursePaymentModel {
  final int id;
  final String course_deliverable_book_code;
  final int course_deliverable_id;
  final String course_deliverable_name;
  final int course_deliverable_type_id;
  final String course_deliverable_type_name;
  final int course_title_code_concept_level_deliverable_id;
  final int status;
  final int? user_company_barcode_id;
  final int course_concept_id;
  final int course_concept_level_id;
  final String course_concept_name;
  final int course_level_id;
  final String? course_level_name;
  final int course_service_provider_id;

  const UserCoursePaymentModel(
      {required this.id,
      required this.course_deliverable_book_code,
      required this.course_deliverable_id,
      required this.course_deliverable_name,
      required this.course_deliverable_type_id,
      required this.course_deliverable_type_name,
      required this.course_title_code_concept_level_deliverable_id,
      required this.status,
      this.user_company_barcode_id,
      required this.course_concept_id,
      required this.course_concept_level_id,
      required this.course_concept_name,
      required this.course_level_id,
      this.course_level_name,
      required this.course_service_provider_id});

  //Json to Model
  factory UserCoursePaymentModel.fromMap(Map<String, dynamic> json) =>
      UserCoursePaymentModel(
          id: json["id"],
          course_deliverable_book_code: json["course_deliverable_book_code"],
          course_deliverable_id: json["course_deliverable_id"],
          course_deliverable_name: json["course_deliverable_name"],
          course_deliverable_type_id: json["course_deliverable_type_id"],
          course_deliverable_type_name: json["course_deliverable_type_name"],
          course_title_code_concept_level_deliverable_id:
              json["course_title_code_concept_level_deliverable_id"],
          status: json["status"],
          user_company_barcode_id: json["user_company_barcode_id"],
          course_concept_id: json["course_concept_id"],
          course_concept_level_id: json["course_concept_level_id"],
          course_concept_name: json["course_concept_name"],
          course_level_id: json["course_level_id"],
          course_level_name: json["course_level_name"],
          course_service_provider_id: json["course_service_provider_id"]);

  //Model to Json
  Map toJson() => {
        'id': id,
        'course_deliverable_book_code': course_deliverable_book_code,
        'course_deliverable_id': course_deliverable_id,
        'course_deliverable_name': course_deliverable_name,
        'course_deliverable_type_id': course_deliverable_type_id,
        'course_deliverable_type_name': course_deliverable_type_name,
        'course_title_code_concept_level_deliverable_id':
            course_title_code_concept_level_deliverable_id,
        'status': status,
        'user_company_barcode_id': user_company_barcode_id,
        'course_concept_id': course_concept_id,
        'course_concept_level_id': course_concept_level_id,
        'course_concept_name': course_concept_name,
        'course_level_id': course_level_id,
        'course_level_name': course_level_name,
        'course_service_provider_id': course_service_provider_id
      };
}
//Deliverables Model Ends

//Technical Support Contact Model Starts
class TechnicalModel {
  final int id;
  final String name;
  final String company_code;
  final String email_id;
  final String contact_no;
  final String alternative_contact_no;

  const TechnicalModel(
      {required this.id,
      required this.name,
      required this.company_code,
      required this.email_id,
      required this.contact_no,
      required this.alternative_contact_no});

  //Json to Model
  factory TechnicalModel.fromMap(Map<String, dynamic> json) => TechnicalModel(
      id: (json["id"] != null) ? json["id"] : "",
      name: (json["name"] != null) ? json["name"] : "",
      company_code: (json["company_code"] != null) ? json["company_code"] : "",
      email_id: (json["email_id"] != null) ? json["email_id"] : "",
      contact_no: (json["contact_no"] != null) ? json["contact_no"] : "",
      alternative_contact_no: (json["alternative_contact_no"] != null)
          ? json["alternative_contact_no"]
          : "");

  //Model to Json
  Map toJson() => {
        'id': id,
        'name': name,
        'company_code': company_code,
        'email_id': email_id,
        'contact_no': contact_no,
        'alternative_contact_no': alternative_contact_no
      };
}
//Technical Support Contact Model Ends
