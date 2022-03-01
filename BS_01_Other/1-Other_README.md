# BS_02_Departments

Powerschool &rarr; BrightSpace CSV schools for 01-Other

**PROVIDES FIELDS:**

- `code` used in [2-Department](../BS_02_Departments/2-Departments_README.md) as `custom_code` 

|Field |Format |example |
|:-|:-|:-|
|`code`| _`SCHOOLS.SCHOOL_NUMBER`_| 1

## Data Export Manager

- **Category:** Show All
- **Export Form:**  com.txoof.brightspace.schools.schoolcode

### Lables Used on Export

| Label |

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

- *Export File Name:* `1-Other.csv`
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

#### Notes

**N1:** Field does not appear in database; use a known field such as `<column column=STUDENT.ID>header<\column>` to prevent an "unknown column error"

### Tables Used

| Table |
|-|
|SCHOOLS|

### SQL

```
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