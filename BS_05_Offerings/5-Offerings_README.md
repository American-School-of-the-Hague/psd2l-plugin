# BS_05_Offerings

Powerschool &rarr; BrightSpace CSV Teacher and Staff Export for 07-Users

## Outstanding Questions
* does `code` need to be unique?
  * can resolve by Post-pended CC.TERMID to make unique
* what other fields are needed?
* `code` is structured as `co_schoolid_course_number`

**PROVIDES FIELDS:**

`code` used in [BS_06_Sections](../BS_06_Sections/6-Sections_README.md) as `offering_code` 

|Field |Format |example |
|:-|:-|:-|
|`code`| `co_`_`cc.SchoolID`_`_`_`cc.Course_Number`_| co_3_ITLDPROG1

**USES FIELDS:**

`code` from [BS_03_Semesters](../BS_03_Semesters/3-Semesters_README.md) as `semester_code`


## Data Export Manager

- **Category:** Show All
- **Export Form:**  com.txoof.brightspace.courses.offerings

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
|code| 'co_'schoolid\_coursenumber' | _co\_3\_ITLDPROG1_
|name| C.COURSE_NAME | _IT Programming_ 
|start_date| CC.ID | '' | N1
|end_date| CC.ID | '' | N1
|is_active| CC.ID | '' | N1
|department_code| CC.ID | '' | N1
|template_code| CC.ID | '' | N1
|semester_code|   schoolid'\_term\_'cc.termid | _term_3102_ 
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
	/* co_cc.schoolid_cc.course_number */
	'co_'||cc.schoolid||'_'||cc.course_number as "code",
		c.course_name as "name",
		'' as "start_date",
		'' as "end_date",
		'' as "is_active",
		'' as "department_code",
		'' as "template_code",
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