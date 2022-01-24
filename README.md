## Mountain Project - Climbing Community Website Analysis
* Written by: [Poon Athit S. ](https://www.linkedin.com/in/athit-srimachand/)
* Technologies: SQL Server, Tableau
## 1. Introduction
As a member in the climbing and mountaineering community (both in Thailand and UK), I have spent a lot of my time on Mountain Project website which is one of the largest websites about the climbing-related topics. It serves as a guidebook or climbing information database with more than 100k climbing routes across the globe. As a data analyst, this piques my curiosity about relationship between variety of climbing-related data from the website such as number of routes, route height, difficulty grades, etc. Therefore, this project aims to process the raw data in SQL Server and present the insights in [Tableau dashboard.](https://public.tableau.com/shared/74XPCMHWD?:display_count=n&:origin=viz_share_link) <br />
## 2. data manipulation in SQL
In this project, the raw data contain many issues that are required to be addressed with SQL data manipulation/transformation, as follows.
* A large amount of null values in multiple fields
* Improper decimal places and units
* Categorical data that are too varied to be analysed such as Route_type field
* Outliers / errors such as impossible length, impossible number of pitches
* Duplicated records (As users may share the same route as others')
* Long field with separators (require to use STRING_SPLIT instead of the more user-friendly function: PARSENAME)
* Special conditions in Location field which its values are different when the route is in USA 
## 3. Tableau dashboard and key findings
The database in SQL Server is then loaded to Tableau to develop an interactive dashboard: [Mountain Project - Climbing Community Website Analysis](https://public.tableau.com/shared/74XPCMHWD?:display_count=n&:origin=viz_share_link) as depicted in the image below.
<br /> <br />
<img src="https://github.com/PoonAthitS/mountain-project-website-analysis/blob/main/Dashboard%20Mountain%20Project%20-%20Climbing%20Community%20Website%20Analysis.png?raw=true" width="800">
<br /> <br />
The dashboard provides the key findings as follows: (for example)
* Most climbing routes are from the USA (Almost 80k routes), which is aligned with the fact this website is originated in the US
* The majority of climbing routes are around 15m with 5.9 Difficulty grade (from mode + trend)
* The satisfactions of the routes are decribed by voting stars which the trend shows that most common stars are 2.5 while the spikes support the reason that users are allowed to vote only in integer number.
* The satisfactions of the users to each routes have the possitive relationship to the length of route (longer = more people like); However, from the graph, not a many routes are long.
* Meanwhile, the more chanllenging routes (higher grade) also have more stars
* Many routes that specifies their difficulty grade unclearly (such as 5.10 instead of 5.10c) are the longer routes which are likely to be multi-pitch route due to the fact that it is harder to define the exact grade on the climbing with many pitches (climbign sections)

## 4. About the programming

### 4.1 Files
* Tableau dashboard is pulished in [Tableau public link](https://public.tableau.com/shared/74XPCMHWD?:display_count=n&:origin=viz_share_link)
* The data manipulation is perfomed by this [SQL query](https://github.com/PoonAthitS/mountain-project-website-analysis/blob/main/sql_query_mountain_project.sql)
### 4.2 Data
The Raw data are gather from [Kaggle Mountain Project dataset](https://www.kaggle.com/pdegner/mountain-project-rotues-and-forums) which is scraped from Mountain Project website in 2020 by Patricia. Please check out her [GitHub project](https://github.com/pdegner/MP_Sentiment_Analysis) which is about analyzing the sentiment of the forums on www.MountainProject.com to determine which climbing gear is thought to be the best

### To learn more about Poon Athit S., visit his [LinkedIn profile](https://www.linkedin.com/in/athit-srimachand/)

All rights reserved 2022. All codes are developed and owned by Poon Athit S. or the metioned team member(s). If you use this code, please visit his LinkedIn and give him a skill endorsement in Data analytics and the aforementioned coding technologies.
