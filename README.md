# PowerSchool PowerQuery Plugins

## Basic Structure

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
