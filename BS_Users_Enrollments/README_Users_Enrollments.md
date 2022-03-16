# BrightSpace D2L User and Enrollments (7-8)

PowerQuery Plugin for exporting the following information from PowerSchool &rarr; BrightSpace. This plugin creates the following exports:

- [7-Users_Parents_Inactive](#7-usersparentsinactive)
- [7-Users_Parents_Active](#7-usersparentsactive)
- [7-Users_Teachers_Inactive](#7-usersteachersinactive)
- [7-Users_Teachers_Active](#7-usersteachersactive)
- [7-Users_Students_Inactive](#7usersstudentsinactive)
- [7-Users_Students_Active](#7usersstudentsactive)
- [8-Enrollments_Teachers](#8-enrollmentsteachers)
- [8-Enrollments_Students](#8-enrollmentsstudents)

## 7-Users_Parents_Inactive

There are two separate Named Queries (NQ) for parents, one for mother and one for father.

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

- *Export File Name:* `7-Users_000_mother_inactive-%d.csv` & `7-Users_001_father_inactive-%d.csv`
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
**SQL Query**

Both mother and father query depend on u_studentuserfields.mother|father_firstname be exactly equal to guardian.firstname. u_studentuserfields is populated via an e-collect form by parents. It is unclear how the guardian fields are populated, so this may break in the future. `¯\_(ツ)_/¯`

```SQL
select distinct
    'user' as "type",
    /* mark parents of students that have left in the past N days for deletion */
    case 
       WHEN (trunc(sysdate) - STUDENTS.EXITDATE) >=90
           THEN 'DELETE'
       ELSE 
           'UPDATE'
       END "action",    
    trim(U_STUDENTSUSERFIELDS.EMAILMOTHER) as "username",
    'P_'||GUARDIAN.GUARDIANID as "org_defined_id",
    GUARDIAN.FIRSTNAME as "first_name",
    GUARDIAN.LASTNAME as "last_name",
    '' as "password",
    /* Mark students that are not "active" in powerschool (PS !=0) as inactive (BS=0) */
    (CASE STUDENTS.ENROLL_STATUS
        WHEN 0 THEN 1
        ELSE 0 END) as "is_active",    'Parent' as "role_name",
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
    so the sustainability and sustainability of this is questionable 
    */
    and trim(guardian.firstname)=trim(u_studentsuserfields.mother_firstname)
    and trim(guardian.lastname)=trim(u_studentsuserfields.mother_lastname)
    and trunc(sysdate) - STUDENTS.EXITDATE < 180 
    and trunc(sysdate) - STUDENTS.EXITDATE > 0    
    and STUDENTS.ENROLL_STATUS !=0
    and students.grade_level >=5
order by "org_defined_id" asc
```

## 7-Users_Parents_Active

There are two separate Named Queries (NQ) for parents, one for mother and one for father.


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

- *Export File Name:* `07-Users_002_mother_active-%d.csv` & `07-Users_003_fother_active-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

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

**SQL Query**

Both mother and father query depend on u_studentuserfields.mother_firstanme|father_firstname be exactly equal to guardian.firstname. u_studentuserfields is populated via an e-collect form by parents. It is unclear how the guardian fields are populated, so this may break in the future. `¯\_(ツ)_/¯`

Remember to update the mother and father Named Query files if any changes are made.

```SQL:
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
    so the sustainability and sustainability of this is questionable 
    */
    and trim(guardian.firstname)=trim(u_studentsuserfields.mother_firstname)
    and trim(guardian.lastname)=trim(u_studentsuserfields.mother_lastname)
    and LENGTH(U_STUDENTSUSERFIELDS.EMAILMOTHER) >0
    and STUDENTS.ENROLL_STATUS =0
    and students.grade_level >=5
order by "org_defined_id" asc
```

## 7-Users_Teachers_Inactive

### Fields Provided & Used

**PROVIDES FIELDS:**

- `org_defined_id` used in [08-Enrollments Students](#8-enrollmentsstudents) as `child_code`
- `org_defined_id` used in [08-Enrollments Teachers](#8-enrollmentsteachers) as `child_code`

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `T_`_`TEACHERS.ID`_ | T_123456

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
|type| TEACHERS.ID | user | N1 |
|action| TEACHERS.ID | UPDATE | N1 |
|username| TEACHERS.EMAIL_ADDR |_foo@ash.nl_ |
|org_define_id| TEACHERS.ID | _T\_234_ |
|first_name| TEACHERS.FIRST_NAME | _John_ |
|last_name| TEACHERS.LAST_NAME |_Doe_ | 
|password| TEACHERS.ID | '' | N1 |
|role_name| TEACHER.ID | _Learner_ | N1 |
|relationships| TEACHERS.ID | TBD | N1 |
|pref_frist_name| TEACHERS.ID |TBD | N1 |
|pref_last_name| TEACHERS.ID |TBD | N1 |


**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|U_STUDENTSUSERFIELDS|

**SQL Query**

Delete staff that are not "active" (STATUS != 1) 
```SQL
select distinct
    'user' as "type",
    'UPDATE' as "action",
    REGEXP_REPLACE(TEACHERS.EMAIL_ADDR, '(^.*)(@.*)', '\1') as "username",
    /* prepend a 'T' to make sure there are no studentid/teacherid colisions */
    'T_'||TEACHERS.ID as "org_defined_id",
    TEACHERS.FIRST_NAME as "first_name",
    TEACHERS.LAST_NAME as "last_name",
    '' as "password",
    0 as "is_active",
    'Instructor' as "role_name",
    TEACHERS.EMAIL_ADDR as "email",
    '' as "relationships",
    '' as "pref_first_name",
    '' as "pref_last_name"
 from 
     TEACHERS TEACHERS,
     LOGINS LOGINS
 where TEACHERS.HOMESCHOOLID = TEACHERS.SCHOOLID
    AND LOGINS.USERID=TEACHERS.ID
    /* Ignore all users with no email address */
    AND LENGTH(TEACHERS.EMAIL_ADDR) > 0
    AND TEACHERS.STATUS != 1
    /* deactivate anyone that is status !=1 and has not logged in in 5 months (150 days) */
    AND trunc(sysdate) - trunc(LOGINS.LOGINDATE) > 150
    ORDER BY "org_defined_id" asc
```

## 7-Users_Teachers_Active

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
|role_name| TEACHER.ID | _Learner_ | N1 |
|relationships| TEACHERS.ID | TBD | N1 |
|pref_frist_name| TEACHERS.ID |TBD | N1 |
|pref_last_name| TEACHERS.ID |TBD | N1 |

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|U_STUDENTSUSERFIELDS|

**SQL Query**

```SQL
select 
    'user' as "type",
    'UPDATE' as "action",
    REGEXP_REPLACE(TEACHERS.EMAIL_ADDR, '(^.*)(@.*)', '\1') as "username",
    /* prepend a 'T' to make sure there are no studentid/teacherid colissions */
    'T_'||TEACHERS.ID as "org_defined_id",
    TEACHERS.FIRST_NAME as "first_name",
    TEACHERS.LAST_NAME as "last_name",
    '' as "password",
    TEACHERS.STATUS as "is_active",
    'Instructor' as "role_name",
    TEACHERS.EMAIL_ADDR as "email",
    '' as "relationships",
    '' as "pref_first_name",
    '' as "pref_last_name"

 from TEACHERS TEACHERS
 where TEACHERS.HOMESCHOOLID = TEACHERS.SCHOOLID 
    AND TEACHERS.STATUS = 1 
    /* Ignore all users with no email address */
    AND LENGTH(TEACHERS.EMAIL_ADDR) > 0
    ORDER BY TEACHERS.LAST_NAME ASC
```

## 7_Users_Students_Inactive

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

**SQL Query**

```SQL
select 
    'user' as "type",
    /* mark students that have left in the past N days for deletion */
    case 
       WHEN (trunc(sysdate) - STUDENTS.EXITDATE) >=90
           THEN 'DELETE'
       ELSE 
           'UPDATE'
       END "action",
    REGEXP_REPLACE(U_STUDENTSUSERFIELDS.EMAILSTUDENT, '(^.*)(@.*)', '\1') as "username",
    /* use student number as unique id - we recycle email addresses and this causes issues */
    /* prepend a 'S" to the number to distinguish between students & teachers */
    'S_'||STUDENTS.STUDENT_NUMBER as "org_defined_id",
    STUDENTS.FIRST_NAME as "first_name",
    STUDENTS.LAST_NAME as "last_name",
    '' as "password",
    /* Mark students that are not "active" in powerschool (PS !=0) as inactive (BS=0) */
    (CASE STUDENTS.ENROLL_STATUS
        WHEN 0 THEN 1
        ELSE 0 END) as "is_active",
    'Learner' as "role_name",
    U_STUDENTSUSERFIELDS.EMAILSTUDENT as "email",
    '' as "relationships",
    '' as "pref_first_name",
    '' as "pref_last_name"
 from STUDENTS STUDENTS,
    U_STUDENTSUSERFIELDS U_STUDENTSUSERFIELDS
 where 
    STUDENTS.DCID=U_STUDENTSUSERFIELDS.STUDENTSDCID
    and STUDENTS.ENROLL_STATUS >=2
    and trunc(sysdate) - STUDENTS.EXITDATE < 180 
    and trunc(sysdate) - STUDENTS.EXITDATE > 0
    /* Only students grade 5 and up */
    and STUDENTS.GRADE_LEVEL >= 5
 order by STUDENTS.EXITDATE asc
```

## 7_Users_Students_Active

### Fields Provided & Used

**PROVIDES FIELDS:**

- `org_defined_id` used in [08-Enrollments_Students](#8-enrollments_students) as `child_code` 

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `S_`_`STUDENTS.STUDENT_NUMBER`_ | S_123456

**USES FIELDS:**

- `org_definied_id` as `Id` in `relationships` field from [07-Users_Parents_Active](#7-usersparentsactive)

|Field |Format |example |
|:-|:-|:-|
|`relationships`| `[{"type": "parent", "Id": "P_GUARDIAN.GUARDIANID"}]` | [{"type": "parent", "Id": "P_123456"}]

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

- *Export File Name:* `7-Users_201_Students_Active.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

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
|relationships| STUDENTS.ID | TBD | N1 |
|pref_frist_name| STUDENTS.ID |TBD | N1 |
|pref_last_name| STUDENTS.ID |TBD | N1 |

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|U_STUDENTSUSERFIELDS|
|GuardianStudent|
|Guardian|

**SQL Query**

```SQL
SELECT
    'user' as "type",
    'UPDATE' as "action",
    u_studentsuserfields.emailstudent as "username",
    'S_'||students.student_number as "org_defined_id",
    students.first_name as "first_name",
    students.last_name as "last_name",
    '' as "password",
    1 as "is_active",
    'Learner' as "role_name",
    u_studentsuserfields.emailstudent as "email",
    chr(91)||listagg('{"type"'||chr(58)||'"Parent", "Id"'||chr(58)||'"P_'||guardian.guardianid||'"}', ', ') WITHIN GROUP ( ORDER BY Guardian.LastName desc )||chr(93) as "relationship",
    '' as "pref_last_name",
    '' as "pref_first_name"
FROM 
Guardian Guardian

INNER JOIN 
GuardianStudent GuardianStudent 
ON 
Guardian.GuardianID = GuardianStudent.GuardianID

INNER JOIN 
Students Students 
ON 
GuardianStudent.studentsdcid = Students.dcid

INNER JOIN
U_STUDENTSUSERFIELDS U_STUDENTSUSERFIELDS
ON
U_STUDENTSUSERFIELDS.STUDENTSDCID = students.dcid

WHERE 
    Students.enroll_status = 0
    and students.grade_level >=5

GROUP BY students.student_number, students.first_name, students.last_name, u_studentsuserfields.emailstudent
ORDER BY "org_defined_id"
```

## 8-Enrollments_Teachers

### Fields Provided & Used

**PROVIDES FIELDS:**

- `child_code` used in ?? as `??` 

|Field |Format |example |
|:-|:-|:-|
|`child_code`| `'cs_'\|\|cc.schoolid\|\|'_'\|\|cc.course_number\|\|'_'\|\|cc.TermID` | cs_2_C5A_3100

**USES FIELDS:**

- `org_defined_id` from [07-Users_Teachers_Active](#7-usersteachersactive) as `child_code`
- `code` from [06-Sections](../BS_Organization/README_Organization.md/#6-sections) as `parent_code`
- ALTERNATIVE: `code` from [05-Offerings](../BS_Organization/README_Organization.md/#5-offerings) as `parent_code`

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

- *Export File Name:* `8-Enrollments_teachers-%d.csv`
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
|child_code| `T_`_`TEACHERS.ID`_ | _T\_765_
|role_name| CC.ID | _Instructor_ | N1
|parent_code| `cs_`_`cc.schoolid`_`_`_`cc.course_number`_`_`_`cc.termid`_ | _cs_2_E0DNS_3100_ 

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|COURSES|
|CC|
|SECTIONS|

**SQL Query**

```SQL
select distinct
    'enrollment' as "type",
    'UPDATE' as "action",
    'T_'||TEACHERS.ID as "child_code",
    'Instructor' as "role_name",
    'cs_'||CC.SCHOOLID||'_'||cc.COURSE_NUMBER||'_'||CC.TERMID||'_'||DECODE(substr(cc.expression, 1, 1), 
     1, 'A', 
     2, 'B', 
     3, 'C', 
     4, 'D', 
     5, 'E', 
     6, 'F', 
     7, 'G', 
     8, 'H', 
     9, 'ADV', 
     'UNKNOWN') as "parent_code"
 from CC CC,
    STUDENTS STUDENTS,
    TEACHERS TEACHERS 
 where CC.STUDENTID=STUDENTS.ID
    and CC.TEACHERID=TEACHERS.ID
    and STUDENTS.ENROLL_STATUS =0
    and TEACHERS.STATUS =1
    and cc.termid >= case 
      when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 7)
      THEN (EXTRACT(year from sysdate)-2000+9)*100
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN (EXTRACT(year from sysdate)-2000+10)*100
      end
order by "child_code" asc, "parent_code" asc
```

## 8-Enrollments_Students

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

- *Export File Name:* `08-Enrollments_students-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- Files: `08_e_s.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|-|-|-|-|
|type| CC.ID | _enrollment_ | N1
|action| CC.ID | _UPDATE_ | N1
|child_code| `S_`_`STUDENTS.STUDENT_NUMBER`_ | _S\_506113_
|role_name| CC.ID | _Learner_ | N1
|parent_code| `cs_`_`cc.schoolid`_`_`_`cc.course_number`_`_`_`cc.termid`_ | _cs_2_E0DNS_3100_ 

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|COURSES|
|CC|
|SECTIONS|

**SQL Query**

```SQL
select 
    'enrollment' as "type",
    'UPDATE' as "action",
    /* using 7-Users:org_defined_id as child_code */
    'S_'||STUDENTS.STUDENT_NUMBER as "child_code",
    /* REGEXP_REPLACE(U_STUDENTSUSERFIELDS.EMAILSTUDENT, '(^.*)(@.*)', '\1') as "child_code", */
    'Learner' as "role_name",
    /* using 6-Sections:code as parent_code */
    'cs_'||cc.schoolid||'_'||cc.course_number||'_'||cc.TermID||'_'||DECODE(substr(cc.expression, 1, 1), 
     1, 'A', 
     2, 'B', 
     3, 'C', 
     4, 'D', 
     5, 'E', 
     6, 'F', 
     7, 'G', 
     8, 'H', 
     9, 'ADV', 
     'UNKNOWN') as "parent_code"
 from 
    /* U_STUDENTSUSERFIELDS U_STUDENTSUSERFIELDS, */
    SECTIONS SECTIONS,
    COURSES COURSES,
    CC CC,
    STUDENTS STUDENTS 
 where CC.STUDENTID=STUDENTS.ID
    and COURSES.COURSE_NUMBER=CC.COURSE_NUMBER
    and SECTIONS.ID=CC.SECTIONID
    /* and U_STUDENTSUSERFIELDS.STUDENTSDCID=STUDENTS.DCID */ 
    and STUDENTS.ENROLL_STATUS =0
    and STUDENTS.GRADE_LEVEL >=5
    and CC.TERMID >= case 
      when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 7)
      THEN (EXTRACT(year from sysdate)-2000+9)*100
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN (EXTRACT(year from sysdate)-2000+10)*100
      end
 order by STUDENTS.GRADE_LEVEL ASC, STUDENTS.LASTFIRST ASC, SECTIONS.SECTION_NUMBER ASC
```


## template
### Fields Provided & Used



### Data Export Manager Setup

**Labels Used on Export**

| Label |
|-|


**Export Summary and Output Options**

- *Export File Name:* `.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`
| header | table.field | value | NOTE |
|-|-|-|-|


**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|

**SQL Query**

```SQL

```