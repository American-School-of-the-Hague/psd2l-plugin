# BS_07_Users_Teachers

Powerschool &rarr; BrightSpace CSV Teacher and Staff Export for 07-Users

## Data Export Manager

- **Category:** Show All
- **Export Form:**  NQ com.txoof.brightpsace.terms.id

### Lables Used on Export

| Label |
|-|
|type|
|action|
|code|
|name|
|start_date|
|end|date|
|is_active|
|department_code|
|template_code|
|semester_code|
|offering_code|
|custom_code|

### Export Summary and Output Options

#### Export Format

- *Export File Name:* `3-Semesters.csv`
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
|type| TERMS.ID | _semester_| N1|
|action| TERMS.ID | _update_ | N1|
|code| `TERMS.SCHOOLID\|\|'_term_'\|\|TERMS.ID` | _1\_term\_3100_ 
|name| TERMS.NAME | _2021-2022_; _Semester 1_
|start_date| TERMS.FIRSTDAY| _08/18_2021_
|end|date| TERMS.LASTDAY | _01/23/2022_
|is_active| `TERMS.FIRSTDAY < sysdate < TERMS.LASTDAY` | _0_; _1_
|department_code| TERMS.ID | '' | N1
|template_code| TERMS.ID | '' | N1
|semester_code| TERMS.ID | '' | N1
|offering_code| TERMS.ID | '' | N1
|custom_code| TERMS.ID | '' | N1

#### Notes

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

### Tables Used

| Table |  |
|-|-|
|TERMS| |

### SQL

```
select
		'semester' as "type",
		'UPDATE' as "action",
		'term_'||TERMS.ID as "code",
		TERMS.NAME as "name",
		TERMS.FIRSTDAY as "start_date",
		TERMS.LASTDAY as "end_date",
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