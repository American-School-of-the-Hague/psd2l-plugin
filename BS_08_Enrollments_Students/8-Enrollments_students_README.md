# BS_08_Enrollments

Powerschool &rarr; BrightSpace CSV Enrollments for 08-Enrollments

**PROVIDES FIELDS:**

- `child_code` used in ?? as `??` 

|Field |Format |example |
|:-|:-|:-|
|`child_code`| `'cs_'\|\|cc.schoolid\|\|'_'\|\|cc.course_number\|\|'_'\|\|cc.TermID` | cs_2_C5A_3100

**USES FIELDS:**

- `org_defined_id` from [07-Users - Students](../BS_07_Users_Students/README.md) as `child_code`
- `code` from [06-Sections](../BS_06_Offerings/README.md) as `parent_code`
- ALTERNATIVE: `code` from [05-Offerings](../BS_05_Offerings/README.md) as `parent_code`


## Data Export Manager

- **Category:** Show All
- **Export From:**  com.txoof.brightspace.students.student_number

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

- *Export File Name:* `8-Enrollments_students-%d.csv`
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
|type| CC.ID | _enrollment_ | N1
|action| CC.ID | _UPDATE_ | N1
|child_code| `S_`_`STUDENTS.STUDENT_NUMBER`_ | _S\_506113_
|role_name| CC.ID | _Learner_ | N1
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