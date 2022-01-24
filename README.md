## Mountain Project - Climbing Community Website Analysis
* Written by: [Poon Athit S. ](https://www.linkedin.com/in/athit-srimachand/)
* Technologies: SQL Server, Tableau
## 1. Introduction
As a member in the climbing and mountaineering community (both in Thailand and UK), I have spent a lot of my time on Mountain Project website which is one of the largest websites about the climbing-related topics. It serves as a guidebook or climbing information database with more than 100k climbing routes across the globe. As a data analyst, this piques my curiosity about relationship between variety of climbing-related data from the website such as number of routes, route height, difficulty grades, etc. Therefore, this project aims to process the raw data in SQL Server and present the insights in [Tableau dashboard.](https://public.tableau.com/shared/74XPCMHWD?:display_count=n&:origin=viz_share_link) <br />
## 2. data manipulation in SQL
In this project, the raw data contain many issues that are required to be addressed with SQL data manipulation, as follows.
* A large amount of null values in multiple fields
* Improper decimal places and units
* Uninterpretable categorical data such as in Route_type field
* Outliers / errors such as impossible length, impossible number of pitches
* Duplicated records (As users may share the same route as others')
* Long field with separators (require to use STRING_SPLIT instead of the more user-friendly function: PARSENAME)
* Special conditions in Location field which its values are different when the route is in USA 
## 3. Tableau dashboard and key findings
[link](https://public.tableau.com/shared/74XPCMHWD?:display_count=n&:origin=viz_share_link) <br />
<img src="https://github.com/PoonAthitS/mountain-project-website-analysis/blob/main/Dashboard%20Mountain%20Project%20-%20Climbing%20Community%20Website%20Analysis.png?raw=true" width="800">


## 4. About the programming

### 4.1 Files

### 4.2 Data

### To learn more about Poon Athit S., visit his [LinkedIn profile](https://www.linkedin.com/in/athit-srimachand/)

All rights reserved 2022. All codes are developed and owned by Poon Athit S. or the metioned team member(s). If you use this code, please visit his LinkedIn and give him a skill endorsement in Data analytics and the aforementioned coding technologies.
