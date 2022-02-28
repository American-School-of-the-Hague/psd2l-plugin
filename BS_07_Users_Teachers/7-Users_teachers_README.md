# BS_07_Users_Teachers

Powerschool &rarr; BrightSpace CSV Teacher and Staff Export for 07-Users

**PROVIDES FIELDS:**

- `org_defined_id` used in [08-Enrollments](../BS_08_Enrollments/README.md) as `child_code` 

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `T_`_`TEACHERS.ID`_ | T_123456

**USES FIELDS:**

- none

## Data Export Manager

- **Category:** Show All
- **Export Form:**  com.txoof.brightspace.teachers.usernames

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

- *Export File Name:* `7-Users.csv`
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

#### Notes

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

### Tables Used

| Table |  |
|-|-|
|STUDENTS| |
|U_STUDENTSUSERFIELDS| |

### SQL

Ignore staff that do not have an emaila ddress; ignore staff that are outside of their "home" school.

```
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