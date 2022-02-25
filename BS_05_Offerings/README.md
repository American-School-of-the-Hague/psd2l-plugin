# BS_07_Users_Teachers

Powerschool &rarr; BrightSpace CSV Teacher and Staff Export for 07-Users

## Data Export Manager

- **Category:** Show All
- **Export Form:**  com.txoof.brightspace.cc.sections

### Lables Used on Export

| Label |
|-|
|foo|
|ID|
|LAST_NAME|

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
|foo| STUDENTS.ID | user | N1 |
|ID| STUDENTS.ID |_SIS student number_ |
|last_name| STUDENTS.LAST_NAME |_SIS Last Name_ | 

#### Notes

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

### Tables Used

| Table |  |
|-|-|
|STUDENTS| |

### SQL


**IN PROGRESS**
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