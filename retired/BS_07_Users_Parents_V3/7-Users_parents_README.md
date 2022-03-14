# BS_07_Users_Parents

Powerschool &rarr; BrightSpace CSV Parent Export for 07-Users

**PROVIDES FIELDS:**

- `org_defined_id` used in [07-Users_Students](../BS_07_Users_Students/7-Users_students_README.md) in `relationships` field as `Id` 

|Field |Format |example |
|:-|:-|:-|
|`org_defined_id`| `P_`_`GUARDIAN.GUARDIANID`_ | P_1234567

**USES FIELDS:**

- none

## Data Export Manager

- **Category:** Show All
- **Export Form:**  com.txoof.brightspace.parents.usernames

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
**Note**: Parents file must be processed *before* students so relationships can be properly built. Prepend `000` to parents CSV to ensure this. Students should be `7-Users_200_Students-%d.csv` to ensure it is processed later.

- *Export File Name:* `7-Users_000_Parents_Mother|Father-%d.csv` -- one for mother, one for father 
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* UTF-8

#### Export Options

- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

## Query Setup for `named_query.xml`

### PowerQuery Output Columns

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

#### Notes

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**N2:** Acording to the spec, this should be `GUARDIAN.GUARDIANID` or `GUARDIAN.FIRSTNAME`, however this causes a filter error when running the plugin. To avoid this error, use `STUDENT.ID` instead. This should not affect the performance of the plugin.  This is because: REASONS `¯\_(ツ)_/¯`.

### Tables Used

| Table |
|-|
|GUARDIANSTUDENT |
|GUARDIAN |
|U_STUDENTSUSERFIELDS |
|STUDENTS STUDENTS |

### SQL

Both mother and father query depend on u_studentuserfields.mother|father_firstname be exactly equal to guardian.firstname. u_studentuserfields is populated via an e-collect form by parents. It is unclear how the guardian fields are populated, so this may break in the future. `¯\_(ツ)_/¯`

#### Active Mothers

```
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
    and STUDENTS.ENROLL_STATUS =0
    and students.grade_level >=5
order by "org_defined_id" asc

```