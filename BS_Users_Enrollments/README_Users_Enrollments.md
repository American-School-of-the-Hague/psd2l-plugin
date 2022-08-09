<!-- omit in toc -->
# BrightSpace D2L User and Enrollments (7-8)

PowerQuery Plugin for exporting the following information from PowerSchool &rarr; BrightSpace. This plugin creates the following exports:

- [Important Implementation Notes](#important-implementation-notes)
  - [User creation](#user-creation)
- [7 Users Parents Inactive](#7-users-parents-inactive)
  - [Fields Provided & Used](#fields-provided--used)
  - [Data Export Manager Setup](#data-export-manager-setup)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml)
- [7 Users Parents Active](#7-users-parents-active)
  - [Fields Provided & Used](#fields-provided--used-1)
  - [Data Export Manager Setup](#data-export-manager-setup-1)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-1)
- [7 Users Teachers Inactive](#7-users-teachers-inactive)
  - [Fields Provided & Used](#fields-provided--used-2)
  - [Data Export Manager Setup](#data-export-manager-setup-2)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-2)
- [7 Users Teachers Active](#7-users-teachers-active)
  - [Fields Provided & Used](#fields-provided--used-3)
  - [Data Export Manager Setup](#data-export-manager-setup-3)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-3)
- [7 Users Students Inactive](#7-users-students-inactive)
  - [Fields Provided & Used](#fields-provided--used-4)
  - [Data Export Manager Setup](#data-export-manager-setup-4)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-4)
- [7 Users Students Active](#7-users-students-active)
  - [Fields Provided & Used](#fields-provided--used-5)
  - [Data Export Manager Setup](#data-export-manager-setup-5)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-5)
- [8 Enrollments Teachers](#8-enrollments-teachers)
  - [Fields Provided & Used](#fields-provided--used-6)
  - [Data Export Manager Setup](#data-export-manager-setup-6)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-6)
- [8 Enrollments Teachers - School Level](#8-enrollments-teachers---school-level)
  - [Fields Provided & Used](#fields-provided--used-7)
  - [Data Export Manager Setup](#data-export-manager-setup-7)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-7)
- [8 Enrollments Students Active](#8-enrollments-students-active)
  - [Fields Provided & Used](#fields-provided--used-8)
  - [Data Export Manager Setup](#data-export-manager-setup-8)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-8)
- [8 Enrollments Students - School Level](#8-enrollments-students---school-level)
  - [Fields Provided & Used](#fields-provided--used-9)
  - [Data Export Manager Setup](#data-export-manager-setup-9)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-9)
- [8 Enrollments Students Active - Dropped Classes](#8-enrollments-students-active---dropped-classes)
  - [Fields Provided & Used](#fields-provided--used-10)
  - [Data Export Manager Setup](#data-export-manager-setup-10)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-10)
- [8 Enrollments Parents in Student Classes](#8-enrollments-parents-in-student-classes)
  - [Fields Provided & Used](#fields-provided--used-11)
  - [Data Export Manager Setup](#data-export-manager-setup-11)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-11)
- [8 Enrollments Parents in Student Classes - Drop](#8-enrollments-parents-in-student-classes---drop)
  - [Fields Provided & Used](#fields-provided--used-12)
  - [Data Export Manager Setup](#data-export-manager-setup-12)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-12)
- [8 Enrollments Students Athletics](#8-enrollments-students-athletics)
  - [Fields Provided & Used](#fields-provided--used-13)
  - [Data Export Manager Setup](#data-export-manager-setup-13)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-13)
- [8 Enrollments Parents Athletics](#8-enrollments-parents-athletics)
  - [Fields Provided & Used](#fields-provided--used-14)
  - [Data Export Manager Setup](#data-export-manager-setup-14)
  - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-14)

## Important Implementation Notes

### User creation
Usernames for parents and staff are set to their email addresses. Students are set to their @ash.nl address. Parent accounts are created with the guardian email address provided through the e-collect form.

Usernames for teachers are set to the username portion of their @ash.nl email address. This is to prevent username collisions with parent accounts.

User creation must occur in the following order: Parents, Teachers, Students. Student accounts are related to parent accounts through the `relations` field; this field requires the `org_defined_id` from the parents to exist. As of May 2022, this feature is not used. See the implementation choices documentation in the [README.md](../README.md/#important-implementation-choices).

D2L IPSIS processes CSV files in alphabetical order. To enforce the proper order, it is critical that the PowerSchool Data Export Manager templates are set with filenames that will sort such that parents come first, teachers second and students last. 

See the *Data Export Manager* section for each Named Query below.

## 7 Users Parents Inactive

There are two separate Named Queries (NQ) for parents, one for mother and one for father. These are listed as m_inactive and f_inactive respectively. These could potentially be combined in the future.

### Fields Provided & Used

**PROVIDES FIELDS:**

- `org_defined_id` used in [7-Users_Students_Active](#7usersstudentsactive) in `relationships` field as `Id` 

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `P_`_`GUARDIAN.GUARDIANID`_ | P_1234567

**USES FIELDS:**

- none

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.users.07m_inactive|07f_inactive`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|username|
|org_define_id|
|first_name|
|last_name|
|password|
|role_name|
|relationships|
|pref_first_name |
|pref_last_name |

**Export Summary and Output Options**

**NOTE:** Parents file must be processed before student files so relationships can be properly built. Prepend 000 (mother) and 001 (father) to parents CSV filename to ensure this. Students have 100 prepended.

- *Export File Name:* 
  - `7-Users_000_mother_inactive-%d.csv`
  - `7-Users_001_father_inactive-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- File: `07_u_m_inactive.named_queries.xml`
- File: `07_u_f_inactive.named_queries.xml`
- 
| header | table.field | value | NOTE |
|-|-|-|-|
|type| STUDENT.ID | user | N1, N2 |
|action| STUDENT.ID | UPDATE | N1 N2 |
|username| U_STUDENTSUSERFIELDS.EMAILMOTHER\|EMAILFATHER | _bar@ash.nl_ |
|org_define_id| STUDENT.ID | _P\_123456_ |
|first_name| STUDENT.ID | _Jane_ |
|last_name| STUDENT.ID |_Doe_ | 
|password| STUDENT.ID | '' | N1 N2 |
|email| U_STUDENTSUSERFIELDS.EMAILMOTHER\|EMAILFATHER | _bar@ash.nl_ |
|role_name| STUDENT.ID | _Learner_ | N1 N2 |
|relationships| STUDENT.ID | '' | N1 N2 |
|pref_frist_name| STUDENT.ID |'' | N1 N2 |
|pref_last_name| STUDENT.ID |'' | N1 N2 |

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**N2:** Acording to the spec, this should be `GUARDIAN.GUARDIANID` or `GUARDIAN.FIRSTNAME`, however this causes a filter error when running the plugin. To avoid this error, use `STUDENT.ID` instead. This should not affect the performance of the plugin.  This is because: REASONS `¯\_(ツ)_/¯`.

**Tables Used**

| Table |
|-|
|GUARDIANSTUDENT |
|GUARDIAN |
|U_STUDENTSUSERFIELDS |
|STUDENTS STUDENTS |

**SQL Query Notes**

Both mother and father query depend on u_studentuserfields.mother|father_firstname be exactly equal to guardian.firstname. u_studentuserfields is populated partially by the division office and partially by the admissions office. `¯\_(ツ)_/¯`

This can be remedeid by moving to the contacts feature in PowerSchool SIS.

## 7 Users Parents Active

There are two separate Named Queries (NQ) for parents, one for mother and one for father. These are listed as m_active and f_active respectively. These could potentially be combined in the future.

### Fields Provided & Used

**PROVIDES FIELDS:**

- `org_defined_id` used in [7-Users_Students_Active](#7usersstudentsactive) in `relationships` field as `Id` 

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `P_`_`GUARDIAN.GUARDIANID`_ | P_1234567

**USES FIELDS:**

- none

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.users.07m_active|07f_active`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|username|
|org_define_id|
|first_name|
|last_name|
|password|
|role_name|
|relationships|
|pref_first_name |
|pref_last_name |

**Export Summary and Output Options**

**NOTE:** Parents file must be processed before student files so relationships can be properly built. Prepend 002 (mother) and 003 (father) to parents CSV filename to ensure this. Students have 200 prepended.

- *Export File Name:* 
  - `7-Users_002_mother_active-%d.csv`
  - `7-Users_003_father_active-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`

### Query Setup for `named_queries.xml`

- File: `07_u_m_active.named_queries.xml`
- File: `07_u_f_active.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| STUDENT.ID | user | N1, N2 |
|action| STUDENT.ID | UPDATE | N1 N2 |
|username| U_STUDENTSUSERFIELDS.EMAILMOTHER\|EMAILFATHER | _bar@ash.nl_ |
|org_define_id| STUDENT.ID | _P\_123456_ |
|first_name| STUDENT.ID | _Jane_ |
|last_name| STUDENT.ID |_Doe_ | 
|password| STUDENT.ID | '' | N1 N2 |
|email| U_STUDENTSUSERFIELDS.EMAILMOTHER\|EMAILFATHER | _bar@ash.nl_ |
|role_name| STUDENT.ID | _Learner_ | N1 N2 |
|relationships| STUDENT.ID | '' | N1 N2 |
|pref_frist_name| STUDENT.ID |'' | N1 N2 |
|pref_last_name| STUDENT.ID |'' | N1 N2 |

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**N2:** Acording to the spec, this should be `GUARDIAN.GUARDIANID` or `GUARDIAN.FIRSTNAME`, however this causes a filter error when running the plugin. To avoid this error, use `STUDENT.ID` instead. This should not affect the performance of the plugin.  This is because: REASONS `¯\_(ツ)_/¯`.

**Tables Used**

| Table |
|-|
|GUARDIANSTUDENT |
|GUARDIAN |
|U_STUDENTSUSERFIELDS |
|STUDENTS STUDENTS |

**SQL Query Samples**

Both mother and father query depend on u_studentuserfields.mother_firstanme|father_firstname be exactly equal to guardian.firstname. u_studentuserfields is populated via an e-collect form by parents. It is unclear how the guardian fields are populated, so this may break in the future. `¯\_(ツ)_/¯` May the force be with you, future maintainer.

Remember to update the mother and father Named Query files if any changes are made.

**FATHER**
```SQL
select distinct
    'user' as "type",
    'UPDATE' as "action",
    trim(U_STUDENTSUSERFIELDS.EMAILFATHER) as "username",
    'P_'||GUARDIAN.GUARDIANID as "org_defined_id",
    GUARDIAN.FIRSTNAME as "first_name",
    GUARDIAN.LASTNAME as "last_name",
    '' as "password",
    1 as "is_active",
    'Parent' as "role_name",
    trim(U_STUDENTSUSERFIELDS.EMAILFATHER) as "email",
    '' as "relationships",
    '' as "pref_first_name",
    '' as "pref_last_name"
from GUARDIANSTUDENT GUARDIANSTUDENT,
    GUARDIAN GUARDIAN,
    U_STUDENTSUSERFIELDS U_STUDENTSUSERFIELDS,
    STUDENTS STUDENTS 
where U_STUDENTSUSERFIELDS.STUDENTSDCID=STUDENTS.DCID
    and GUARDIAN.GUARDIANID=GUARDIANSTUDENT.GUARDIANID
    and STUDENTS.DCID=GUARDIANSTUDENT.STUDENTSDCID
    /* this requires that the names in guardian and u_studentuserfields 
    match exactly. We're not entirely sure how the guardian fields come to be populated
    so the sanity and sustainability of this is questionable 
    */
    and trim(guardian.firstname)=trim(u_studentsuserfields.father_firstname)
    -- and trim(guardian.lastname)=trim(u_studentsuserfields.father_lastname)
    and LENGTH(U_STUDENTSUSERFIELDS.EMAILFATHER) >0
    and STUDENTS.ENROLL_STATUS =0
    and students.grade_level >=5
order by "org_defined_id" asc
```

**MOTHER**
```SQL
select distinct
    'user' as "type",
    'UPDATE' as "action",
    trim(U_STUDENTSUSERFIELDS.EMAILMOTHER) as "username",
    'P_'||GUARDIAN.GUARDIANID as "org_defined_id",
    GUARDIAN.FIRSTNAME as "first_name",
    GUARDIAN.LASTNAME as "last_name",
    '' as "password",
    1 as "is_active",
    'Parent' as "role_name",
    trim(U_STUDENTSUSERFIELDS.EMAILMOTHER) as "email",
    '' as "relationships",
    '' as "pref_first_name",
    '' as "pref_last_name"
from GUARDIANSTUDENT GUARDIANSTUDENT,
    GUARDIAN GUARDIAN,
    U_STUDENTSUSERFIELDS U_STUDENTSUSERFIELDS,
    STUDENTS STUDENTS 
where U_STUDENTSUSERFIELDS.STUDENTSDCID=STUDENTS.DCID
    and GUARDIAN.GUARDIANID=GUARDIANSTUDENT.GUARDIANID
    and STUDENTS.DCID=GUARDIANSTUDENT.STUDENTSDCID
    /* this requires that the names in guardian and u_studentuserfields 
    match exactly. We're not entirely sure how the guardian fields come to be populated
    so the sanity and sustainability of this is questionable 
    */
    and trim(guardian.firstname)=trim(u_studentsuserfields.mother_firstname)
    -- and trim(guardian.lastname)=trim(u_studentsuserfields.mother_lastname)
    and LENGTH(U_STUDENTSUSERFIELDS.EMAILMOTHER) >0
    and STUDENTS.ENROLL_STATUS =0
    and students.grade_level >=5
order by "org_defined_id" asc
```

## 7 Users Teachers Inactive

Disable and delete accounts for teachers that are no longer active.

### Fields Provided & Used

**PROVIDES FIELDS:**

- `org_defined_id` used in [08-Enrollments Students](#8-enrollmentsstudents) as `child_code`
- `org_defined_id` used in [08-Enrollments Teachers](#8-enrollmentsteachers) as `child_code`

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `T_`_`USERS.TEACHERNUMBER`_ | T_123456

**USES FIELDS:**

- none

### Data Export Manager Setup

- **Category:** Show All
- **Export Form:**  `NQ com.txoof.brightspace.users.07t_inactive`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|username|
|org_define_id|
|first_name|
|last_name|
|password|
|role_name|
|relationships|
|pref_frist_name |
|fref_last_name |

**Export Summary and Output Options**

- *Export File Name:* `7-Users_100_teachers_inactive-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- File: 07_u_t_inactive.named_queries.xml

| header | table.field | value | NOTE |
|-|-|-|-|
|type| TEACHERS.TEACHERNUMBER | user | N1 |
|action| TEACHERS.TEACHERNUMBER | UPDATE | N1 |
|username| TEACHERS.EMAIL_ADDR |_foo@ash.nl_ |
|org_define_id| TEACHERS.TEACHERNUMBER | _T\_234_ |
|first_name|TEACHERS.FIRST_NAME | _John_ |
|last_name| TEACHERS.LAST_NAME |_Doe_ | 
|password| TEACHERS.TEACHERNUMBER | '' | N1 |
|role_name| TEACHERS.TEACHERNUMBER | _Instructor_ | N1 |
|relationships| TEACHERS.TEACHERNUMBER | TBD | N1 |
|pref_frist_name| TEACHERS.TEACHERNUMBER |TBD | N1 |
|pref_last_name| TEACHERS.TEACHERNUMBER |TBD | N1 |


**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|TEACHERS|
|LOGINS|

## 7 Users Teachers Active

All active staff staff added to ORG (6066) as "Instructor"

### Fields Provided & Used

- `org_defined_id` used in [08-Enrollments Students](#8-enrollmentsstudents) as `child_code`
- `org_defined_id` used in [08-Enrollments Teachers](#8-enrollmentsteachers) as `child_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export Form:**  `NQ com.txoof.brightspace.users.07t_active`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|username|
|org_define_id|
|first_name|
|last_name|
|password|
|role_name|
|relationships|
|pref_first_name |
|pref_last_name |

**Export Summary and Output Options**

- *Export File Name:* `7-Users_101_teachers_active-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- File: `07_u_t_active.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| TEACHERS.ID | user | N1 |
|action| TEACHERS.ID | UPDATE | N1 |
|username| TEACHERS.EMAIL_ADDR |_foo@ash.nl_ |
|org_define_id| TEACHERS.ID | _T\_234_ |
|first_name| TEACHERS.FIRST_NAME | _John_ |
|last_name| TEACHERS.LAST_NAME |_Doe_ | 
|password| TEACHERS.ID | '' | N1 |
|role_name| TEACHERS.ID | _Instructor_ | N1 |
|relationships| TEACHERS.ID | TBD | N1 |
|pref_frist_name| TEACHERS.ID |TBD | N1 |
|pref_last_name| TEACHERS.ID |TBD | N1 |

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|USERS|
|schoolstaff|


## 7 Users Students Inactive

Disable and delete accounts for departed students.

### Fields Provided & Used

- `org_defined_id` used in [08-Enrollments_Students](../BS_08_Enrollments_Students/8-Enrollments_students_README.md) as `child_code` 

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `S_`_`STUDENTS.STUDENT_NUMBER`_ | S_123456

**USES FIELDS:**

- none: relationships are not built for inactive students

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.users.07s_inactive`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|username|
|org_define_id|
|first_name|
|last_name|
|password|
|role_name|
|relationships|
|pref_frist_name |
|fref_last_name |

**Export Summary and Output Options**

- *Export File Name:* `7-Users_200_students_inactive-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- File: `07_u_s_inactive.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| STUDENTS.ID | user | N1 |
|action| STUDENTS.EXITDATE | _UPDATE_\|_DELETE_
|username| U_STUDENTSUSERFIELDS.EMAILSTUDENT | _bar@ash.nl_ |
|org_define_id| STUDENTS.STUDENT_NUMBER | _S\_123456_ |
|first_name| STUDENTS.FIRST_NAME | _Jane_ |
|last_name| STUDENTS.LAST_NAME |_Doe_ |
|password| STUDENTS.ID | '' | N1 |
|role_name| STUDENTS.ID | _Learner_ | N1 |
|relationships| STUDENTS.ID | TBD | N1 |
|pref_frist_name| STUDENTS.ID |TBD | N1 |
|pref_last_name| STUDENTS.ID |TBD | N1 |

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS| |
|U_STUDENTSUSERFIELDS|

## 7 Users Students Active

This query includes all active students with Parent and Auditor relationships.

### Fields Provided & Used

**PROVIDES FIELDS:**

- `org_defined_id` used in [08-Enrollments_Students](#8-enrollments_students) as `child_code` 

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `S_`_`STUDENTS.STUDENT_NUMBER`_ | S_123456

**USES FIELDS:**

- `org_definied_id` as `Id` in `relationships` field from [07-Users_Parents_Active](#7-usersparentsactive) for parents
- `org_defined_id` as `Id` in `relationships` field from [07-Users_Teachers_Active](#7-users-teachers-active) for auditors

|Field |Format |example |
|:-|:-|:-|
|`relationships`| `Parent: org_defined_id|Auditor: org_defined_id` | Parent:P_234123|Auditor:T_93313

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.users.07s_active`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|username|
|org_define_id|
|first_name|
|last_name|
|password|
|role_name|
|relationships|
|pref_first_name |
|pref_last_name |

**Export Summary and Output Options**

- *Export File Name:* `7-Users_201_students_active.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`

### Query Setup for `named_queries.xml`

- File: `07_u_s_active.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| STUDENTS.ID | user | N1 |
|action| STUDENTS.ID | UPDATE | N1 |
|username| U_STUDENTSUSERFIELDS.EMAILSTUDENT | _bar@ash.nl_ |
|org_define_id| STUDENTS.STUDENT_NUMBER | _S\_123456_ |
|first_name| STUDENTS.FIRST_NAME | _Jane_ |
|last_name| STUDENTS.LAST_NAME |_Doe_ | 
|password| STUDENTS.ID | '' | N1 |
|role_name| STUDENTS.ID | _Learner_ | N1 |
|relationships| STUDENTS.ID | _Parent:P\_12233\Auditor:T\_12345_ | N1 |
|pref_frist_name| STUDENTS.ID | '' | N1 |
|pref_last_name| STUDENTS.ID | '' | N1 |

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|U_STUDENTSUSERFIELDS|
|GuardianStudent|
|Guardian|
|Courses|
|Teachers|

**SQL Query**

**ONLY AUDITORS RELATIONSHIP**

```SQL
/*
07_u_s_active.named_queries.xml

update/create accounts for all active students
*/
SELECT
    'user' as "type",
    'UPDATE' as "action",
    U_StudentsUserFields.EmailStudent AS "username",
    'S_'||students.student_number as "org_defined_id",
    students.first_name as "first_name",
    students.last_name as "last_name",
    '' as "password",
    1 as "is_active",
    'Learner' as "role_name",
    u_studentsuserfields.emailstudent as "email",
    CASE
        WHEN Auditors.Auditors IS NOT NULL AND Parents.Parents IS NOT NULL
        THEN Auditors.Auditors || ''
        ELSE Auditors.Auditors
    END AS "relationship",
    '' as "pref_first_name",
    '' as "pref_last_name"
FROM
    Students
    JOIN U_StudentsUserFields ON Students.DCID = U_StudentsUserFields.StudentsDCID
    LEFT JOIN (
        SELECT
            Helper.StudentID,
            LISTAGG('Auditor'||CHR(58)||'T_'||Helper.TeacherNumber,'|')
                WITHIN GROUP (ORDER BY Helper.TeacherNumber DESC) AS Auditors
        FROM ( /* Oracle 12c method to deduplicate the LISTAGG */
            SELECT DISTINCT
                CC.StudentID,
                Teachers.TeacherNumber
            FROM
                CC
                JOIN Courses ON CC.Course_Number = Courses.Course_Number
                JOIN Teachers ON CC.TeacherID = Teachers.ID
            WHERE
                (
                    Courses.Course_Name LIKE 'ENG English Foundations%'
                    OR Courses.Course_name LIKE 'Grade%English Essentials%'
                    OR CC.Course_Number = 'OLEA'
                    OR Courses.Sched_Department IN ('MSEAL','MSLSC')
                )
                    and CC.TERMID >= case 
                        when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 6)
                        THEN (EXTRACT(year from sysdate)-2000+9)*100
                        when (EXTRACT(month from sysdate) >= 7 and EXTRACT(month from sysdate) <= 12)
                        THEN (EXTRACT(year from sysdate)-2000+10)*100
                    end
        ) Helper
        GROUP BY
            Helper.StudentID
    ) Auditors ON Students.ID = Auditors.StudentID
    LEFT JOIN ( /* I didn't deduplicate here because there shouldn't be duplicate
        parent accounts, but you could use that same approach here if needed. */
        SELECT
            GuardianStudent.StudentsDCID,
            LISTAGG('Parent' || CHR(58) || 'P_' )
                WITHIN GROUP (ORDER BY Guardian.LastName DESC) AS Parents
        FROM
            Guardian Guardian
            JOIN GuardianStudent USING(GuardianID)
        GROUP BY
            GuardianStudent.StudentsDCID
    ) Parents ON Students.DCID = Parents.StudentsDCID
WHERE
    Students.Enroll_Status = 0
    AND Students.Grade_Level >= 5
    AND U_StudentsUserFields.EmailStudent IS NOT NULL
ORDER BY
    U_StudentsUserFields.EmailStudent
```

**WITH PARENTS & AUDIORS RELATIONSHIP**
```SQL
/*
based entirely on solution provided by Vance M. Allen
https://support.powerschool.com/thread/23796?94834
*/
SELECT
    'user' as "type",
    'UPDATE' as "action",
    U_StudentsUserFields.EmailStudent AS "username",
    'S_'||students.student_number as "org_defined_id",
    students.first_name as "first_name",
    students.last_name as "last_name",
    '' as "password",
    1 as "is_active",
    'Learner' as "role_name",
    u_studentsuserfields.emailstudent as "email",
    CASE
        WHEN Auditors.Auditors IS NOT NULL AND Parents.Parents IS NOT NULL
        THEN Auditors.Auditors || '|' || Parents.Parents
        ELSE COALESCE(Auditors.Auditors,Parents.Parents)
    END AS "relationship",
    '' as "pref_first_name",
    '' as "pref_last_name"
FROM
    Students
    JOIN U_StudentsUserFields ON Students.DCID = U_StudentsUserFields.StudentsDCID
    LEFT JOIN (
        SELECT
            Helper.StudentID,
            LISTAGG('Auditor'||CHR(58)||'T_'||Helper.TeacherNumber,'|')
                WITHIN GROUP (ORDER BY Helper.TeacherNumber DESC) AS Auditors
        FROM ( /* Oracle 12c method to deduplicate the LISTAGG */
            SELECT DISTINCT
                CC.StudentID,
                Teachers.TeacherNumber
            FROM
                CC
                JOIN Courses ON CC.Course_Number = Courses.Course_Number
                JOIN Teachers ON CC.TeacherID = Teachers.ID
            WHERE
                (
                    Courses.Course_Name LIKE 'ENG English Foundations%'
                    OR Courses.Course_name LIKE 'Grade%English Essentials%'
                    OR CC.Course_Number = 'OLEA'
                    OR Courses.Sched_Department IN ('MSEAL','MSLSC')
                )
                     and CC.TERMID >= case 
                        when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 6)
                        THEN (EXTRACT(year from sysdate)-2000+9)*100
                        when (EXTRACT(month from sysdate) >= 7 and EXTRACT(month from sysdate) <= 12)
                        THEN (EXTRACT(year from sysdate)-2000+10)*100
                     end
        ) Helper
        GROUP BY
            Helper.StudentID
    ) Auditors ON Students.ID = Auditors.StudentID
    LEFT JOIN ( /* I didn't deduplicate here because there shouldn't be duplicate
        parent accounts, but you could use that same approach here if needed. */
        SELECT
            GuardianStudent.StudentsDCID,
            LISTAGG('Parent' || CHR(58) || 'P_' || GuardianID,'|')
                WITHIN GROUP (ORDER BY Guardian.LastName DESC) AS Parents
        FROM
            Guardian
            JOIN GuardianStudent USING(GuardianID)
        GROUP BY
            GuardianStudent.StudentsDCID
    ) Parents ON Students.DCID = Parents.StudentsDCID
WHERE
    Students.Enroll_Status = 0
    AND Students.Grade_Level >= 5
    AND U_StudentsUserFields.EmailStudent IS NOT NULL
    /* Only pull students that have some kind of relationship */
    AND COALESCE(Auditors.Auditors,Parents.Parents) IS NOT NULL
ORDER BY
    U_StudentsUserFields.EmailStudent
```

## 8 Enrollments Teachers

Add all teachers to scheduled classes. Class enrolment needs to happen last after all other role-based enrollments.

### Fields Provided & Used

**PROVIDES FIELDS:**

None

**USES FIELDS:**

- `org_defined_id` from [07-Users_Teachers_Active](#7-usersteachersactive) as `child_code`
- `code` from [06-Sections](../BS_Organization/README_Organization.md/#6-sections) as `parent_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.enroll.08_teacher`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

**Export Summary and Output Options**

- *Export File Name:* `8-Enrollments_100_teachers-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- File: `08_e_t.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| TEACHERS.ID | _enrollment_ | N1
|action| TEACHERS.ID | _UPDATE_ | N1
|child_code| _'T'\_TEACHERS.TEACHERNUMBER_ | _T\_765_
|role_name| CC.ID | _Instructor_ | N1
|parent_code| _'cs'\_schoolid\_coursenumber\_termid\_block\_sectionid_ | _cs\_3\_ITLDROB\_3101\_C\_12345_

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|SECTIONTEACHER|
|COURSES|
|CC|
|TEACHERS|

## 8 Enrollments Teachers - School Level

Enrols staff at the school level matching their powerschool schoolid value. All staff are added to at least one school as an instructor. This allows creating [Intelligent Agents](https://documentation.brightspace.com/EN/le/intelligent_agents/instructor/create_agent.htm?Highlight=intelligent%20agents) that can be used for auto-enroling teachers into courses such as HS and MS Library.

This needs to be run prior to the individual course enrollments

### Fields Provided & Used

**PROVIDES FIELDS:**

- `child_code` used in ?? as `??` 

|Field |Format |example |
|:-|:-|:-|
|`child_code`| `teachers.homeschoolid` | 2

**USES FIELDS:**

- `org_defined_id` from [07-Users_Students_Active](#7-users-students-active) as `child_code`
- `code` from [BS_Organization/01-Other](../BS_Organization/README_Organization.md/#1-other)

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.enroll.08_teacher_school`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

**Export Summary and Output Options**

- *Export File Name:* `8-Enrollments_101_teachers_school-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- File: `08_e_t_school.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| TEACHERS.ID | _enrollment_ | N1
|action| TEACHERS.ID | _UPDATE_ | N1
|child_code| TEACHERS.TEACHERNUMBER | _T\_765_
|role_name| TEACHERS.ID | _Instructor_ | N1
|parent_code| TEACHERS.HOMESCHOOLID | _2_ 

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|users|
|schoostaff|

## 8 Enrollments Students Active

### Fields Provided & Used

**PROVIDES FIELDS:**

None

**USES FIELDS:**

- `org_defined_id` from [07-Users - Students](../BS_07_Users_Students/README.md) as `child_code`
- `code` from [06-Sections](../BS_06_Offerings/README.md) as `parent_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.enroll.08_students`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

**Export Summary and Output Options**

- *Export File Name:* `8-Enrollments_205_students-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* `False`

### Query Setup for `named_queries.xml`

- Files: `08_e_s.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| CC.ID | _enrollment_ | N1
|action| CC.ID | _UPDATE_ | N1
|child_code| _'S'\_STUDENT\_NUMBER_ | _S\_506113_
|role_name| CC.ID | _Learner_ | N1
|parent_code| _'cs'\_schoolid\_coursenumber\_termid\_block\_sectionid_ | _cs\_3\_ITLDROB\_3101\_C\_12345_ 

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|COURSES|
|CC|
|SECTIONS|

## 8 Enrollments Students - School Level

Enrols students at the school level matching their powerschool schoolid value. All students are added to at least one school as a learner. This allows creating [Intelligent Agents](https://documentation.brightspace.com/EN/le/intelligent_agents/instructor/create_agent.htm?Highlight=intelligent%20agents) that can be used for auto-enroling students into courses such as HS and MS Library.

<!-- This should to be run prior to the individual course enrollments.  -->

### Fields Provided & Used

**USES FIELDS:**

- `org_defined_id` from [07-Users_Students_Active](#7-users-students-active) as `child_code`
- `code` from [BS_Organization/01-Other](../BS_Organization/README_Organization.md/#1-other)

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.enroll.08_student_school`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

**Export Summary and Output Options**

- *Export File Name:* `8-Enrollments_201_students_school-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`

### Query Setup for `named_queries.xml`

- File: `08_e_t_school.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| STUDENTS.ID | _enrollment_ | N1
|action| STUDENTS.ID | _UPDATE_ | N1
|child_code| STUDENTS.STUDENT_NUMBER | _S\_123567_
|role_name| STUDENTS.ID | _Learner_ | N1
|parent_code| STUDENTS.HOMESCHOOLID | _2_ 

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|SECTIONS|
|COURSES|
|CC|
|STUDENTS|


## 8 Enrollments Students Active - Dropped Classes

Remove students from classes that are dropped in the SIS. This must be run **FIRST**, prior to the other student enrolments. This is to protect against this pattern:
1. Student is added to ABC_123
2. Student is dropped from ABC_123
3. Student is added to XYZ_789
4. Student is dropped from XYZ_789
5. Student is added to ABC_123 *← Final Result*

If the drops are run last, the end result will be that the enrolment from step *5* will be clobbered by the drop in step *2*. The student will be missing from ABC_123 though the should be enroled.

### Fields Provided & Used

**PROVIDES FIELDS:**

- `child_code` used in ?? as `??` 

|Field |Format |example |
|:-|:-|:-|
|`child_code`| `'cs_'\|\|cc.schoolid\|\|'_'\|\|cc.course_number\|\|'_'\|\|cc.TermID` | cs_2_C5A_3100

**USES FIELDS:**

- `org_defined_id` from [07-Users - Students](../BS_07_Users_Students/README.md) as `child_code`
- `code` from [06-Sections](../BS_06_Offerings/README.md) as `parent_code`
- ALTERNATIVE: `code` from [05-Offerings](../BS_05_Offerings/README.md) as `parent_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.enroll.08_stud_drop`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

**Export Summary and Output Options**

- *Export File Name:* `8-Enrollments_200_students_dropped-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- Files: `08_e_s_drop.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|-|-|-|-|
|type| CC.ID | _enrollment_ | N1
|action| CC.ID | _UPDATE_ | N1
|child_code| `S_`_`STUDENTS.STUDENT_NUMBER`_ | _S\_506113_
|role_name| CC.ID | _Learner_ | N1
|parent_code| _'cs'\_schoolid\_coursenumber\_termid\_block\_sectionid_ | _cs\_3\_ITLDROB\_3101\_C\_12345_ 

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|COURSES|
|CC|
|SECTIONS|

## 8 Enrollments Parents in Student Classes

Enrol parents in classes as view-only members of their children's classes.

### Fields Provided & Used

**PROVIDES FIELDS:**

- `child_code` used in ?? as `??` 

|Field |Format |example |
|:-|:-|:-|
|`child_code`| `'cs_'\|\|cc.schoolid\|\|'_'\|\|cc.course_number\|\|'_'\|\|cc.TermID` | cs_2_C5A_3100

**USES FIELDS:**

- `org_defined_id` from [07-Users - Students](../BS_07_Users_Students/README.md) as `child_code`
- `code` from [06-Sections](../BS_06_Offerings/README.md) as `parent_code`
- ALTERNATIVE: `code` from [05-Offerings](../BS_05_Offerings/README.md) as `parent_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.enroll.08_parents`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

**Export Summary and Output Options**

- *Export File Name:* `8-Enrollments_301_parent_auditors-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- Files: `08_e_p.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|-|-|-|-|
|type| CC.ID | _enrollment_ | N1
|action| CC.ID | _UPDATE_ | N1
|child_code| `S_`_`GUARDIAN.GUARDIANID`_ | _S\_506113_
|role_name| CC.ID | _Parent-Auditor_ | N1
|parent_code| _'cs'\_schoolid\_coursenumber\_termid\_block\_sectionid_ | _cs\_3\_ITLDROB\_3101\_C\_12345_ 

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|GUARDIAN|
|COURSES|
|CC|
|SECTIONS|

## 8 Enrollments Parents in Student Classes - Drop

Remove parents from student classes that are dropped in the SIS. This must be run **FIRST**, prior to the other student enrolments. This is to protect against this pattern:
1. Student is added to ABC_123
2. Student is dropped from ABC_123
3. Student is added to XYZ_789
4. Student is dropped from XYZ_789
5. Student is added to ABC_123 *← Final Result*

If the drops are run last, the end result will be that the enrolment from step *5* will be clobbered by the drop in step *2*. The student will be missing from ABC_123 though the should be enroled.

### Fields Provided & Used

**PROVIDES FIELDS:**

- `child_code` used in ?? as `??` 

|Field |Format |example |
|:-|:-|:-|
|`child_code`| `'cs_'\|\|cc.schoolid\|\|'_'\|\|cc.course_number\|\|'_'\|\|cc.TermID` | cs_2_C5A_3100

**USES FIELDS:**

- `org_defined_id` from [07-Users - Students](../BS_07_Users_Students/README.md) as `child_code`
- `code` from [06-Sections](../BS_06_Offerings/README.md) as `parent_code`
- ALTERNATIVE: `code` from [05-Offerings](../BS_05_Offerings/README.md) as `parent_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.enroll.08_parents_drop`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

**Export Summary and Output Options**

- *Export File Name:* `8-Enrollments_300_parent_auditors_drops-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- Files: `08_e_p_drop.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|-|-|-|-|
|type| CC.ID | _enrollment_ | N1
|action| CC.ID | _UPDATE_ | N1
|child_code| `S_`_`GUARDIAN.GUARDIANID`_ | _P\_506113_
|role_name| CC.ID | _Parent-Auditor_ | N1
|parent_code| _'cs'\_schoolid\_coursenumber\_termid\_block\_sectionid_ | _cs\_3\_ITLDROB\_3101\_C\_12345_ 

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|GUARDIAN|
|COURSES|
|CC|
|SECTIONS|
|GUARDIANSTUDENT|

## 8 Enrollments Students Athletics

### Fields Provided & Used

**PROVIDES FIELDS:**

- `child_code` used in ?? as `??` 

|Field |Format |example |
|:-|:-|:-|
|`child_code`| `'cs_'\|\|cc.schoolid\|\|'_'\|\|cc.course_number\|\|'_'\|\|cc.TermID` | cs_2_C5A_3100

**USES FIELDS:**

- `org_defined_id` from [07-Users - Students](../BS_07_Users_Students/README.md) as `child_code`
- `code` from [06-Sections](../BS_06_Offerings/README.md) as `parent_code`
- ALTERNATIVE: `code` from [05-Offerings](../BS_05_Offerings/README.md) as `parent_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.enroll.08_s_athl`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

**Export Summary and Output Options**

- *Export File Name:* `8-Enrollments_202_students_athletics-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- Files: `08_e_s_athl.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|-|-|-|-|
|type| STUDENTS.ID | _enrollment_ | N1
|action| STUDENTS.ID | _UPDATE_ | N1
|child_code| `S_`_`STUDENTS.STUDENT_NUMBER`_ | _S\_506113_
|role_name| STUDENTS.ID | _Learner_ | N1
|parent_code| _`co_athl`\_`GEN.NAME`_ | _co\_ath\_Athletics - Baseball - MS_

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|COURSES|
|CC|
|SECTIONS|

## 8 Enrollments Parents Athletics

Enrol parents in all athletics classes using the read-only parent role

### Fields Provided & Used

**PROVIDES FIELDS:**

- `child_code` used in ?? as `??` 

|Field |Format |example |
|:-|:-|:-|
|`child_code`| `'cs_'\|\|cc.schoolid\|\|'_'\|\|cc.course_number\|\|'_'\|\|cc.TermID` | cs_2_C5A_3100

**USES FIELDS:**

- `org_defined_id` from [07-Users - Students](../BS_07_Users_Students/README.md) as `child_code`
- `code` from [06-Sections](../BS_06_Offerings/README.md) as `parent_code`
- ALTERNATIVE: `code` from [05-Offerings](../BS_05_Offerings/README.md) as `parent_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.enroll.08_parents_athl`

**Labels Used on Export**

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

**Export Summary and Output Options**

- *Export File Name:* `8-Enrollments_302_parents_athletics-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- Files: `08_e_p_athl.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|-|-|-|-|
|type| STUDENTS.ID | _enrollment_ | N1
|action| STUDENTS.ID | _UPDATE_ | N1
|child_code| `P_`_`GUARDIAN.GUARDIANID`_ | _P\_506113_
|role_name| STUDENTS.ID | _Learner_ | N1
|parent_code| _`co_athl`\_`GEN.NAME`_ | _co\_ath\_Athletics - Baseball - MS_

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|GEN|
|GUARDIAN|
|GUARDIANSTUDENT|