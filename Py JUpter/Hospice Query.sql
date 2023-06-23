select * from dbo.diagnosis_Table
select * from dbo.['Invoice_Table']
select * from dbo.['Viiting Details Table$']

---Joining the three tables as one
SELECT v.VisitCode, v.PatientCode, v.VisitDateTime, v.MedicalCenter, v.VisitCategory, v.Payor, v.[NPS Score], d.Diagnosis, i.Amount
FROM ['Viiting Details Table$'] AS v
JOIN dbo.diagnosis_Table AS d ON v.VisitCode = d.VisitCode
JOIN ['Invoice_Table'] AS i ON v.VisitCode = i.VisitCode;

---The most Commonly Diagnosis done (From the Diagnosis Table Alone)
SELECT TOP 5 Diagnosis, COUNT(*) AS DiagnosisCount
FROM dbo.diagnosis_Table
GROUP BY Diagnosis
ORDER BY DiagnosisCount DESC;



---The most Commonly Diagnosis done (From the combined Table)
SELECT TOP 5 Diagnosis, COUNT(*) AS DiagnosisCount
FROM (
    SELECT d.Diagnosis
    FROM ['Viiting Details Table$'] v
    JOIN dbo.diagnosis_Table AS d ON v.VisitCode = d.VisitCode
    JOIN ['Invoice_Table'] AS i ON v.VisitCode = i.VisitCode
) AS combined_table
GROUP BY Diagnosis
ORDER BY DiagnosisCount DESC;


---How may Visits are associated with each diagnosis?
SELECT d.Diagnosis, COUNT(*) AS VisitCount
FROM ['Viiting Details Table$'] v
JOIN dbo.diagnosis_Table AS d ON v.VisitCode = d.VisitCode
JOIN ['Invoice_Table'] AS i ON v.VisitCode = i.VisitCode
GROUP BY d.Diagnosis Desc;

---A breadown of Visits by Medical Center
SELECT v.MedicalCenter, COUNT(*) AS VisitCount
FROM ['Viiting Details Table$'] v
JOIN dbo.diagnosis_Table AS d ON v.VisitCode = d.VisitCode
JOIN ['Invoice_Table'] AS i ON v.VisitCode = i.VisitCode
GROUP BY v.MedicalCenter;

select* FROM ['Viiting Details Table$']


---Calculating the average invoice amount per visit.
SELECT AVG(i.Amount) AS AverageInvoiceAmount
FROM ['Viiting Details Table$'] v
JOIN dbo.diagnosis_Table AS d ON v.VisitCode = d.VisitCode
JOIN ['Invoice_Table'] AS i ON v.VisitCode = i.VisitCode


---Calculating the average invoice amount per visit in each medical center
SELECT v.MedicalCenter, AVG(i.Amount) AS AverageInvoiceAmount
FROM ['Viiting Details Table$'] v
JOIN dbo.diagnosis_Table AS d ON v.VisitCode = d.VisitCode
JOIN ['Invoice_Table'] AS i ON v.VisitCode = i.VisitCode
GROUP BY v.MedicalCenter;


---Identifying the top five payors based on the total invoice amount.
SELECT TOP 5 v.Payor, SUM(i.Amount) AS TotalInvoiceAmount
FROM ['Viiting Details Table$'] v
JOIN dbo.diagnosis_Table AS d ON v.VisitCode = d.VisitCode
JOIN ['Invoice_Table'] AS i ON v.VisitCode = i.VisitCode
GROUP BY v.Payor
ORDER BY TotalInvoiceAmount DESC;


---Identify any visits with a diagnosis of "acute bronchitis" and a high invoice amount (More than 5000 Shillings).

SELECT v.VisitCode, v.PatientCode, v.VisitDateTime, v.MedicalCenter, v.VisitCategory, v.Payor, v.[NPS Score], d.Diagnosis, i.Amount
FROM ['Viiting Details Table$'] v
JOIN dbo.diagnosis_Table AS d ON v.VisitCode = d.VisitCode
JOIN ['Invoice_Table'] AS i ON v.VisitCode = i.VisitCode
WHERE d.Diagnosis = 'acute bronchitis' AND i.Amount > 5000;

---Checking for Correlation
SELECT
    (SUM((v.[NPS Score] - nps_avg) * (i.Amount - amount_avg)) / (COUNT(*) - 1)) /
    (STDEV(v.[NPS Score]) * STDEV(i.Amount)) AS correlation_coefficient
FROM
    ['Viiting Details Table$'] v
JOIN
    ['Invoice_Table'] i ON v.VisitCode = i.VisitCode
CROSS JOIN
    (SELECT AVG(v.[NPS Score]) AS nps_avg, AVG(i.Amount) AS amount_avg
    FROM ['Viiting Details Table$'] v
    JOIN ['Invoice_Table'] i ON v.VisitCode = i.VisitCode) AS averages;


---Average Invoice Amount For In-Person Visits Per Medical Center
SELECT v.MedicalCenter, AVG(i.Amount) AS average_IN_Person_invoice_amount
FROM ['Viiting Details Table$'] v
JOIN ['Invoice_Table'] i ON v.VisitCode = i.VisitCode
WHERE v.VisitCategory = 'In-person Visit'
GROUP BY v.MedicalCenter;

---Average Invoice Amount For Telemedicine Visit Visits Per Medical Center

SELECT v.MedicalCenter, d.Diagnosis, AVG(i.Amount) AS average_Telemedicine_invoice_amount
FROM ['Viiting Details Table$'] v
JOIN ['Invoice_Table'] i ON v.VisitCode = i.VisitCode
JOIN [diagnosis_Table] AS d ON v.VisitCode = d.VisitCode
WHERE v.VisitCategory = 'Telemedicine Visit'
GROUP BY v.MedicalCenter, d.Diagnosis;

---Identifying Pattern and Trends Based on the Visting Date and Time
Select CONVERT(DATE, VisitDateTime) as visit_date, Count(*) as visit_count
from ['Viiting Details Table$']
Group by CONVERT(DATE, VisitDateTime)
Order by CONVERT(DATE, VisitDateTime);

----Splitting Date and Time Into Separate Columns
SELECT 
	CONVERT(DATE, VisitDateTime) as Visit_date,
	CAST(VisitDateTime as TIME) as visit_time,
	count(*) as Visit_count
from ['Viiting Details Table$']
Group by CONVERT(DATE, VisitDateTime), CAST( VisitDateTime as TIME)
Order by CONVERT(DATE, VisitDateTime), CAST( VisitDateTime as TIME);

---Getting the count Based on Hour of Visit
SELECT 
	CONVERT(DATE, VisitDateTime) as Visit_date,
	Datepart(Hour, VisitDateTime) as visiting_Hour,
	count(*) as Visit_count
from ['Viiting Details Table$']
Group by CONVERT(DATE, VisitDateTime), Datepart(Hour, VisitDateTime)
Order by CONVERT(DATE, VisitDateTime), Datepart(Hour, VisitDateTime);

---Regardless of the Day/Date which particuar Hour has the highest Number of Visitors?
SELECT
	Datepart(Hour, VisitDateTime) as visiting_Hour,
	count(*) as Visit_count
from ['Viiting Details Table$']
Group By Datepart(Hour, VisitDateTime)
Order By COUNT(*) DESC;

---Regardless of the Date which particuar Day of the week has the highest Number of Visitors?
SELECT
	Datepart(Weekday, VisitDateTime) as visiting_Day,
	count(*) as Visit_count
from ['Viiting Details Table$']
Group By Datepart(WEEKDAY, VisitDateTime)
Order By COUNT(*) DESC;

---How many "Acute Rhinis" Visits Are recorded?
SELECT v.VisitCode, v.MedicalCenter, v.VisitCategory, v.Payor,  d.Diagnosis
FROM ['Viiting Details Table$'] v
JOIN dbo.diagnosis_Table AS d ON v.VisitCode = d.VisitCode
Where d.Diagnosis = 'Acute rhinitis'
Order by MedicalCenter


---Total Invoive Amount of each Visit Category
Select v.visitcategory, sum(i.amount) as total_Amount
FROM ['Viiting Details Table$'] v
JOIN ['Invoice_Table'] i ON v.VisitCode = i.VisitCode
Group by v.VisitCategory;

---Total Invoice Amount Per Visit Category Each Month
Select v.visitcategory, 
	Datepart(Month, VisitDateTime) as visiting_Month,
	sum(i.amount) as total_Amount
FROM ['Viiting Details Table$'] v
JOIN ['Invoice_Table'] i ON v.VisitCode = i.VisitCode
Group by v.VisitCategory, Datepart(Month, v.visitDateTime);

