-- MPR / MPR8 - Non-Originals Pending as of date

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
		folder.tidrecv,
		to_date(:start_date, 'MM/DD/YY') - folder.tidrecv AS date_to_received
	FROM
		brieff,
		folder
	WHERE
		(brieff.bfkey = folder.ticknum) AND
		(brieff.bfac <> '1') AND
		(folder.tidrecv <= to_date(:start_date, 'MM/DD/YY')) AND
		(brieff.bfddec >= to_date(:start_date, 'MM/DD/YY') OR brieff.bfddec IS NULL)
)

SELECT
	cases.bfac AS "Type Action",
	count(cases.bfac) AS "Post-Remands",
	to_char(avg(cases.date_to_received), '9999.99') AS "Average Days from BVA Receipt"
FROM cases
GROUP BY cases.bfac
ORDER BY cases.bfac ASC