-- MPR / MPR6 - Certified Originals (ACT + ADV) days pending

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
		sysdate - brieff.bf41stat AS certified_to_now
	FROM brieff
	WHERE
		(brieff.bfmpro = 'ACT' AND brieff.bfac = '1') OR
		(brieff.bfmpro = 'ADV' AND brieff.bfac = '1' AND brieff.bf41stat IS NOT NULL)
)

SELECT
	cases.bfmpro AS "Status",
	count(cases.bfmpro) AS "Advance Certified",
	to_char(avg(cases.certified_to_now), '9999.99') AS "Average Dyas from Cert"
FROM cases
GROUP BY cases.bfmpro
ORDER BY cases.bfmpro ASC