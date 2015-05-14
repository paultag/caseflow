-- MPR / MPR2 - Post Remand Proccessing Times

WITH cases AS (
	SELECT
		brieff.bfddec,
		brieff.bfcorlid,
		brieff.bfac,
		folder.tidrecv,
		brieff.bfddec - folder.tidrecv AS receive_to_decision,
		to_char(brieff.bfddec, 'MM/YY') AS month_of_decision
	FROM
		brieff,
		folder
	WHERE
		(brieff.bfkey = folder.ticknum) AND
	    (brieff.bfddec BETWEEN to_date(:start_date, 'MM/DD/YY') AND to_date(:end_date, 'MM/DD/YY')) AND
	    (brieff.bfac = '3') AND
	    (brieff.bfdc BETWEEN '1' AND '9')
)

SELECT
	cases.month_of_decision AS "Month",
	count(cases.bfddec) AS "Decisions Dispatched",
	to_char(avg(cases.receive_to_decision), '9999.99') AS "Recipt to BVA Decision (days)"
FROM cases
WHERE cases.receive_to_decision > 0
GROUP BY cases.month_of_decision
ORDER BY cases.month_of_decision ASC