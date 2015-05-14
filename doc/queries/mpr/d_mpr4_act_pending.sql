-- MPR / MPR4 - BVA Pending by Type Action

WITH cases AS (
	SELECT
		brieff.bfkey,
		brieff.bfmpro,
		brieff.bfac,
		brieff.bfcurloc,
		folder.tidrecv,
		sysdate - tidrecv AS received_to_now,
		CASE
			WHEN brieff.bfcurloc = '55'
			THEN brieff.bfac || ' - ' || 'VSO'
			ELSE brieff.bfac || ' - ' || 'BVA'
		END AS location
	FROM
		brieff,
		folder
	WHERE
		(brieff.bfkey = folder.ticknum) AND
		(brieff.bfmpro = 'ACT') AND
		(folder.tidrecv is not null)
)

SELECT
	cases.location AS "Type Action",
	count(cases.bfkey) AS "Appeals",
	to_char(avg(cases.received_to_now), '9999.99') AS "Days Pending at BVA"
FROM cases
GROUP BY cases.location
ORDER BY cases.location ASC
