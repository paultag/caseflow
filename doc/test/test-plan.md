# Test Plan

This document contains user tests that can be used to verify that Caseflow is working correctly. Each test is broken into a section with a summary of what it tests and a series of steps to perform.

#### View a case for a veteran with no NOD date in VACOLS

1. Open Caseflow at the base URL
1. Enter a valid case ID for a veteran *without* an NOD date in VACOLS
1. Click Start Certification

Expected:
VACOLS NOD Date is listed as `Not Found`

#### View a case for a veteran with no NOD date in VBMS

1. Open Caseflow at the base URL
1. Enter a valid case ID for a veteran *without* an NOD date in VBMS
1. Click Start Certification

Expected:
VBMS NOD Date is listed as `Not Found`

#### View a case for a veteran with NOD date in VACOLS

1. Open Caseflow at the base URL
1. Enter a valid case ID for a veteran *with* an NOD date in VACOLS
1. Click Start Certification

Expected:
VACOLS NOD Date is listed in mm/dd/yyyy format

#### View a case for a veteran with NOD date in VBMS

1. Open Caseflow at the base URL
1. Enter a valid case ID for a veteran *with* an NOD date in VBMS
1. Click Start Certification

Expected:
VBMS NOD Date is listed in mm/dd/yyyy format

#### View case appeal ID on start page

1. Open Caseflow at the base URL
1. Enter a valid case ID for a veteran
1. Click Start Certification

Expected:

Appeal ID is populated accurately

#### View appeal type on start page

(this test should be repeated for several cases each with different appeal types)

1. Open Caseflow at the base URL
1. Enter a valid case ID for a veteran
1. Click Start Certification

Expected:

Appeal Type should populate with a correct value (i.e. `Original`, etc.)


#### View an appeal that has matching NOD dates between VACOLS and VBMS (all other fields match)

#### View an appeal that has an NOD in VACOLS, but not in VBMS (all other fields match)

#### View an appeal that has an NOD in VBMS, but not in VACOLS (all other fields match)

#### View an appeal that has no NOD in VACOLS and VBMS (all other fields match)


#### View an appeal that has matching SOC dates between VACOLS and VBMS (all other fields match)

#### View an appeal that has an SOC in VACOLS, but not in VBMS (all other fields match)

#### View an appeal that has an SOC in VBMS, but not in VACOLS (all other fields match)

#### View an appeal that has no SOC in VACOLS and VBMS (all other fields match)


#### View an appeal that has matching Form 9 Date dates between VACOLS and VBMS (all other fields match)

#### View an appeal that has an Form 9 Date in VACOLS, but not in VBMS (all other fields match)

#### View an appeal that has an Form 9 Date in VBMS, but not in VACOLS (all other fields match)

#### View an appeal that has no Form 9 Date in VACOLS and VBMS (all other fields match)

#### View an appeal with an SSOC Date

#### View an appeal that has VBMS as File Type

#### View an appeal with Paper as a File Type

#### View an appeal with POA
