-- median docket date

with cases as (
    select *
    from brieff
      inner join folder on folder.ticknum = brieff.bfkey
    where brieff.bfcurloc = '81'
          and brieff.bforgtic is not null
    order by folder.tiadtime asc
),

    total as (
      select count(1) as count
      from cases
  ),

    half as (
      select *
      from cases, total
      where rownum <= total.count / 2
  )

select max(half.tiadtime) from half;

-- cases in docket order

with current_cases as (
    select
      brieff.bfkey, brieff.bfcorlid, brieff.bforgtic, brieff.bfac,
      folder.tinum, folder.tiadtime,
      corres.snamef, corres.snamel,
      staff.stafkey as hearing,
      case
      when folder.tisubj2 = 'Y' or folder.tivbms in ('Y', '1', '0')
      then 1
      else 0
      end as paperless
    from brieff
      inner join folder on folder.ticknum = brieff.bfkey
      inner join corres on corres.stafkey = brieff.bfcorkey
      left outer join hearsched on hearsched.folder_nr = brieff.bfkey and hearsched.hearing_disp = 'H'
      left outer join staff on staff.sattyid = hearsched.board_member
    where brieff.bfcurloc = '81'
          and brieff.bforgtic is not null
),

    previous_hearings as (
      select distinct
        folder.tinum, staff.stafkey as hearing
      from brieff
        inner join folder on folder.ticknum = brieff.bfkey
        left outer join hearsched on hearsched.folder_nr = brieff.bfkey and hearsched.hearing_disp = 'H'
        left outer join staff on staff.sattyid = hearsched.board_member
      where brieff.bfmpro = 'HIS'
            and folder.tinum in (select tinum from current_cases)
      order by folder.tinum, staff.stafkey
  ),

    previous_decisions as (
      select distinct
        folder.tinum, staff.stafkey as decision
      from brieff
        inner join folder on folder.ticknum = brieff.bfkey
        left outer join staff on staff.sattyid = brieff.bfmemid
      where brieff.bfmpro = 'HIS'
            and staff.susrsec is not null
            and folder.tinum in (select tinum from current_cases)
      order by folder.tinum, staff.stafkey
  ),

    pending_mail as (
      select bfkey
      from current_cases
        inner join mail on mail.mlfolder = current_cases.bfkey and mail.mlcompdate is null
  ),

    current_cases_with_hearings as (
      select
        current_cases.bfkey, current_cases.snamef, current_cases.snamel, current_cases.bfcorlid, current_cases.bforgtic, current_cases.bfac,
        current_cases.tinum, current_cases.tiadtime, current_cases.paperless, current_cases.hearing,
        listagg(previous_hearings.hearing, ',') within group (order by previous_hearings.hearing) as previous_hearings
      from current_cases
        left outer join previous_hearings on previous_hearings.tinum = current_cases.tinum
      where current_cases.bfkey not in (select bfkey from pending_mail)
      group by
        current_cases.bfkey, current_cases.snamef, current_cases.snamel, current_cases.bfcorlid, current_cases.bforgtic, current_cases.bfac,
        current_cases.tinum, current_cases.tiadtime, current_cases.hearing, current_cases.paperless
  )

select
  cases.bfkey, cases.snamef, cases.snamel, cases.bfcorlid, cases.bforgtic, cases.bfac,
  cases.tinum, vacols.DOCKET_YYMM(cases.tinum) as docketdate, cases.paperless, cases.hearing, cases.previous_hearings,
               listagg(previous_decisions.decision, ',') within group (order by previous_decisions.decision) as previous_decisions
from current_cases_with_hearings cases
  left outer join previous_decisions on previous_decisions.tinum = cases.tinum
group by
  cases.bfkey, cases.snamef, cases.snamel, cases.bfcorlid, cases.bforgtic, cases.bfac,
  cases.tinum, cases.tiadtime, cases.hearing, cases.paperless, cases.previous_hearings
order by cases.tinum asc;

