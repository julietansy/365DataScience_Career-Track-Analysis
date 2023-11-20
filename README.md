# Career Track Analysis
### Exploring Student Enrollments and Completions in Data-Related Career Tracks.

This case study is taken from 365datascience.com Career Track Analysis Project.

### **Case Description**

One of the functionalities the 365 company introduced in a 2021 platform release included the option for student enrollment in a career track. The tracks represent an ordinal sequence of courses that eventually lead to obtaining the skills for one of three job titles: data scientist, data analyst, or business analyst.

Completing a career track on the platform is a challenging task. To acquire a corresponding career certificate, a student must pass nine course exams (seven compulsory and two elective courses) and sit for a career track exam encompassing topics from all seven required courses.

In this Career Track Analysis with SQL and Tableau project, you’re tasked with **analyzing the career track enrollments and achievements of 365’s students.** You’ll first need to retrieve the necessary information from an SQL database. Afterward, you’ll feed this information to Tableau, visualize the results, and finally interpret them.

### **Raw Data**

The database, Source Data.sql, is located in the current repo to upload to MYSQL Workbench. It consists of 2 tables.

1. career_track_info
   
    **track_id** – the unique identification of a track, which serves as the primary key to the table
   
    **track_name** – the name of the track
  
3. career_track_student_enrollments
   
    **student_id** – the unique identification of a student
   
    **track_id** – the unique identification of a track. Together with the previous column, they make up the primary key to the table—i.e., each student can enroll in a specific track only once. But a student can enroll in more than one career track.
   
    **date_enrolled** – the date the student enrolled in the track. A student can enroll in more than one career track.
   
    **date_completed** – the date the student completed the track. If the track is not completed, the field is NULL.


