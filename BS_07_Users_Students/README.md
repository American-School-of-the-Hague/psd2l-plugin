# BS_07_Users_Students

Powerschool &rarr; BrightSpace CSV Student Export for 07-Users

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

- *Export File Name:* `7-Users.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* TBD

#### Export Options

- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

## Query Setup for `named_query.xml`

### PowerQuery Output Columns

| header | default value |
|-|-|
|type| user |
|action| UPDATE|
|username| _ASH email userid_ |
|org_define_id| _SIS student number_ |
|first_name| _SIS First Name_ |
|last_name| _SIS Last Name_ |
|password| _NONE_ |
|role_name| Learner|
|relationships| TBD |
|pref_frist_name | TBD |
|fref_last_name | TBD |

### Tables Used

| Table |  |
|-|-|
|STUDENTS| |
|U_STUDENTSUSERFIELDS| |

### SQL

```
select 
    'user' as "type",
    'UPDATE' as "action",
    REGEXP_REPLACE(U_STUDENTSUSERFIELDS.EMAILSTUDENT, '(^.*)(@.*)', '\1') as "username",    
    STUDENTS.ID as "org_defined_id",
    STUDENTS.FIRST_NAME as "first_name",
    STUDENTS.LAST_NAME as "last_name", 
    '' as "password",
    'Learner' as "role_name",
    '' as "relationships",
    '' as "pref_first_name",
    '' as "pref_last_name",
    U_STUDENTSUSERFIELDS.EMAILSTUDENT as "email",
    (CASE STUDENTS.ENROLL_STATUS
        WHEN 0 THEN 1
        ELSE NULL END) as "is_active"
        
from STUDENTS STUDENTS,
    U_STUDENTSUSERFIELDS U_STUDENTSUSERFIELDS
where STUDENTS.ENROLL_STATUS =0
    and U_STUDENTSUSERFIELDS.STUDENTSDCID=STUDENTS.DCID
    and STUDENTS.GRADE_LEVEL >=5
```