# BS_05_Offerings

Powerschool &rarr; BrightSpace CSV Teacher and Staff Export for 07-Users

## Outstanding Questions
* does `code` need to be unique?
  * can resolve by Post-pended CC.TERMID to make unique
* what other fields are needed?
* `code` is structured as `co_schoolid_FirstLetterOfEachName`

**PROVIDES FIELDS:**

`code` used in 6-Sections as `offering_code`


**USES FIELDS:**

`code` from BS_03_Semesters as `semester_code`


## Data Export Manager

- **Category:** Show All
- **Export Form:**  com.txoof.brightspace.cc.sections

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

- *Export File Name:* `5-Offerings.csv`
- *Line Delimiter:* `CR-LF`
- *Field Delimiter:* `,`
- *Character Set:* TBD

#### Export Options

- *Include Column Headers:* `True`
- *Surround "field values" in Quotes:* TBD

## Query Setup for `named_queries.xml`

### PowerQuery Output Columns

| header | table.field | value | NOTE |
|-|-|-|-|
|type| CC.ID | _course offering_ | N1
|action| CC.ID | _UPDATE_ | N1
|code| 'co_'schoolid'\_'coursename'\_'termid | _c\_3\_SCIBI\_3102_
|name| C.COURSE_NAME | _SCI Biology I_ 
|start_date| CC.ID | '' | N1
|end_date| CC.ID | '' | N1
|is_active| CC.ID | '' | N1
|department_code| CC.ID | '' | N1
|template_code| CC.ID | '' | N1
|semester_code|   schoolid'\_term\_'cc.termid | _3_term_3102_ 
|offering_code| CC.ID | '' | N1
|custom_code| CC.ID | '' | N1

#### Notes

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

### Tables Used

| Table |  |
|-|-|
|STUDENTS| |
|CC|
|TERMS|

### SQL

```
select distinct
  'course offering' as "type",
  'UPDATE' as "action",
  /* REGEXP_REPLACE(c.course_name, '[^a-zA-Z0-9]', '')*/
  'co_'||cc.schoolid||'_'||replace(REGEXP_REPLACE(c.course_name, '[^A-Z0-9]', ''), ' ', '_') as "code",
 /* alternative w/ termid postpended:   'co_'||cc.schoolid||'_'||replace(REGEXP_REPLACE(c.course_name, '[^A-Z0-9]', ''), ' ', '_')||'_'||cc.termid as "code", */
  c.course_name as "name",
  '' as "start_date",
  '' as "end_date",
  '' as "is_active",
  '' as "template_code",
  cc.schoolid||'_term_'||cc.termid as "semester code",
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
      THEN EXTRACT(year from sysdate)+1078
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN EXTRACT(year from sysdate)+1079
      end

order by "semester code" desc
```





13:32 2202.02.25
```
select distinct
  'course offering' as "type",
  'UPDATE' as "action",
  /* REGEXP_REPLACE(c.course_name, '[^a-zA-Z0-9]', '') to keep full names*/
  'co_'||cc.schoolid||'_'||replace(REGEXP_REPLACE(c.course_name, '[^A-Z0-9]', ''), ' ', '_') as "code",
 /* alternative w/ termid postpended:   'co_'||cc.schoolid||'_'||replace(REGEXP_REPLACE(c.course_name, '[^A-Z0-9]', ''), ' ', '_')||'_'||cc.termid as "code", */
  c.course_name as "name",
  '' as "start_date",
  '' as "end_date",
  '' as "is_active",
  '' as "template_code",
  cc.schoolid||'_term_'||cc.termid as "semester code",
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
      THEN EXTRACT(year from sysdate)+1078
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN EXTRACT(year from sysdate)+1079
      end

order by "semester code" desc
```


13:00 2202.02.25
```
select distinct
  'course offering' as "type",
  'UPDATE' as "action",
  /* prepend co "course offerings" and strip out non alpha*/
  'co_'||cc.schoolid||'_'||REPLACE(replace(REGEXP_REPLACE(c.course_name, '[\[\]()&/-]', ''), 'Grade ', ''), ' ', '_') as "code",
  c.course_name as "name",
  '' as "start_date",
  '' as "end_date",
  '' as "is_active",
  '' as "template_code",
  cc.schoolid||'_term_'||cc.termid as "semester code",
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
      THEN EXTRACT(year from sysdate)+1078
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN EXTRACT(year from sysdate)+1079
      end

order by "semester code" desc
```


12:49 2202.02.25
```
select distinct
  'course offering' as "type",
  'UPDATE' as "action",
  c.course_name as "name",
  '' as "start_date",
  '' as "end_date",
  REPLACE(REGEXP_REPLACE(c.course_name, '[()&/-]', ''), ' ', '_') as code,
  cc.schoolid||'_term_'||cc.termid as "semester code",
  cc.termid,
  cc.schoolid
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
      THEN EXTRACT(year from sysdate)+1078
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN EXTRACT(year from sysdate)+1079
      end

order by cc.termid desc
```


12:38 2022.02.25
```
select distinct
  'course offering' as "type",
  'UPDATE' as "action",
  c.course_name as "name",
  '' as "start_date",
  '' as "end_date",
  cc.schoolid||'_term_'||cc.termid as "semester code",
  cc.termid,
  cc.schoolid
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
      THEN EXTRACT(year from sysdate)+1078
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN EXTRACT(year from sysdate)+1079
      end

order by cc.termid desc
```


```
select
  ss.users_dcid,
  s.dcid,
  cc.course_number,
  cc.sectionid,
  cc.section_number,
  c.course_name,
  cc.termid
from 
students s
join cc on cc.studentid = s.id
join schoolstaff ss on ss.id = cc.teacherid
join courses c on c.course_number = cc.course_number
where
  /* select only courses that are in the current yearid (e.g. 2021-2022 == 3100)*/
  cc.termid >= case 
      when (EXTRACT(month from sysdate) >= 1 and EXTRACT(month from sysdate) <= 7)
      THEN EXTRACT(year from sysdate)+1078
      when (EXTRACT(month from sysdate) > 7 and EXTRACT(month from sysdate) <= 12)
      THEN EXTRACT(year from sysdate)+1079
      end
order by cc.termid desc
```