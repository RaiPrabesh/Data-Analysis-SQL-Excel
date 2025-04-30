# Cybersecurity Incident Analysis in India, China, and the USA (2015-2024)

## Overview
![Project Overview](https://via.placeholder.com/800x300)

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
    * Columns with spaces in their names were renamed to use "_" instead, for SQL Developer compatibility.
    * Unnecessary columns were removed, and three CSV files were created: country\_log.csv, Industry\_Attack\_Source.csv, and Security\_Defense\_log.csv.
    * The three CSV files were imported into SQL Developer.
    * In SQL Developer, the following import steps were used:
        * Right-click on the database table and select "Import Data".
        * In the Data Import Wizard, the data location was selected using "Browse".
        * The option to include the header row was selected.
        * The import method was set to "Insert," a table name was provided, and all rows were selected for import.
    * Primary keys were assigned as follows:
        * For the COUNTRYLIST table, INCIDENT\_KEY was set as the primary key.
        * For the DEFENSELOG and INDUSTRYLIST tables, INCIDENT\_KEY, SECURITY\_VULNERABILITY\_TYPE, and TARGET\_INDUSTRY were set as primary keys, respectively.
    * Foreign key constraints were created with cascade delete options.

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
* DDoS attacks caused the highest financial impact in the USA.
* In India, SQL Injection caused the highest financial impact, while in China, Ransomware and DDoS attacks had a comparable impact.
* The USA experienced the highest overall financial impact from cyberattacks, totaling $14,812.12 million, compared to India and China.

### Problem Statement and Hypothesis 2
* The data reveals no consistent similarities in incident resolution times across India, China, and the USA when considering both security vulnerability type and defense mechanism.
* After analyzing the average resolution time for "Unpatched Software" and "Social Engineering" in each country, the resolution times differed by country for each vulnerability type.
* In some countries, "Social Engineering" incidents had shorter resolution times, while in others, they were longer than those involving "Unpatched Software."
* However, when averaging the overall resolution times for "Social Engineering" and "Unpatched Software" across all defense mechanisms and the three countries, "Social Engineering" incidents tended to have shorter resolution times than "Unpatched Software" incidents.

### Problem Statement and Hypothesis 3
* Across India, China, and the USA, the IT industry consistently faces high incident frequencies, while Retail is a top target in the USA and India but slightly less in China, partially supporting our hypothesis.
* In terms of financial loss, the IT and Retail sectors experience the most significant impact across all three countries.
* Therefore, while Retail's targeting frequency varies slightly by country, both IT and Retail are key areas of concern for cybersecurity incidents and financial repercussions in these major economies.
* The Education sector also shows high targeting frequency, particularly in China.

### Problem Statement and Hypothesis 4
* The data does not strongly support our hypothesis of a positive correlation between financial impact and the numbers of affected users across India, China and the USA.
* The correlation is weak and positive in the USA and China , and slightly negative in India , indicating a minimal linear relationship overall.

## Visualizations

[You can add images or links to your visualizations here. For example:]

* Bar Chart: Financial Impact by Attack Type and Country
    * * Scatter Plot: Correlation between Financial Impact and Affected Users
    * * Dot Plot: Average Resolution Time by Vulnerability Type and Country
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
