# BS_02_Departments

Powerschool &rarr; BrightSpace CSV active departments for 02-Departments

**PROVIDES FIELDS:**

- `code` used in 4-Template as `department_code` 

|Field |Format |example |
|:-|:-|:-|
|`code`| _`CC.SCHOOLID`_`_`_`COURSES.SCHED_DEPARTMENT`_| 2_MSEAL

**USES FIELDS:**

- `code` from [1-Other](../BS_01_Other/1-Other_README.md) as `custom_code`

## Data Export Manager

- **Category:** Show All
- **Export Form:**  com.txoof.brightspace.courses.departments

### Lables Used on Export

| Label |
|-|
|type|
|action|
|code|
|name|
|start_date|
|end_date|
|is_active|
|department_code|
|template_code|
|semester_code|
|offering_code|
|custom_code|

### Export Summary and Output Options

#### Export Format

- *Export File Name:* `2-Departments-%d.csv`
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
|type| CC.ID | _department_ | N1
|action| CC.ID |_UPDATE_ | N1
|code| COURSES.SCHED_DEPARTMENT | _3\_HSPerArts_ |
|name| COURSES.SCHED_DEPARTMENT | _HSPerArts_ |
|start_date| CC.ID | '' | N1
|end_date| CC.ID | '' | N1
|is_active| CC.ID | '' | N1
|department_code| CC.ID | '' | N1
|template_code| CC.ID | '' | N1
|semester_code| CC.ID | '' | N1
|offering_code| CC.ID | '' | N1
|custom_code| SCHOOLS.SCHOOL_NUMBER | _1_ | 

#### Notes

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

### Tables Used

| Table |
|-|
|STUDENTS|
|CC|
|COURSES|

### SQL

```SQL
select distinct
    'department' as "type",
    'UPDATE' as "action",
    CC.SCHOOLID||'_'||COURSES.SCHED_DEPARTMENT as "code",
    COURSES.SCHED_DEPARTMENT as "name",
    '' as "start_date",
    '' as "end_date",
    '' as "is_active",
    '' as "department_code",
    '' as "template_code",
    '' as "semester_code",
    '' as "offering_code",
    SCHOOLS.SCHOOL_NUMBER as "custom_code"
 from COURSES COURSES,
    STUDENTS STUDENTS,
    CC CC,
    SCHOOLS SCHOOLS
 where CC.STUDENTID=STUDENTS.ID
    and CC.SCHOOLID=SCHOOLS.SCHOOL_NUMBER
    and CC.COURSE_NUMBER=COURSES.COURSE_NUMBER
    and CC.TERMID >= case 
            when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 7)
            THEN (EXTRACT(year from sysdate)-2000+9)*100
            when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
            THEN (EXTRACT(year from sysdate)-2000+10)*100
            end
    and length(COURSES.SCHED_DEPARTMENT) > 0
 order by "code" asc
```