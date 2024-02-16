<!-- omit in toc -->
# Brightspace D2L User and Enrollments (7-8)

PowerQuery plugin for exporting information from PowerSchool and importing to Brightspace.

- [Important Implementation Notes](#important-implementation-notes)
- [Brightspace User Details](#brightspace-user-details)
- [Data Export Manager Setup](#data-export-manager-setup)
  - [Creating New Jobs](#creating-new-jobs)
- [User Queries](#user-queries)
  - [7 Users - Guardians](#7-users---guardians)
  - [7 Users - Teachers](#7-users---teachers)
  - [7 Users - Students](#7-users---students)
- [User Enrollments](#user-enrollments)
  - [8 - Enrollments Guardians](#8---enrollments-guardians)
  - [8 - Enrollments Teachers](#8---enrollments-teachers)
  - [8 - Enrollments Students](#8---enrollments-students)

## Important Implementation Notes

Birghtspace IPSIS  processes CSV files in alphabetical order. For some tasks, it is important that that the files are processed in a particular order. For example, parent accounts must exist prior to the creation of students that reference parent org_defined_id in the `relationship` column. If the parent is referenced, but does not exist, the student account will not be created and the row will be skipped.

In all cases in this documentation, the CSV filename is specified and includes the processing order (see example below). 

```text
# IPSIS will process in this order
7-Users_201_students_active-%d.csv          #first
8-Enrollments_100_teachers-%d.csv           #second
8-Enrollments_101_teachers_school-%d.csv    #third
```

## Brightspace User Details

Brightspace user accounts are created following the [IPSIS V2.0 standard](https://community.d2l.com/brightspace/kb/articles/5972-prepare-csv-files-using-the-d2l-standard-csv-format). 

<!-- omit in toc -->
#### Sample User CSV
| type | action | username            | org_defined_id | first_name | last_name | password | is_active | role_name | email               | relationships                     | pref_first_name | pref_last_name |
|------|--------|---------------------|----------------|------------|-----------|----------|-----------|-----------|---------------------|-----------------------------------|-----------------|----------------|
| user | UPDATE | jsmith       | T_234654       | John       | Smith     |          | 1         | Teacher   | jsmith@ash.nl       |                                   |                 |                |
| user | UPDATE | cbantham2022@ash.nl | S_776452       | Carol      | Bantham   |          | 0         | Learner   | cbantham2022@ash.nl | Auditor:T_234654\|Parent:P_556341 | Abby            |                |
| user | UPDATE | amohamud@mail.foo   | P_556341       | Ali        | Mohamud   |          | 1         | Parent    | amohamud@mail.foo   |                                   |                 |                |               |                |

<!-- omit in toc -->
#### username

* Parents: contact email address
* Students: @ash.nl email address
* Staff & Teachers: username portion of email address
  - this was done to avoid collisions for staff members that used their @ash.nl address as their guardian contact email address

<!-- omit in toc -->
#### org_defined_id

* Parents: `guardianstudent.guardianid`
* Students: `students.student_number``
* Staff & Teachers: `users.teachernumber`

<!-- omit in toc -->
#### email

* Parents: `emailaddress.emailaddress` (provided by Contacts)
* Students: `emailaddress.emailaddress` (provided by Contacts)
* Staff & Teachers: `users.emailaddress`

<!-- omit in toc -->
#### pref_first_name

* Parents: None
* Students: any name provided within literal parenthesis "(prefered name)" in `students.middle_name` 
* Staff & Teachers: None

<!-- omit in toc -->
#### relationship

The `relationship` field provides additional access for the user listed in the row. Adding the guardian `org_defined_id` to this field will provide parents additional access to student data (e.g. student progress, grades). 

* Parents: None needed
* Students: Auditors, Parents (as of Plugin V2.00.00.20231030 not enabled)
  * To enable Brightspace Guardian app see [Student-Parent Relationships](#student-parent-relationships)

## Data Export Manager Setup

All queries are exported through the PowerSchool [Data Export Manager (DEM)](https://powerschool.ash.nl/admin/datamgmt/exportmanager.action). All jobs conform to the pattern below. The format *Export File Name* is very important as it influences the order in which D2L processes the files. In some cases, the order in which the files are processed is critical.

### Creating New Jobs

Begin on the [DEM page](https://powerschool.ash.nl/admin/datamgmt/exportmanager.action) on the *Export* tab:

- **Category**: Show All
- **Export From**: NQ - com.txoof.brightspace.enroll.[Name of Query -- See Below] 

Use the field menu on the left to select all columns (see Example 1). Change the labels on the exported columns to remove the table portion of the name (see Example 2). Click *Next>* to move forward.

**Example 1**

![](../documentation/DEM_01.png)

**Example 2**

![](../documentation/DEM_02.png)

On the *Select/Edit Records from...* screen, use the following settings:
- ◉ Export All Rows

On the *Export Summary and Output Options* screen, use the following settings:

**Export Format**

- **Export File Name**: see the relevant query below for exact filename
- **Line Delimiter**: LF
- **Filed Delimiter**: Comma
- **Character Set**: UTF-8

**Export Options**

- **Include Column Headers**: ☑

Save the template using the *Save Template* button.

On the *Save Export Template* screen use the following settings:
- **Name**: see the relevant query below for the exact name
- **Description**: see the relevant query below for the description

Use *Save as New* to save the template

## User Queries

### 7 Users - Guardians

Provides access accounts for guardians of students. Only contacts that display the *Data Access = True* in Powerschool are selected. **Note**: the data access status is displayed as a green checkmark in the *Manage Contacts* interface. 
![](../../documentation/PS_has_data_access.png).

Guardians must always be created prior to students to prevent a condition where new, non existent guardian appears in a student `relationship` field. In this case, the student account will fail to be created because the relationship can not be established due to the non-existent user.

<!-- omit in toc -->
#### Guardian Queries

**Inactive**

Description: Guardians with [Data Access = True](#7-users-guardians) that have zero active students are considered *inactive*. Inactive guardians are first set as *inactive* and then deleted after a fixed period (currently 30 days).

PQ File: [c07_u_g_inactive.named_queries.xml](./queries_root/c07_u_g_inactive.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.users.c07g_inactive`
* **Export File Name**: 7-Users_000_guardians_inactive-%d.csv
* **Template Name**: D2L 07-Users Guardians Inactive
* **Template Description**: Updated: YYYY/MM/DD [your initials]

**Active**

Description: Guardians with [Data Access = True](#7-users-guardians) that have one or more active students are considered *active*. Active guardians are created using their guardian ID and contact email address from PowerSchool. See [Brightspace User Details](#brightspace-user-details).

PQ File: [c07_u_g_active.named_queries.xml](./queries_root/07_u_g_active.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.users.c07g_active`
* **Export File Name**: 7-Users_001_guardians_active-%d.csv
* **Template Name**: D2L 07-Users Guardians Active
* **Template Description**: Updated: YYYY/MM/DD [your initials]

### 7 Users - Teachers

Provides access accounts for all ASH Staff. This includes every staff member that appears in PowerSchool including support staff, teachers, long-term subs and TAs.

Teachers must always be created prior to students to prevent a condition where new, non existent teacher appears in a student `relationship` field. In this case, the student account will fail to be created because the relationship can not be established due to the non-existent user.

<!-- omit in toc -->
#### Teacher Queries

**Inactive**

Description: Deactivates staff that is no longer working at ASH

PQ File: [c07_u_t_inactive.named_queries.xml](./queries_root/c07_u_t_inactive.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.users.c07t_inactive`
* **Export File Name**: 7-Users_100_guardians_inactive-%d.csv
* **Template Name**: D2L 07-Users Teachers Inactive
* **Template Description**: Updated: YYYY/MM/DD [your initials]

**Active**

Description: Creates Brightspace accounts for all staff members (including support and non-teaching staff)

PQ File: [c07_u_t_active.named_queries.xml](./queries_root/c07_u_t_active.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.users.c07t_active`
* **Export File Name**: 7-Users_101_guardians_active-%d.csv
* **Template Name**: D2L 07-Users Teachers Active
* **Template Description**: Updated: YYYY/MM/DD [your initials]


### 7 Users - Students

Provides access accounts for students in grades 5+. Students must always be created after guardians and teachers. Student rows may include the `org_defined_id` of guardians and teachers in the `relationship` field. If a student is created prior to the existence of a guardian or teacher that is specified in the relationship field, the creation will fail.

<!-- omit in toc -->
#### Student Queries

**Inactive**

Description: Removes inactive students from Brightspace

PQ File: [c07_u_s_inactive.named_queries.xml](./queries_root/c07_u_s_inactive.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.users.c07s_inactive`
* **Export File Name**: 7-Users_200_students_inactive-%d.csv
* **Template Name**: D2L 07-Users Students Inactive
* **Template Description**: Updated: YYYY/MM/DD [your initials]

**Active**

Description: Adds active students to Brightspace and builds *Auditor* relationships with LSC, EAL, Special Ed teachers.

PQ File: [c07_u_s_active.named_queries.xml](./queries_root/c07_u_s_active.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.users.c07s_active`
* **Export File Name**: 7-Users_201_students_active-%d.csv
* **Template Name**: D2L 07-Users Students Active
* **Template Description**: Updated: YYYY/MM/DD [your initials]

**Active with Guardians**

Description: Adds active students to Brightspace; builds *Auditor* relationship with LSC, EAL, Special Ed teachers; adds *Parent* relationship so guardians can view student progress.

PQ File: [c07_u_s_active_guardians.named_queries.xml](./queries_root/c07_u_s_active_guardians.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.users.c07s_active_guardians`
* **Export File Name**: 7-Users_201_students_active_guardians-%d.csv
* **Template Name**: D2L 07-Users Students Active w/ Guardians
* **Template Description**: Updated: YYYY/MM/DD [your initials]

## User Enrollments

User enrollments connect users with their courses. Enrollments must always occur after user creation.

It is important to run course drops prior to enrollments. This protects against situations when students are added to a course dropped from a course, and then added again.

### 8 - Enrollments Guardians

Guardian enrollments add parents to student courses in a special read-only role with limited access. Parents can only see content. Additionally, guardians are enrolled in a parallel school OU as `learner`. This allows Intelligent Agents to act upon these users.

<!-- omit in toc -->
#### Guardian Enrollment Queries & DEM Setup

**Drop**

Drop guardians from student courses.

PQ File: [c08_e_g_drop.named_queries.xml](./queries_root/c08_e_g_drop.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_guardian_drop`
* **Export File Name**: 8-Enrollments_000_guardians_auditor_drop-%d.csv
* **Template Name**: D2L 08-Enrollment Guardians Auditor Drop
* **Template Description**: Updated: YYYY/MM/DD [your initials]


**Enroll**

Enroll guardians in student courses.

PQ File: [c08_e_g.named_queries.xml](./queries_root/c08_e_g.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_guardian_enroll`
* **Export File Name**: 8-Enrollments_001_guardians_auditor_enroll-%d.csv
* **Template Name**: D2L 08-Enrollment Guardians Auditor
* **Template Description**: Updated: YYYY/MM/DD [your initials]

**Enroll in School as Learners**

Enroll guardians as `learner` in parallel guardian schools

PQ File: [c08_e_g_school_learners.named_queries.xml](./queries_root/c08_e_g_school_learners.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_guardian_schl_lrnr`
* **Export File Name**: 8-Enrollments_002_guardians_school_learner_enroll-%d.csv
* **Template Name**: D2L 08-Enrollment Guardians School
* **Template Description**: Updated: YYYY/MM/DD [your initials]

### 8 - Enrollments Teachers

Teacher enrollments add teachers to courses and schools. Learner Support teachers are added as auditors of specific students.

<!-- omit in toc -->
#### Teacher Enrollment Queries & DEM Setup

**Enroll**

Enroll teachers in courses.

PQ File: [c08_e_t.named_queries.xml](./queries_root/c08_e_t.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_teacher_enroll`
* **Export File Name**: 8-Enrollments_100_teachers-%d.csv
* **Template Name**: D2L 08-Enrollment Teachers
* **Template Description**: Updated: YYYY/MM/DD [your initials]

**Enroll in School**

Enroll teachers into appropriate school using `U_SCHOOLSTAFFUSERFIELDS.BRIGHTSPACE_ACCOUNT_TYPE`. This sets specific roles within a school such as `Auditor` or `Teacher`. See this [admin help article](https://lms.ash.nl/d2l/le/lessons/7908/units/4237) for more information.

PQ File: [c08_e_t_school.named_queries.xml](./queries_root/c08_e_t_school.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_teacher_school`
* **Export File Name**: 8-Enrollments_101_teachers_school-%d.csv
* **Template Name**: D2L 08-Enrollment Teachers School
* **Template Description**: Updated: YYYY/MM/DD [your initials]

**Enroll in LS School**

Enroll Learner Support teachers (EAL, Learning Support, Special Education) in special Learning Support school. This helps build infrastructure for auditing students by pushing them to the 6606 landing page where they can access the Auditing tool in Brightspace.

PQ File: [c08_e_t_ls_school.named_queries.xml](./queries_root/c08_e_t_ls_school.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_teacher_ls_school`
* **Export File Name**: 8-Enrollments_102_teachers_ls_auditors-%d.csv
* **Template Name**: D2L 08-Enrollment Teachers Auditors
* **Template Description**: Updated: YYYY/MM/DD [your initials]

**Enroll in ASH101**

Enroll teachers in the appropriate sections of ASH101. ASH101 is a course in Brightspace that provides instructions that are tailored to their division.

PQ File: [c08_e_t_ash101.named_queries.xml](./queries_root/c08_e_t_ash101.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_teacher_ash101`
* **Export File Name**: 8-Enrollments_103_teachers_ash101-%d.csv
* **Template Name**: D2L 08-Enrollment Teachers ASH101
* **Template Description**: Updated: YYYY/MM/DD [your initials]

----
### 8 - Enrollments Students

Add/drop students as `learner` in their registered courses. **It is absolutely imperative** that counselors/registrars do not set drop dates in PowerSchool prior to the first day of classes. Any records with dates set prior to the first day of classes is dropped entirely from the PowerSchool database; there is no way for Brightspace to track these drops.

<!-- omit in toc -->
#### Student Enrollment Queries & DEM Setup

**Drop**

Drop students from courses

PQ File: [c08_e_s_drop.named_queries.xml](./queries_root/c08_e_s_drop.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_s_drop`
* **Export File Name**: 8-Enrollments_200_students_drop-%d.csv
* **Template Name**: D2L 08-Enrollment Students Drop
* **Template Description**: Updated: YYYY/MM/DD [your initials]


**Enroll Students in School**

Enroll students in appropriate school.

PQ File: [c08_e_s_school.named_queries.xml](./queries_root/c08_e_s_school.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_student_school`
* **Export File Name**: 8-Enrollments_201_students_school-%d.csv
* **Template Name**: D2L 08-Enrollment Students School
* **Template Description**: Updated: YYYY/MM/DD [your initials]

**Enroll in Courses**

Enroll students in in courses as `learner`

PQ File: [c08_e_s.named_queries.xml](./queries_root/c08_e_s.named_queries.xml)

* **Named Query (NQ)**: `com.txoof.brightspace.enroll.c08_students`
* **Export File Name**: 8-Enrollments_202_students_enroll-%d.csv
* **Template Name**: D2L 08-Enrollment Students Courses
* **Template Description**: Updated: YYYY/MM/DD [your initials]