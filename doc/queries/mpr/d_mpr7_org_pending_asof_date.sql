-- MPR / MPR7 - Originals Certified as of date

WITH cases AS (
	SELECT
		brieff.bfcurloc,
		brieff.bfmpro,
		brieff.bfregoff,
		brieff.bf41stat,
		brieff.bfdtb,
		brieff.bfha,
		brieff.bfhr,
		brieff.bfdocind,
		brieff.bfac,
		to_date(:start_date, 'MM/DD/YY') - brieff.bf41stat AS date_to_certified
	FROM brieff
	WHERE
		brieff.bfac = '1' AND 
		brieff.bf41stat <= to_date(:start_date, 'MM/DD/YY') AND
		(brieff.bfddec >= to_date(:start_date, 'MM/DD/YY') OR brieff.bfddec IS NULL)
)

SELECT
	cases.bfac AS "Type Action",
	count(bfmpro) AS "Certified",
	to_char(avg(cases.date_to_certified), '9999.99') AS "Average Days from Cert"
FROM cases
GROUP BY cases.bfac
ORDER BY cases.bfac ASC