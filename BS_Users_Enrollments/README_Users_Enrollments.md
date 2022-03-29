# BrightSpace D2L User and Enrollments (7-8)

PowerQuery Plugin for exporting the following information from PowerSchool &rarr; BrightSpace. This plugin creates the following exports:

- [BrightSpace D2L User and Enrollments (7-8)](#brightspace-d2l-user-and-enrollments-7-8)
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
  - [7 Users Teacher-Auditors Active](#7-users-teacher-auditors-active)
    - [Fields Provided & Used](#fields-provided--used-4)
    - [Data Export Manager Setup](#data-export-manager-setup-4)
    - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-4)
  - [7 Users Students Inactive](#7-users-students-inactive)
    - [Fields Provided & Used](#fields-provided--used-5)
    - [Data Export Manager Setup](#data-export-manager-setup-5)
    - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-5)
  - [7 Users Students Active](#7-users-students-active)
    - [Fields Provided & Used](#fields-provided--used-6)
    - [Data Export Manager Setup](#data-export-manager-setup-6)
    - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-6)
  - [7 Users Students Active w/ Auditors](#7-users-students-active-w-auditors)
    - [Fields Provided & Used](#fields-provided--used-7)
    - [Data Export Manager Setup](#data-export-manager-setup-7)
    - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-7)
  - [8 Enrollments Teachers](#8-enrollments-teachers)
    - [Fields Provided & Used](#fields-provided--used-8)
    - [Data Export Manager Setup](#data-export-manager-setup-8)
    - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-8)
  - [8 Enrollments Students](#8-enrollments-students)
    - [Fields Provided & Used](#fields-provided--used-9)
    - [Data Export Manager Setup](#data-export-manager-setup-9)
    - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-9)
  - [template](#template)
    - [Fields Provided & Used](#fields-provided--used-10)
    - [Data Export Manager Setup](#data-export-manager-setup-10)
    - [Query Setup for `named_queries.xml`](#query-setup-for-named_queriesxml-10)

## Important Implementation Notes

### User creation
Usernames for parents and staff are set to their email addresses. Students are set to their @ash.nl address. Parent accounts are created with the guardian email address provided through the e-collect form.

Usernames for teachers are set to the username portion of their @ash.nl email address. This is to prevent username collisions with parent accounts.

User creation must occur in the following order: Parents, Teachers, Students. Student accounts are related to parent accounts through the `relations` field; this field requires the `org_defined_id` from the parents to exist.

D2L IPSIS processes CSV files in alphabetical order. To enforce the proper order, it is critical that the PowerSchool Data Export Manager templates are set with filenames that will sort such that parents come first, teachers second and students last. 

See the *Data Export Manager* section for each Named Query below.

## 7 Users Parents Inactive

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
    so the sanity and sustainability of this is questionable 
    */
    and trim(guardian.firstname)=trim(u_studentsuserfields.mother_firstname)
    and trim(guardian.lastname)=trim(u_studentsuserfields.mother_lastname)
    and trunc(sysdate) - STUDENTS.EXITDATE < 180 
    and trunc(sysdate) - STUDENTS.EXITDATE > 0    
    and STUDENTS.ENROLL_STATUS !=0
    and students.grade_level >=5
order by "org_defined_id" asc
```

## 7 Users Parents Active

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

- *Export File Name:* `7-Users_002_mother_active-%d.csv` & `7-Users_003_fother_active-%d.csv`
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

Both mother and father query depend on u_studentuserfields.mother_firstanme|father_firstname be exactly equal to guardian.firstname. u_studentuserfields is populated via an e-collect form by parents. It is unclear how the guardian fields are populated, so this may break in the future. `¯\_(ツ)_/¯` May the force be with you, future maintainer.

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
    so the sanity and sustainability of this is questionable 
    */
    and trim(guardian.firstname)=trim(u_studentsuserfields.mother_firstname)
    and trim(guardian.lastname)=trim(u_studentsuserfields.mother_lastname)
    and LENGTH(U_STUDENTSUSERFIELDS.EMAILMOTHER) >0
    and STUDENTS.ENROLL_STATUS =0
    and students.grade_level >=5
order by "org_defined_id" asc
```

## 7 Users Teachers Inactive

### Fields Provided & Used

**PROVIDES FIELDS:**

- `org_defined_id` used in [08-Enrollments Students](#8-enrollmentsstudents) as `child_code`
- `org_defined_id` used in [08-Enrollments Teachers](#8-enrollmentsteachers) as `child_code`

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `T_`_`TEACHERS.TEACHERNUMBER`_ | T_123456

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
|org_define_id| TEACHERS.TEACHERNUMBER | _T\_234_ |
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
|TEACHERS|

**SQL Query**

Delete staff that are not "active" (STATUS != 1) 
```SQL
select distinct
    'user' as "type",
    'UPDATE' as "action",
    /* 
    use username portion of teacher/staff email addresses for D2L username.
    This is necessary because some staff use their @ash.nl email address as
    their guardian contact information. The parent accounts are created first
    resulting in a colision between the parent account username and teacher 
    account username.
    */
    regexp_replace(TEACHERS.EMAIL_ADDR, '(@.*)', '') as "username",
    /* prepend a 'T' to make sure there are no studentid/teacherid colisions */
    'T_'||TEACHERS.TEACHERNUMBER as "org_defined_id",
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

## 7 Users Teachers Active

All active staff.

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



## 7 Users Teacher-Auditors Active

All teachers that are Learner Support Auditors. Teachers of EAL and Learning Support classes. These users are linked via the relationship field for students. These roles overwrite the "Instructor" roles.

### Fields Provided & Used

- `org_defined_id` used in [08-Enrollments Students](#8-enrollmentsstudents) as `child_code`
- `org_defined_id` used in [08-Enrollments Teachers](#8-enrollmentsteachers) as `child_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export Form:**  `NQ com.txoof.brightspace.users.07t_active_auditors`

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

- *Export File Name:* `7-Users_102_teachers_active_auditors-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

- File: `07_u_t_active_auditors.named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| TEACHERS.ID | user | N1 |
|action| TEACHERS.ID | UPDATE | N1 |
|username| TEACHERS.EMAIL_ADDR |_foo@ash.nl_ |
|org_define_id| TEACHERS.ID | _T\_234_ |
|first_name| TEACHERS.FIRST_NAME | _John_ |
|last_name| TEACHERS.LAST_NAME |_Doe_ | 
|password| TEACHERS.ID | '' | N1 |
|role_name| TEACHERS.ID | _Learner Support_ | N1 |
|relationships| TEACHERS.ID | TBD | N1 |
|pref_frist_name| TEACHERS.ID |TBD | N1 |
|pref_last_name| TEACHERS.ID |TBD | N1 |

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|TEACHERS|
|CC|
|STUDENTS|
|TEACHERS|
|COURSES|

**SQL Query**

```SQL
select distinct
    'user' as "type",
    'UPDATE' as "action",
    /* 
    use username portion of teacher/staff email addresses for D2L username.
    This is necessary because some staff use their @ash.nl email address as
    their guardian contact information. The parent accounts are created first
    resulting in a colision between the parent account username and teacher 
    account username.
    */
    regexp_replace(TEACHERS.EMAIL_ADDR, '(@.*)', '') as "username",
    /* prepend a 'T' to make sure there are no studentid/teacherid colisions */
    'T_'||TEACHERS.TEACHERNUMBER as "org_defined_id",
    TEACHERS.FIRST_NAME as "first_name",
    TEACHERS.LAST_NAME as "last_name",
    '' as "password",
    0 as "is_active",
    'Lerner Support' as "role_name",
    TEACHERS.EMAIL_ADDR as "email",
    '' as "relationships",
    '' as "pref_first_name",
    '' as "pref_last_name"
 from COURSES COURSES,
    CC CC,
    STUDENTS STUDENTS,
    TEACHERS TEACHERS 
 where CC.STUDENTID=STUDENTS.ID
    and CC.TEACHERID=TEACHERS.ID
    and COURSES.COURSE_NUMBER=CC.COURSE_NUMBER
    and TEACHERS.SCHOOLID >=2
    and CC.TERMID >=3100
    and STUDENTS.ENROLL_STATUS =0
    and TEACHERS.STATUS =1
    /*
    only include teachers of Learning Support (OLEA, MSLSC), EAL, Special Ed (SSE)
    and English Foundations 
    */
    and (cc.course_number like 'OLEA' 
        or courses.sched_department like 'MSLSC' 
        or courses.sched_department like 'MSEAL'
        /* ms, hs special education */
        or courses.sched_department like '%SSE%'
        or courses.course_name like '%ENG English Foundations%'
        or courses.course_name like '%English as an Addl Language%')
    and CC.COURSE_NUMBER=COURSES.COURSE_NUMBER
    and STUDENTS.ENROLL_STATUS =0
    and STUDENTS.GRADE_LEVEL >=5
    and CC.TERMID >= case 
      when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 7)
      THEN (EXTRACT(year from sysdate)-2000+9)*100
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN (EXTRACT(year from sysdate)-2000+10)*100
      end
order by "last_name" asc
```

## 7 Users Students Inactive

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

## 7 Users Students Active

This query pulls all active students grade 5 and higher and adds a relationship between students and parents.

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
    listagg('Parent'||chr(58)||'P_'||guardian.guardianid, chr(124)) WITHIN GROUP ( ORDER BY Guardian.LastName desc ) as "relationship",
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

## 7 Users Students Active w/ Auditors

This query includes active students that are enrolled in Learning Support, EAL or English Essentials courses. This query overwrites the previous student query and adds Auditor and Parent relations to the students. Students included are enrolled in courses with course_number "OLEA", sched_department "MSLSC", "MSEAL" and course_name "ENG English Foundations." 


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
|`relationships`| `Parent: org_defined_id\|Auditor: org_defined_id` | Parent:P_234123\|Auditor:T_93313

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.users.07s_active_w_auditor`

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

- *Export File Name:* `7-Users_202_Students_Active_W_Auditor.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`

### Query Setup for `named_queries.xml`

- File: `07_u_s_active_w_auditor.named_queries.xml`

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

**SQL Query**

```SQL
select distinct
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
    /* add Auditor relation to EAL, Learning Support teachers */
    listagg('Auditor'||chr(58)||'T_'||teachers.teachernumber, chr(124) )
        within group (order by teachers.teachernumber desc) ||chr(124)||
    listagg('Parent'||chr(58)||'P_'||guardian.guardianid, chr(124)) WITHIN GROUP ( ORDER BY Guardian.LastName desc ) as "relationship",
    '' as "pref_last_name",
    '' as "pref_first_name"
 
    from 
    /* this should remove duplicates, but it does not work */
    (select distinct 
        teachernumber, id
        from teachers) teachers,
    COURSES COURSES,
    STUDENTS STUDENTS,
    CC CC,
    U_STUDENTSUSERFIELDS U_STUDENTSUSERFIELDS,
    GUARDIANSTUDENT GUARDIANSTUDENT,
    guardian guardian
 
 where CC.STUDENTID=STUDENTS.ID
    and GuardianStudent.studentsdcid = Students.dcid
    and Guardian.GuardianID = GuardianStudent.GuardianID
    and U_STUDENTSUSERFIELDS.STUDENTSDCID = students.dcid
    and cc.teacherid = teachers.id

    /* 
    if student is enroled in OLEA, MSLC or Eng Foundations,
    add their teacher as an auditor
    */
    and (cc.course_number like 'OLEA' 
        or courses.sched_department like 'MSLSC' 
        or courses.sched_department like 'MSEAL'
        /* ms, hs special education */
        or courses.sched_department like '%SSE%'
        or courses.course_name like 'ENG English Foundations')
    and CC.COURSE_NUMBER=COURSES.COURSE_NUMBER
    and STUDENTS.ENROLL_STATUS =0
    and STUDENTS.GRADE_LEVEL >=5
    and CC.TERMID >= case 
      when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 7)
      THEN (EXTRACT(year from sysdate)-2000+9)*100
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN (EXTRACT(year from sysdate)-2000+10)*100
      end    
 
 GROUP BY students.grade_level, u_studentsuserfields.emailstudent, students.student_number,  students.first_name,  students.last_name
 
 order by STUDENTS.GRADE_LEVEL DESC
```


## 8 Enrollments Teachers

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
|child_code| `T_`_`TEACHERS.TEACHERNUMBER`_ | _T\_765_
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
|TEACHERS|

**SQL Query**

```SQL
select distinct
    'enrollment' as "type",
    'UPDATE' as "action",
    'T_'||TEACHERS.TEACHERNUMBER as "child_code",
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
  /* 
   exclude any teachers that do not have email addresses
   this should exclude "bookeeping" teachers that are created
   to host study blocks 
  */
  and length( teachers.email_addr) > 0
order by "child_code" asc, "parent_code" asc
```

## 8 Enrollments Students

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

- *Export File Name:* `8-Enrollments_students-%d.csv`
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