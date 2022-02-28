# BS_07_Users_Teachers

Powerschool &rarr; BrightSpace CSV Sections for 06_Sections

## Outstanding questions
- [ ] Where does the `code` field get used?
- [ ] How do we connect sections to users
- [ ] How does this relate to 08-enrollments?

**PROVIDES FIELDS:**

`code` used in ?? as `????` 

|Field |Format |example |
|:-|:-|:-|
|`code`| `cs_`_`cc.schoolID`_`_`_`cc.course_number`_`_`_`cc.termid`_| 

**USES FIELDS:**

- `code` from [03_Semesters](../BS_03_Semesters/README.md) as `semester_code`
- `code` from [05_Offerings](../BS_05_Offerings/README.md) as `offering_code`

## Data Export Manager

- **Category:** Show All
- **Export Form:**  com.txoof.brightspace.courses.sections

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

- *Export File Name:* `BASE_PLUGIN.csv`
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
|code| 'co_'schoolid\_coursenumber\_termid | _cs\_3\_MCABAP\_3100_
|name| C.COURSE_NAME | _MA AP Calculus (AB)_ 
|start_date| CC.ID | '' | N1
|end_date| CC.ID | '' | N1
|is_active| CC.ID | '' | N1
|department_code| CC.ID | '' | N1
|template_code| CC.ID | '' | N1
|semester_code|   CC.ID | '' | N1 
|offering_code| 'co_'schoolid\_coursenumber | _co\_3\_ITLDPROG1_
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
	'course section' as "type",
	'UPDATE' as "action",
    /* cs_cc.schoolid_cc.course_number */
    'cs_'||cc.schoolid||'_'||cc.course_number||'_'||cc.TermID as "code",
	c.course_name as "name",
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