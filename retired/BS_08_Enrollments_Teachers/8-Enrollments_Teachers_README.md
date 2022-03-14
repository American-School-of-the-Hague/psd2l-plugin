# BS_08_Enrollments

Powerschool &rarr; BrightSpace CSV Enrollments for 08-Enrollments

## Outstanding Questions
- [ ] Does `parent_code` link to 5-Offerings: `code`
- [ ] Can we use 6-Sections `code` for managing enrollments (by section rather than by course?)
- [ ] how do we link teachers to sections/courses/etc

**PROVIDES FIELDS:**

- `child_code` used in ?? as `??` 

|Field |Format |example |
|:-|:-|:-|
|`child_code`| `'cs_'\|\|cc.schoolid\|\|'_'\|\|cc.course_number\|\|'_'\|\|cc.TermID` | cs_2_C5A_3100

**USES FIELDS:**

- `org_defined_id` from [07-Users - Teachers](../BS_07_Users_Teachers/7-Users_teachers_README.md) as `child_code`
- `code` from [06-Sections](../BS_06_Sections/6-Sections_README.md) as `parent_code`
- ALTERNATIVE: `code` from [05-Offerings](../BS_05_Offerings/README.md) as `parent_code`


## Data Export Manager

- **Category:** Show All
- **Export From:**  com.txoof.brightspace.teachers.teacher_number

### Lables Used on Export

| Label |
|-|
|type|
|action|
|child_code|
|role_name|
|parent_code|

### Export Summary and Output Options

#### Export Format

- *Export File Name:* `8-Enrollments_teachers-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* UTF-8

#### Export Options

- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

## Query Setup for `named_queries.xml`

### PowerQuery Output Columns

| header | table.field | value | NOTE |
|-|-|-|-|
|type| TEACHERS.ID | _enrollment_ | N1
|action| TEACHERS.ID | _UPDATE_ | N1
|child_code| `T_`_`TEACHERS.ID`_ | _T\_765_
|role_name| CC.ID | _Instructor_ | N1
|parent_code| `cs_`_`cc.schoolid`_`_`_`cc.course_number`_`_`_`cc.termid`_ | _cs_2_E0DNS_3100_ 

#### Notes

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

### Tables Used

| Table |  |
|-|-|
|STUDENTS| |
|COURSES|
|CC|
|SECTIONS|

### SQL

```
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