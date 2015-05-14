-- MPR / MPR5 - Remands Returned not Activated

WITH cases AS (
	SELECT
		brieff.bfcorlid,
		brieff.bfmpro,
		brieff.bfdmcon,
		brieff.bfms,
		brieff.bfhr,
		brieff.bfha,
		folder.tisubj2,
		folder.tivbms,
		sysdate - bfdmcon AS mail_control_to_now,
		CASE
			WHEN sysdate - bfdmcon > 60
			THEN 1
			ELSE 0
		END AS over_60,
		CASE
			WHEN folder.tisubj2 = 'Y' OR folder.tivbms IN ('Y', '1', '0')
			THEN 'Paperless'
			ELSE 'Hardcopy'
		END AS case_type
	FROM
		brieff,
		folder
	WHERE
		(brieff.bfkey = folder.ticknum) AND
		(brieff.bfmpro = 'REM') AND
		(brieff.bfdmcon >= brieff.bfddec)
)

SELECT
	cases.case_type as "Type",
	count(cases.bfcorlid) AS "Remands Returned",
	to_char(avg(cases.mail_control_to_now), '9999.99') AS "Average Days Pending",
	sum(cases.over_60) AS "Pending Over 60 Days",
	count(nullif(cases.over_60, 1)) AS "Pending Under 60 Days"
FROM cases
GROUP BY cases.case_type
ORDER BY cases.case_type ASC