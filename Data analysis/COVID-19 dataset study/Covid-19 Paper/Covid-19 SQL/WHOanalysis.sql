<<<<<<< HEAD
<<<<<<< HEAD
/*Having done the ETL, the remaining clean data is used to calculate the Lethality (Lethality) and Recovery Rate (RecoveryR) of each WHO (world health organization) region.
Several concussions can be drawn from these numbers, which are detailed in the documentation provided with this query.
Lethality is defined as: Lethality = Total Deaths / Total confirmed cases.
Recovery Rate is defined as: Total Recovered / Total cases confirmed. */

SELECT WHO, SUM(Confirmed) AS Confirmed, SUM(Death) AS Death, SUM(Recovered) AS Recovered, SUM(Active) AS Active,
FORMAT(SUM(Death)/(SELECT SUM(Confirmed)*1.0),'P') AS Lethality, FORMAT(SUM(Recovered)/(SELECT SUM(Confirmed)*1.0),'P') AS RecoveryR
FROM Covid19TB
GROUP BY WHO
ORDER BY Death desc

=======
/*Having done the ETL, the remaining clean data is used to calculate the Lethality (Lethality) and Recovery Rate (RecoveryR) of each WHO (world health organization) region.
Several concussions can be drawn from these numbers, which are detailed in the documentation provided with this query.
Lethality is defined as: Lethality = Total Deaths / Total confirmed cases.
Recovery Rate is defined as: Total Recovered / Total cases confirmed. */

SELECT WHO, SUM(Confirmed) AS Confirmed, SUM(Death) AS Death, SUM(Recovered) AS Recovered, SUM(Active) AS Active,
FORMAT(SUM(Death)/(SELECT SUM(Confirmed)*1.0),'P') AS Lethality, FORMAT(SUM(Recovered)/(SELECT SUM(Confirmed)*1.0),'P') AS RecoveryR
FROM Covid19TB
GROUP BY WHO
ORDER BY Death desc

>>>>>>> 5283e5bff068fcedd001e66bd59faf05b8f0d577
=======
/*Having done the ETL, the remaining clean data is used to calculate the Lethality (Lethality) and Recovery Rate (RecoveryR) of each WHO (world health organization) region.
Several concussions can be drawn from these numbers, which are detailed in the documentation provided with this query.
Lethality is defined as: Lethality = Total Deaths / Total confirmed cases.
Recovery Rate is defined as: Total Recovered / Total cases confirmed. */

SELECT WHO, SUM(Confirmed) AS Confirmed, SUM(Death) AS Death, SUM(Recovered) AS Recovered, SUM(Active) AS Active,
FORMAT(SUM(Death)/(SELECT SUM(Confirmed)*1.0),'P') AS Lethality, FORMAT(SUM(Recovered)/(SELECT SUM(Confirmed)*1.0),'P') AS RecoveryR
FROM Covid19TB
GROUP BY WHO
ORDER BY Death desc

>>>>>>> 5283e5bff068fcedd001e66bd59faf05b8f0d577
SELECT * FROM Covid19TB