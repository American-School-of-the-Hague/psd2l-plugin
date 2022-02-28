# BS_07_Users_Teachers

Powerschool &rarr; BrightSpace CSV x for 00-xx

**PROVIDES FIELDS:**

`xx` used in 6-Sections as `yyy` 

|Field |Format |example |
|:-|:-|:-|
|`xx`| `foo_`_`cc.bar`_| foo_bar

**USES FIELDS:**

`xx` from [foo]() as `yyy`

## Data Export Manager

- **Category:** Show All
- **Export Form:**  tld.domain.product.area.name

### Lables Used on Export

| Label |
|-|
|foo|
|ID|
|LAST_NAME|

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

```
select 
   'foo' as "bar",
   STUDENTS.ID as ID,
STUDENTS.LAST_NAME as LAST_NAME 
from STUDENTS STUDENTS 
where STUDENTS.ENROLL_STATUS =0
```