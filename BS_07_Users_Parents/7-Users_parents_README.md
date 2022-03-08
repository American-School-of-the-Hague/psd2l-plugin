# BS_07_Users_Students

Powerschool &rarr; BrightSpace CSV Student Export for 07-Users

**PROVIDES FIELDS:**

- `org_defined_id` used in [08-Enrollments_Students](../BS_08_Enrollments_Students/8-Enrollments_students_README.md) as `child_code` 

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `S_`_`STUDENTS.STUDENT_NUMBER`_ | S_123456

**USES FIELDS:**

- none

## Data Export Manager

- **Category:** Show All
- **Export Form:**  com.txoof.brightspace.students.usernames

### Lables Used on Export

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

### Export Summary and Output Options

#### Export Format

- *Export File Name:* `7-Users_students-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* TBD

#### Export Options

- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

## Query Setup for `named_query.xml`

### PowerQuery Output Columns

| header | table.field | value | NOTE |
|-|-|-|-|
|type| GUARDIAN.ID | user | N1 |
|action| GUARDIAN.ID | UPDATE | N1 |
|username|  | _bar@foo.com_ |
|org_define_id|  | _P\_123456_ |
|first_name| STUDENTS.FIRST_NAME | _Jane_ |
|last_name| STUDENTS.LAST_NAME |_Doe_ | 
|password| GUARDIAN.ID | '' | N1 |
|role_name| GUARDIAN.ID | _Learner_ | N1 |
|relationships| GUARDIAN.ID | TBD | N1 |
|pref_frist_name| GUARDIAN.ID |TBD | N1 |
|pref_last_name| GUARDIAN.ID |TBD | N1 |

#### Notes

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

### Tables Used

| Table |  |
|-|-|
|STUDENTS| |
|U_STUDENTSUSERFIELDS| |

### SQL

```
select distinct
    'user' as "type",
    'UPDATE' as "action",
    pcas_account.username as "username",
    'P_'||GUARDIAN.GUARDIANID as "org_defined_id",
    GUARDIAN.FIRSTNAME as "firstname",
    GUARDIAN.LASTNAME as "lastname",
    'welcomeash' as "password",
    1 as "is_active",
    'parent' as "role",
    pcas_emailcontact.emailaddress as "email",
    '' as "relationships",
    '' as "pref_first_name",
    '' as "pref_last_name"

    /*
    GUARDIAN.GUARDIANID as GUARDIANID,
    GUARDIAN.FIRSTNAME as FIRSTNAME,
    GUARDIAN.LASTNAME as LASTNAME,
    GUARDIAN.EMAIL as EMAIL,
    GUARDIANSTUDENT.STUDENTSDCID as STUDENTSDCID,
    STUDENTS.LASTFIRST as LASTFIRST,
    STUDENTS.ENROLL_STATUS as ENROLL_STATUS 
    */
 from 
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
  PCAS_Account PCAS_Account 
  ON 
  Guardian.AccountIdentifier = PCAS_Account.PCAS_AccountToken

  INNER JOIN 
  PCAS_EmailContact PCAS_EmailContact 
  ON 
  PCAS_Account.PCAS_AccountID = PCAS_EmailContact.PCAS_AccountID
where Students.enroll_status = 0
order by "org_defined_id"
```