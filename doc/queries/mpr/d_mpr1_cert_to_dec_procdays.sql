-- MPR / MPR1 - Original Appeals Processing Times

WITH cases as (
	SELECT
		brieff.bfd19,
	    brieff.bf41stat,
	    folder.tidrecv,
	    folder.tidrecv - brieff.bf41stat AS cert_to_receive,
    	brieff.bfddec,
	    brieff.bfddec - brieff.bf41stat AS cert_to_decision,   
	    to_char(brieff.bfddec, 'MM/YY') AS month_of_decision
	FROM 
		brieff,
	    folder
	WHERE 
		(brieff.bfkey = folder.ticknum) AND  
	    (brieff.bfddec BETWEEN to_date(:start_date, 'MM/DD/YY') AND to_date(:end_date, 'MM/DD/YY')) AND
	    (brieff.bfac = '1') AND  
	    (brieff.bfdc BETWEEN '1' AND '9')
)

SELECT
	cases.month_of_decision AS "Month",
	count(cases.bfddec) AS "Original Decisions",
	to_char(avg(cases.cert_to_receive), '9999.99') AS "Cert to BVA Recv (days)",
	to_char(avg(cases.cert_to_decision), '9999.99') AS "Cert to Decision (days)"
FROM cases
WHERE
	cases.cert_to_receive > 0 AND
	cases.cert_to_decision > 0
GROUP BY cases.month_of_decision
ORDER BY cases.month_of_decision ASC