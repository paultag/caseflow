-- MPR / MPR3 - ADV Appeals Certified to BVA

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
		folder.tisubj2,
		folder.tivbms,
		sysdate - brieff.bf41stat as certified_to_now,
		CASE
			WHEN folder.tisubj2 = 'Y' OR folder.tivbms IN ('Y', '1', '0')
			THEN 1
			ELSE 0
		END AS is_paperless,
		CASE
			WHEN brieff.bfhr IN ('1', '2') AND brieff.bfha IS NULL
			THEN 1
			ELSE 0
		END AS hearing_pending
	FROM
		brieff,
		folder
	WHERE
		(brieff.bfkey = folder.ticknum) AND
		(brieff.bfmpro = 'ADV') AND
		(brieff.bf41stat IS NOT NULL) AND
		(brieff.bfac = '1')
)

SELECT
	cases.bfregoff,
	count(cases.bfmpro) AS "Advanced Certified",
	count(nullif(cases.is_paperless, 1)) AS "Hardcopy",
	sum(cases.is_paperless)AS "Paperless",
	sum(cases.hearing_pending) AS "Pending BVA Hrq",
	count(nullif(cases.hearing_pending, 1)) AS "Pending No Hrq",
	to_char(avg(cases.certified_to_now), '9999.99') AS "Avg Days from Cert"
FROM cases
GROUP BY cases.bfregoff
ORDER BY cases.bfregoff ASC