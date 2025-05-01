# Cybersecurity Incident Analysis in India, China, and the USA (2015-2024)

## Overview
![Image](https://github.com/user-attachments/assets/358360a8-6bcf-4d77-b51f-090f5591fa5b)

This project analyzes cybersecurity incident data across India, China, and the USA from 2015 to 2024. The analysis uses SQL and Excel to investigate trends, identify key vulnerabilities, and assess the financial impact of cyberattacks. This project demonstrates my data analysis skills, including data cleaning, manipulation, visualization, and interpretation.

## Project Goals

The primary goals of this project are to:

1.  Determine the financial impact from different types of cyberattacks in India, China, and the USA.
    * **1st Problem Statement:** What are the trends in the frequency and financial impact of different types of Attack type in India, China, and the USA from 2015 to 2024?
    * **Hypothesis 1:** The USA has experienced a higher overall financial impact from cyberattacks compared to India and China from 2015 to 2024.
2.  Analyze the relationship between security vulnerability types and incident resolution times in India, China, and the USA.
    * **2nd Problem Statement:** Is there a similarity in incident resolution time caused by security vulnerability type and Defense mechanism used in India, China and the USA?
    * **Hypothesis 2:** Incidents involving “Social Engineering” as a vulnerability tend to have shorter resolution times across all three countries compared to those involving “Unpatched software”.
3.  Identify the most frequently targeted industries across the three countries.
    * **3rd Problem Statement:** Which Industries are the most frequently targeted and suffer the highest financial losses from cybersecurity threats in India, China and the USA?
    * **Hypothesis 3:** The “Retail” industry is among the top three most frequently targeted industries in all three countries. There is also a strong relation between Incident Frequency and Financial Loss.
4.  Examine the correlation between financial impact and the number of affected users due to cyberattacks.
    * **4th Problem Statement:** Is there any correlation between the severity of the financial impact and the number of affected users in cybersecurity incidents within India, China and the USA?
    * **Hypothesis 4:** Across India, China, and the USA there is a positive correlation between the financial impact and the affected users due to cyber-attack. In other word incidents with higher financial losses tend to impact a larger number of users.

## Data Sources

The data used in this project comes from:

* https://www.kaggle.com/datasets/atharvasoundankar/global-cybersecurity-threats-2015-2024

The data includes information on:

* Attack type
* Financial impact (in millions of dollars)
* Affected users
* Security vulnerability type
* Incident resolution time
* Defense mechanisms
* Industry
* Country
* Year

## Methods

The project employs a combination of SQL and Excel for data analysis:

* **SQL:** Used for data extraction, cleaning, filtering, and aggregation. The data was set up in SQL Developer with the following steps:

    * Data was sorted by country, and filtered to include only India, China, and the USA.
    * A unique incident key was created for each event.
    * Column types were checked and adjusted as needed (e.g., assigning columns as Numbers or Floats).
    * For floating-point numbers, decimal places were set to two.
    * In the Attack Type, Attack Source, Defense Mechanism Used, and Security Vulnerability Type columns, " - " was replaced with a space.
   * ![Image](https://github.com/user-attachments/assets/29059bdb-bce3-4981-9535-91509878a39e)
    * Columns with spaces in their names were renamed using the same step above to use "_" instead, for SQL Developer compatibility.
    * Unnecessary columns were removed, and three CSV files were created: country\_log.csv, Industry\_Attack\_Source.csv, and Security\_Defense\_log.csv.
  * ![Image](https://github.com/user-attachments/assets/9c09b442-04ae-4c85-ba2e-1b0baba4d360)
    * The three CSV files were imported into SQL Developer.
    * In SQL Developer, the following import steps were used:
        * Right-click on the database table and select "Import Data".
        * In the Data Import Wizard, the data location was selected using "Browse".
        * ![Image](https://github.com/user-attachments/assets/97788ab4-642f-4c72-94b0-e3967e6de9da)
        * The option to include the header row was selected.
        * The import method was set to "Insert," a table name was provided, and all rows were selected for import by unchecking Import Row Limit.
        * ![Image](https://github.com/user-attachments/assets/55425117-6632-4be3-839d-8c4ad33f56b9)
    * Primary keys were assigned as follows:
        * For the COUNTRYLIST table, INCIDENT\_KEY was set as the primary key.
        * ![Image](https://github.com/user-attachments/assets/73672a72-0441-4659-967f-cc22f9ac6da2)
        * For the DEFENSELOG and INDUSTRYLIST tables, INCIDENT\_KEY, SECURITY\_VULNERABILITY\_TYPE, and TARGET\_INDUSTRY were set as primary keys, respectively.
    * Foreign key constraints were created with cascade delete options.
    * ![Image](https://github.com/user-attachments/assets/de55c977-1f9c-4728-9e4c-7973820b6f62)

    The following SQL queries were then used for the analysis:

    * **1. Frequency trends by year, country, and attack type:**

        ```sql
        SELECT
            year, country, attack_type,
            COUNT(*) AS "Incident Frequency"
        FROM
            countrylist
        WHERE
            country IN ('India', 'China', 'USA')
            AND year BETWEEN 2015 AND 2024
        GROUP BY
            year, country, attack_type
        ORDER BY
            year, country, attack_type;
        ```

    * **2. Financial impact trends by year, country, and attack type:**

        ```sql
        SELECT
            year, country, attack_type,
            SUM(financial_loss_million) AS "Total Financial Impact"
        FROM
            countrylist
        WHERE
            country IN ('India', 'China', 'USA')
            AND YEAR BETWEEN 2015 AND 2024
        GROUP BY
            year, country, attack_type
        ORDER BY
            year, country, attack_type;
        ```

    * **3. Overall financial impact by country:**

        ```sql
        SELECT
            country,
            SUM(financial_loss_million) AS "Total Financial Impact"
        FROM
            countrylist
        WHERE
            year BETWEEN 2015 AND 2024
        GROUP BY
            country
        ORDER BY
            "Total Financial Impact" DESC;
        ```

    * **4. Relationship between vulnerability, defense, and resolution time:**

        ```sql
        SELECT
            cl.country,
            dl.security_vulnerability_type,
            dl.defense_mechanism_used,
            ROUND(AVG(cl.incident_resolution_hours), 2) AS "AVG resolution time"
        FROM
            countrylist cl
        JOIN
            defenselog dl ON cl.incident_key = dl.incident_key
        WHERE
            cl.country in ('India', 'China', 'USA')
        GROUP BY
            cl.country, dl.security_vulnerability_type, dl.defense_mechanism_used
        ORDER BY
            cl.country, dl.security_vulnerability_type, dl.defense_mechanism_used;
        ```

    * **5. Comparing resolution times for "Social Engineering" vs. "Unpatched Software":**

        ```sql
        SELECT
            cl.country,
            ROUND(
            AVG(CASE WHEN dl.security_vulnerability_type = 'Social Engineering'
                THEN cl.incident_resolution_hours END), 2)
                AS "AVG RT Social Engineering",
            ROUND(
            AVG(CASE WHEN dl.security_vulnerability_type = 'Unpatched Software'
                THEN cl.incident_resolution_hours END), 2)
                AS "AVG RT Unpatched Software"
        FROM
            countrylist cl
        JOIN
            defenselog dl
            ON cl.incident_key = dl.incident_key
        WHERE
            cl.country IN('India', 'China', 'USA')
        GROUP BY
            cl.country
        ORDER BY
            cl.country;
        ```

    * **6. Most frequently targeted industries by country:**

        ```sql
        SELECT
            cl.country, il.target_industry,
            COUNT(*) AS "Incident Frequency",
            ROUND(SUM(cl.financial_loss_million), 2) AS "Total Financial Loss"
        FROM
            countrylist cl
        JOIN
            industrylist il ON cl.incident_key = il.incident_key
        WHERE
            cl.country IN ('India', 'China', 'USA')
        GROUP BY
            cl.country, il.target_industry
        ORDER BY
            cl.country, "Total Financial Loss" DESC;
        ```

    * **7. Highest financial losses by industry by country:**

        ```sql
        SELECT
            cl.country, il.target_industry,
            ROUND(SUM(cl.financial_loss_million), 2) AS "Total Financial Loss"
        FROM
            countrylist cl
        JOIN
            industrylist il ON cl.incident_key = il.incident_key
        WHERE
            cl.country IN ('India', 'China', 'USA')
        GROUP BY
            cl.country, il.target_industry
        ORDER BY
            cl.country, "Total Financial Loss" DESC;
        ```

    * **8. Correlation between Financial impact and affected users by country:**

        ```sql
        SELECT
            country,
            ROUND(CORR(financial_loss_million, number_of_affected_users), 3)
            AS "Correlation_coefficient"
        FROM
            countrylist
        WHERE
            country IN ('India', 'China', 'USA')
        GROUP BY
            country;
        ```

    * **9. Actual data for Financial impact and affected users:**

        ```sql
        SELECT
            country, financial_loss_million AS "Loss In Million",
            number_of_affected_users As "Affected User Count"
        FROM
            countrylist
        WHERE
            country IN ('India', 'China', 'USA')
        ORDER BY
            country, "Loss In Million" DESC;
        ```

* **Excel:** Used for further data manipulation, visualization, and reporting. Key Excel techniques include:
    * Creating pivot tables to summarize data.
    * Generating charts (bar charts, scatter plots, dot plots) to visualize trends and relationships.
    * Calculating correlation coefficients.
    * Presenting findings clearly and concisely.

## Analysis Steps

### Problem Statement and Hypothesis 1
* The data has already been filtered for the period between 2015 and 2024, so further filtering by year was unnecessary.
* DDoS attacks caused the highest financial impact in the USA and China.
* In India, SQL Injection caused the highest financial impact.
* ![Image](https://github.com/user-attachments/assets/671c72bc-64a3-44c7-87bf-2d14cbf2873b)
* The USA experienced the highest overall financial impact from cyberattacks, totaling $14,812.12 million, compared to India and China.
* ![image](https://github.com/user-attachments/assets/30b12049-c744-4dc2-8dc4-3bf1f80e62a4)


### Problem Statement and Hypothesis 2
* The data reveals no consistent similarities in incident resolution times across India, China, and the USA when considering both security vulnerability type and defense mechanism.
* ![Image](https://github.com/user-attachments/assets/cf1e9c8c-dcd5-4252-aec8-045207f59517)
* After analyzing the average resolution time for "Unpatched Software" and "Social Engineering" in each country, the resolution times differed by country for each vulnerability type.
* ![Image](https://github.com/user-attachments/assets/1c6c4eab-bc09-4f38-88d1-749a82981814)
* In some countries, "Social Engineering" incidents had shorter resolution times, while in others, they were longer than those involving "Unpatched Software."
* However, when averaging the overall resolution times for "Social Engineering" and "Unpatched Software" across all defense mechanisms and the three countries, "Social Engineering" incidents tended to have shorter resolution times than "Unpatched Software" incidents.
* ![Image](https://github.com/user-attachments/assets/e10facc7-b4ad-4348-9ba4-e4e022fdc620)

### Problem Statement and Hypothesis 3
* In USA "Retail" industry is the most frequently targeted industry where IT industry is the most targeted in India and both IT and Education industries in China throughout the year.
* ![image](https://github.com/user-attachments/assets/743c4488-fc82-4204-8cd6-b52a7b35574b)
* In terms of financial loss, the IT and Retail sectors experience the most significant impact across all three countries.
* ![image](https://github.com/user-attachments/assets/95a118e9-778a-46ad-a6c1-9011d40b6551)
* Therefore, while Retail's targeting frequency varies slightly by country, both IT and Retail are key areas of concern for cybersecurity incidents and financial repercussions in these major economies.
* The Education sector also shows high targeting frequency, particularly in China and falls under top three frequently targeted industries with highest financial losses.
* ![image](https://github.com/user-attachments/assets/8b4d7bc4-62b6-4cfe-ba43-530d37552202)
* There is also a strong positive correlation between incident frequency and financial loss. As the number of incidents rises, the financial loss tends to increase significantly.
* ![image](https://github.com/user-attachments/assets/866e8a3b-be08-4f17-9d72-0e7908c85ff5)

### Problem Statement and Hypothesis 4
* The data does not strongly support our hypothesis of a positive correlation between financial impact and the numbers of affected users across India, China and the USA.
* ![image](https://github.com/user-attachments/assets/3063bc21-21a0-4c58-8453-595f2a9a9cc9)
* The correlation is weak and positive in the USA and China, and slightly negative in India, indicating a minimal linear relationship overall.
* ![Image](https://github.com/user-attachments/assets/45ea8980-e78e-4af0-9144-f80f65dc714a)


    * ## Project Structure

The repository is organized as follows:

    ├── data/
    │   ├── [Data files (e.g., CSV, Excel files, SQL dumps)]
    ├── sql/
    │   ├── [SQL scripts (e.g., create table statements, queries)]
    ├── excel/
    │   ├── [Excel files (e.g., analysis workbooks, reports)]
    ├── README.md
    └── LICENSE

## How to Use This Project

1.  **Clone the repository:** `git clone [repository URL]`
2.  **Set up the database:** [Provide instructions on how to set up the database, if applicable. If you're using a specific database system (e.g., MySQL, PostgreSQL), mention it here.]
    * **Run the SQL scripts:** Execute the SQL scripts in the `sql/` directory to create the database schema and populate it with data.
    * **Open the Excel files:** Open the Excel files in the `excel/` directory to view the data analysis and visualizations.

## Technical Skills Demonstrated

This project showcases the following technical skills:

* Data Acquisition and Cleaning
* Database Management (SQL)
* Data Manipulation and Analysis (SQL, Excel)
* Data Visualization (Excel)
* Statistical Analysis
* Report Writing and Communication

## Lessons Learned

Throughout this project, I learned:
* The importance of meticulous data cleaning.
* How to effectively use SQL for data extraction, filtering, and aggregation.
* How to leverage Excel for in-depth data manipulation and visualization.
* Techniques for statistical analysis, including calculating correlation coefficients.
* Best practices for communicating findings through clear and concise report writing.

## Future Improvements

* Further expand SQL skills, exploring advanced query techniques for deeper data insights.
* Enhance data visualization capabilities using Excel and Power BI to create more interactive and informative dashboards.
* Perform more advanced statistical analysis, including regression analysis and hypothesis testing, to draw stronger conclusions.
* Utilize Python and the Pandas library for more complex data manipulation and analysis.

## Author

* Prabesh Rai
* prai2023@outlook.com
* [Prabesh Rai LinkedIn Profile](https://www.linkedin.com/in/prabesh-raii/)

## License

This project is licensed under the MIT License. See the \`LICENSE\` file for more information.
