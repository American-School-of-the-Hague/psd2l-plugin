# D2L BrightSpace IPSIS exports from PowerSchool SIS

Feb/March 2022, Aaron Ciuffo

## Implementation Notes

Exports are managed through PowerSchool PowerQuery Plugins. Plugins follow the structure outlined below. Each CSV Export for BrightSpace is managed through an individual plugin. Each plugin contains an SQL query that matches the required fields for the CSV.

## Setup and Installation

### SIS Installation

1. Download plugins from this GIT Repo; each plugin is stored as a .zip file
   - See [list below](#list-of-plugins-and-functions) for all plugins and their fuctions
2. Install plugins throught the _Plugin Management Dashboard_: 
   - **Start Page > System Administrator > System Settings > Plugin Management Dashboard**
   - If the plugin is already installed either choose to _Update_ or _Delete_ and reinstall using the .zip files
3. Configure a template for automated export in [_Data Export Manager_](#data-export-manager-configuration)
   - **Start Page > System Administrator > Page and Data Management > Data Export Manager**

### Data Export Manager Configuration

**Start Page > System Administrator > Page and Data Management > Data Export Manager**

Each plugin needs to be configured to produce CSV files with the appropriate data, characterset and column headers. Each plugin documents the structure and settings under the **Data Export Manager** heading. See the `README.md` in each plugin directory for more details.

The basic settings are as follows:
1. Select Columns to Export:
   - **Category:** _Show All_
   - **Export From:** _NQ com.txoof.brightspace.table.area_ (see the DEM section in each readme)
   - ![DEM Screen 00](./documentation/DEM_00.png)
2. Select all of the fields:
   - ![DEM Screen 01 - Fields](./documentation/DEM_01.png)
3.  Remove the `TABLE.` portion in the _Labels used on Export_ for every column (highlighted in blue/red) and click _Next_
   - ![DEM Screen 02 - labels](./documentation/DEM_02.png)
4. On the following _Select/Edit Records from NQ - com.txoof.brightspace.table.area_ screen click _Next_
    - No filtering should be needed
5. On the following _Export Summary and Output Options_ screen set:
   - **Export File Name**: _See README.md_ for filename format (e.g. `1-Other.csv`)
   - **Line Delimiter**: `CR-LF`
   - **Field Delimiter**: `Comma`
   - **Character Set**: `UTF-8`
6. Click _Save Template_; see the `README.md` for each plugin for specifics
   - **Name**: BSpace 1-Other.csv Export
   - **Description**: Updated: YYYY.MM.DD
7. Click _Save as New_

## Automated Exports

TBD


## List of Plugins and Functions
- [BS_01_Other](./BS_01_Other/1-Other_README.md): Setup Schools
- [BS_02_Departments](./BS_02_Departments/2-Departments_README.md): Set up Departments (ECC, UE, MS, HS)
- [BS_03_Semesters](./BS_03_Semesters/3-Semesters_README.md): Set semesters (Year-Long, Semester, Quarters)
- [BS_04_Templates](./BS_04_Templates/4-Templates_README.md): Create cotainers for Departments
- [BS_05_Offerings](./BS_05_Offerings/5-Offerings_README.md): Set all active courses for the current term
- [BS_06_Sections](./BS_06_Sections/6-Sections_README.md): Set all active sections for courses (e.g. A, B, C... Blocks)
- [BS_07_Users_Students](./BS_07_Users_Students/7-Users_students_README.md): Create all student accounts (grades 5-12)
- [BS_07_Users_Teachers](./BS_07_Users_Teachers/7-Users_teachers_README.md): Create all staff accounts (all staff with SIS Access)
- [BS_08_Enrollments_Students](./BS_08_Enrollments_Students/8-Enrollments_students_README.md): Enroll students in courses and sections
- [BS_08_Enrollments_Teachers](./BS_08_Enrollments_Teachers/8-Enrollments_Teachers_README.md): Enroll teachers in courses and sections

## Basic PowerQuery Plugin Structure

Plugins must be zipped such that the `plugin.xml` file is at the root of the structure with no top level folder.

```
|
+-- plugin.xml
|
+-- queries_root
    |
    *-- partner.module1.named_queries.xml
    *-- partner.module2.named_queries.xml
+-- permissions_root
    |
    *-- partner.module1.permission_mappings.xml
    *-- partner.module2.permission_mappings.xml
+-- MessageKeys
    |
    *-- example-plugin-message-keys.US_en.properties
+-- web_root
    |
    *-- admin
        |
        *-- home.partner.content.footer.txt
```

## `plugin.xml`

Defined in `./plugin.xml`. See [Plugin XML Article](https://support.powerschool.com/developer/#/page/plugin-xml). This file defines the name, version number, description and contact information for the plugin.

### `plugin`

`xmlns`: defines the namespace of the tags that are acceptible in this plugin

example: `xmlns="http://plugin.powerschool.pearson.com"`

`description`: Human readable description that will appear in plugin manager screen

example: `description="example plugin"`

`xmlns:xsi`: scheme to validate this XML document agains

example: `xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`

`version`: Version number of plugin. Must consist entirely of charset [0-9.].

example: `version="1.0.2.22`

`xsi:schemaLocation`:  Schema document, plugin.xsd, against which to validate the XML document for the target namespace http://plugin.powerschool.pearson.com.

example: `xsi:schemaLocation="http://plugin.powerschool.pearson.com plugin.xsd"`

### publisher

Plublisher contact information displayed in plugin manager screen.

`name`: Publisher or Plublishing organization name

example: `name="Monty Python`

`contact email`: email contact for publisher

example: `<contact email=mpython@host.tld`/> 

sample:
```
<plugin xmlns="http://plugin.powerschool.pearson.com"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		description="Powerquery Example"
		name="PowerQuery Example (Birthdays)"
		version="1.0"
		xsi:schemaLocation="http://plugin.powerschool.pearson.com plugin.xsd">
		
	<publisher name="Your/Org Name">
		<contact email="contact@host.tld"/>
	</publisher>
	
</plugin>
```

## `[name].named_queries.xml`

Defined in `./queries_root/[name].named_queries.xml`. See [PowerSchool Article](https://support.powerschool.com/developer/#/page/powerqueries). This file defines the query and resultant returned columns displayed in Data Export Manager.

### `query`

Basic format:

```
    <query name="[tld].[domain].[product name].[general data area].[name of data]" coreTable="table" flattened="false"> ... </query>
```

`name`: Used for identifying plugin in DEM and other menues

[tld].[domain].[product name].[general data area].[name of data]

example: `com.txoof.brightspace.students.userinfo`

`coreTable`: STUDENTS, CC, etc.

`flattened`: The flattened does not group fields by tables and displays all the fields in the same level.

### description

Human readable description of query

Basic format:

```
    <description>Description here</description>
```

### `columns`

This is the table and column name that the argument will be compared against. The `<column name=>` attribute must match a known table.field for all columns. The number of `<column>` tags must exactly match the number of columns returned by the SQL query. For calculated columns that do not match a known table.field, use any known column such as `STUDENTS.ID`. The column order must match the order of the columns returned by the SQL query.

Basic format:

```
    <columns>
        <column name="TABLE.Field">dem_name</column>
    </columns>
```
`column`: one column tag for each column returned by SQL query below

`name`: known TABLE.FIELD

`dem_name`: Data Export Manager column header. This will be displayed in the DEM configuration screen.

### sql

SQL query to run against the database. Always include an `ORDER BY`. Calculated fields are acceptable, but must be aliased. Each column returned by the query must match a `<column>` tag above.

Basic format:

```
        <![CDATA[
            SELECT
                student_number,
                lastfirst,
                grade_level
                lastfirst||grade_level as name_grade
            FROM
                students
            WHERE
                enroll_status = 0
            ORDER BY lastfirst
        ]]>
    </sql>
```

## `[name].permission_mappings.xml`

Sets access permissions for this query plugin. See this [blog post](https://cookbrianj.wordpress.com/2017/01/23/plugin-export-with-ps-dem/).

```
<permission_mappings>
    <!--Anyone that has access to the following page can run this query-->
    <permission name='/admin/home.html'>
        <!--.../query/BASE_PLUGIN should be identical to `name` in named_queries.xml-->
        <implies allow="post">/ws/schema/query/BASE_PLUGIN</implies>
    </permission>
</permission_mappings>
```
