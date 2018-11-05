CREATE table `m_dim_dept_superior` AS SELECT
	b.agent_key AS AGENT_KEY,
	b.sysid AS SYSID,
	a.DEPT_NAME AS DEPT_NAME,
	a.AGENT_NAME AS AGENT_NAME,
	a.BASIC_DATA AS BASIC_DATA
FROM
	(
		dw_db.m_dim_dept_fzlc a
		LEFT JOIN dw_db.m_dim_agent b ON ((a.AGENT_NAME = b. NAME))
	)
WHERE
	(b.sysid LIKE 'ryan_fzlc%')
UNION ALL
	SELECT
		a.agent_key AS agent_key,
		a.SYSID AS SYSID,
		'ÆäËû' AS DEPT_NAME,
		a.agent_name AS AGENT_NAME,
		'0' AS BASIC_DATA
	FROM
		(
			SELECT DISTINCT
				a.agent_key AS agent_key,
				a.sysid AS SYSID,
				a. NAME AS agent_name
			FROM
				dw_db.m_dim_agent a
			WHERE
				(a.sysid LIKE 'ryan_fzlc%')
		) a
	WHERE
		(
			NOT (
				a.agent_name IN (
					SELECT DISTINCT
						a.AGENT_NAME
					FROM
						dw_db.m_dim_dept_fzlc a
					WHERE
						(a.BASIC_DATA = '1')
				)
			)
		);

alter table  m_dim_dept_superior add primary key(AGENT_KEY);
;
alter table m_dim_dept_superior add index IX_AGENT_NAME(DEPT_NAME)
;