# BrightSpace D2L Organization Plugin

PowerQuery Plugin for exporting the following information from PowerSchool &rarr; BrightSpace. This plugin creates the following exports:

- [`1-Other.csv`](#1-other)
- [`2-Departments.csv`](#2-departments)
- [`3-Semesters.csv`](#3-semesters)
- [`4-Templates.csv`](#4-templates)
- [`5-Offerings.csv`](#5-offerings)
- [`6-Sections.csv`](#6-sections)

## 1-Other

### Fields Provided & Used

**PROVIDES FIELDS**

- `code` used in [2-Department](#2-departments) as `custom_code` 

|Field |Format |example |
|:-|:-|:-|
|`code`| _`SCHOOLS.SCHOOL_NUMBER`_| 1

### Data Export Manager Setup

- **Category:** Show All
- **Export From:** `NQ com.txoof.brightspace.org.01other`
 
**Labels Used on Export**

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

**Export Summary and Output Options**

- *Export File Name:* `1-Other-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| SCHOOLS.ID | _School_ | N1
|action| SCHOOLS.ID | _UPDATE_ | N1
|code| SCHOOLS.SCHOOL_NUMBER | _2_ |
|name| COURSES.SCHED_DEPARTMENT | _ASH Middle School_ |
|start_date| SCHOOLS.ID | '' | N1
|end_date| SCHOOLS.ID | '' | N1
|is_active| SCHOOLS.ID | '' | N1
|department_code| SCHOOLS.ID | '' | N1
|template_code| SCHOOLS.ID | '' | N1
|semester_code| SCHOOLS.ID | '' | N1
|offering_code| SCHOOLS.ID | '' | N1
|custom_code| SCHOOLS.ID | '' | N1

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|SCHOOLS|

**SQL Query**

```SQL
select
    'school' as "type",
    'UPDATE' as "action",
    SCHOOLS.SCHOOL_NUMBER as "code",
    SCHOOLS.NAME as "name",
    '' as "start_date",
    '' as "end_date",
    '' as "is_active",
    '' as "department_code",
    '' as "template_code",
    '' as "semester_code",
    '' as "offering_code",
    '' as "custom_code"
 from SCHOOLS SCHOOLS
 order by "code" asc
```

## 2-Departments

### Fields Provided & Used

**PROVIDES FIELDS**

- `code` used in [4-Template](#4-templates) as `department_code` 

|Field |Format |example |
|:-|:-|:-|
|`code`| _`CC.SCHOOLID`_`_`_`COURSES.SCHED_DEPARTMENT`_| 2_MSEAL

### Data Export Manager Setup

- **Category:** Show All
- **Export From:** `NQ com.txoof.brightspace.org.02departments`

**Labels Used on Export**

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

**Export Summary and Output Options**

- *Export File Name:* `2-Departments-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

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

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|CC|
|COURSES|

**SQL Query**

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

## 3-Semesters

### Fields Provided & Used

**PROVIDES FIELDS**

`code` used in [5-Oferings](#5-offerings) as `semester_code`

|Field |Format |example |
|:-|:-|:-|
|`code`| `term_`_`cc.TermID`_| term_3102

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightpspace.org.03offerings`

**Labels Used on Export**

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

**Export Summary and Output Options**

- *Export File Name:* `3-Semesters-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`

| header | table.field | value | NOTE |
|-|-|-|-|
|type| TERMS.ID | _semester_| N1|
|action| TERMS.ID | _update_ | N1|
|code| `'term_'\|\|TERMS.ID` | _term\_3100_ 
|name| TERMS.NAME | _2021-2022_ or _Semester 1_ or _Quarter 1_
|start_date| TERMS.ID | '' | N1
|end_date| TERMS.ID | '' | N1
|is_active| `TERMS.FIRSTDAY < sysdate < TERMS.LASTDAY` | _0_; _1_
|department_code| TERMS.ID | '' | N1
|template_code| TERMS.ID | '' | N1
|semester_code| TERMS.ID | '' | N1
|offering_code| TERMS.ID | '' | N1
|custom_code| TERMS.ID | '' | N1


**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|TERMS|

**SQL Query**

```SQL
select
  'semester' as "type",
  'UPDATE' as "action",
  'term_'||TERMS.ID as "code",
  TERMS.NAME as "name",
  '' as "start_date",
  '' as "end_date",
  '' as "is_active",
  '' as "department_code",
  '' as "template_code",
  '' as "semester_code",
  '' as "offering_code",
'' as "custom_code"
from TERMS TERMS 
    where TERMS.YEARID = (CASE 
    WHEN (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 7)
     THEN EXTRACT(year from sysdate)-2000+9
    WHEN (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
     THEN EXTRACT(year from sysdate)-2000+10
      END)
order by "code" asc
```

## 4-Templates

### Fields Provided & Used

**PROVIDES FIELDS**

- `code` used in [5-Ofering](#5-offerings) as `template_code` 

|Field |Format |example |
|:-|:-|:-|
|`code`| `TEMPLATE_`_`CC.SCHOOLID`_`_`_`COURSES.SCHED_DEPARTMENT`_| TEMPLATE_2_MSEAL

**USES FIELDS:**

- `code` from [2-Deparments](#2-departments) as `department_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.org.04templates`

**Labels Used on Export**

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

**Export Summary and Output Options**

- *Export File Name:* `4-Templates-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`
| header | table.field | value | NOTE |
|-|-|-|-|
|type| CC.ID | _department_ | N1
|action| CC.ID |_UPDATE_ | N1
|code| COURSES.SCHED_DEPARTMENT | _Templ_3\_HSPerArts_ |
|name| COURSES.SCHED_DEPARTMENT | _HSPerArts_ |
|start_date| CC.ID | '' | N1
|end_date| CC.ID | '' | N1
|is_active| CC.ID | '' | N1
|department_code| COURSES.SCHED_DEPARTMENT | '' | N1
|template_code| CC.ID | '' | N1
|semester_code| CC.ID | '' | N1
|offering_code| CC.ID | '' | N1
|custom_code| CC.ID | '' | N1

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|CC|
|COURSES|

**SQL Query**

```SQL
select distinct
    'department' as "type",
    'UPDATE' as "action",
    'Templ_'||CC.SCHOOLID||'_'||COURSES.SCHED_DEPARTMENT as "code",
    COURSES.SCHED_DEPARTMENT as "name",
    '' as "start_date",
    '' as "end_date",
    '' as "is_active",
    CC.SCHOOLID||'_'||COURSES.SCHED_DEPARTMENT as "department_code",
    '' as "template_code",
    '' as "semester_code",
    '' as "offering_code",
    '' as "custom_code"
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

## 5-Offerings

### Fields Provided & Used

**PROVIDES FIELDS**
`code` used in [6-Sections](#6-sections) as `offering_code` 

|Field |Format |example |
|:-|:-|:-|
|`code`| `co_`_`cc.SchoolID`_`_`_`cc.Course_Number`_| co_3_ITLDPROG1

**USES FIELDS:**

- `code` from [3-Semesters](#3-semesters) as `semester_code`
- `code` from [4-Templates](#4-templates) as `template_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.org.05offerings`

**Labels Used on Export**

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

**Export Summary and Output Options**

- *Export File Name:* `5-Offerings-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`
| header | table.field | value | NOTE |
|-|-|-|-|
|type| CC.ID | _course offering_ | N1
|action| CC.ID | _UPDATE_ | N1
|code| 'co_'schoolid\_coursenumber' | _co\_3\_ITLDPROG1_
|name| C.COURSE_NAME | _IT Programming_ 
|start_date| CC.ID | '' | N1
|end_date| CC.ID | '' | N1
|is_active| CC.ID | _0_ | N1
|department_code| CC.ID | '' | N1
|template_code| CC.ID | '' | N1
|semester_code|   schoolid'\_term\_'cc.termid | _term_3102_ 
|offering_code| CC.ID | '' | N1
|custom_code| CC.ID | '' | N1

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|CC|
|TERMS|

**SQL Query**

```SQL
select distinct
    'course offering' as "type",
    'UPDATE' as "action",
    /* co_cc.schoolid_cc.course_number */
    'co_'||cc.schoolid||'_'||cc.course_number as "code",
    c.course_name as "name",
    TERMS.FIRSTDAY as "start_date",
    TERMS.LASTDAY as "end_date",
    /* set courses as inactive by default */
    0 as "is_active",
    '' as "department_code",
    'Templ_'||CC.SCHOOLID||'_'||C.SCHED_DEPARTMENT as "template_code",
    'term_'||cc.termid as "semester code",
    '' as "offering_code",
    '' as "custom_code"
from 
    students s
    join cc on cc.studentid = s.id
    join schoolstaff ss on ss.id = cc.teacherid
    join courses c on c.course_number = cc.course_number,
    terms terms
where
        terms.id = cc.termid and
        /* select only courses that are in the current yearid (e.g. 2021-2022 == 3100)*/
        cc.termid >= case 
            when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 7)
            THEN (EXTRACT(year from sysdate)-2000+9)*100
            when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
            THEN (EXTRACT(year from sysdate)-2000+10)*100
            end
order by "semester code" desc
```

## 6-Sections

### Fields Provided & Used

**PROVIDES FIELDS:**

`code` used in ?? as `????` 

|Field |Format |example |
|:-|:-|:-|
|`code`| `cs_`_`cc.schoolID`_`_`_`cc.course_number`_`_`_`cc.termid`_| 

**USES FIELDS:**

- `code` from [3-Semesters](#3-semesters) as `semester_code`
- `code` from [5-Offerings](#5-offerings) as `offering_code`

### Data Export Manager Setup

- **Category:** Show All
- **Export From:**  `NQ com.txoof.brightspace.org.06sections`

**Labels Used on Export**

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

**Export Summary and Output Options**

- *Export File Name:* `6-Sections-%d.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* `UTF-8`
- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

### Query Setup for `named_queries.xml`
| header | table.field | value | NOTE |
|-|-|-|-|
|type| CC.ID | _course offering_ | N1
|action| CC.ID | _UPDATE_ | N1
|code| 'co_'schoolid\_coursenumber\_termid | _co\_3\_MCABAP\_3100_
|name| C.COURSE_NAME | _MA AP Calculus (AB)_
|start_date| CC.ID | '' | N1
|end_date| CC.ID | '' | N1
|is_active| CC.ID | '' | N1
|department_code| CC.ID | '' | N1
|template_code| CC.ID | '' | N1
|semester_code|   CC.ID | '' | N1
|offering_code| 'co_'schoolid\_coursenumber | _co\_3\_ITLDPROG1_
|custom_code| CC.ID | '' | N1

**NOTES**

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

**Tables Used**

| Table |
|-|
|STUDENTS|
|CC|
|TERMS|

**SQL Query**

```SQL
select distinct
    'course section' as "type",
    'UPDATE' as "action",
    /* cs_cc.schoolid_cc.course_number */
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
     'UNKNOWN') "code",
    c.course_name||' - '||DECODE(substr(cc.expression, 1, 1), 
     1, 'A', 
     2, 'B', 
     3, 'C', 
     4, 'D', 
     5, 'E', 
     6, 'F', 
     7, 'G', 
     8, 'H', 
     9, 'ADV', 
     'UNKNOWN')||' Block' as "name",
    '' as "start_date",
    '' as "end_date",
    '' as "is_active",
    '' as "department_code",
    '' as "template_code",
    '' as "semester code",
    'co_'||cc.schoolid||'_'||cc.course_number as "offering_code",
    '' as "custom_code"
from 
students s
join cc on cc.studentid = s.id
join schoolstaff ss on ss.id = cc.teacherid
join courses c on c.course_number = cc.course_number,
terms terms
where
    terms.id = cc.termid and
    /* select only courses that are in the current yearid (e.g. 2021-2022 == 3100)*/
    cc.termid >= case 
        when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 7)
        THEN (EXTRACT(year from sysdate)-2000+9)*100
        when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
        THEN (EXTRACT(year from sysdate)-2000+10)*100
        end
order by "semester code" desc
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