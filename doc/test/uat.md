# Test Plan

This document contains user tests that can be used to verify that Caseflow is working correctly. Each test is broken into a section with a summary of what it tests and a series of steps to perform.

#### View a case with an incorrect BFKEY

1. Open Caseflow at the base URL.
1. Enter a invalid BFKEY.
1. Error pops, describing that no record was found.

#### View a complete case without any SSOCs

1. Open Caseflow at the base URL.
1. Enter a valid BFKEY.
1. Reconciliation page appears.
  1. VACOLS Side.
    1. NOD shows correct date.
    1. SOC shows correct date.
    1. Form 9 shows correct date.
  1. VBMS Side.
    1. NOD shows correct date.
    1. SOC shows correct date.
    1. Form 9 shows correct date.
1. As all correct dates match the, "Continue" button is enabled. When clicked, user is directed to the Questions page.
1. When user enters answers for the required questions, "Continue" button is enabled.  When clicked, user is directed to Form 8 page.
1. When Form 8 is generated, user can download the Form 8 by clicking the "Download Complete Form 8" link.  User can click "Finish Certification" button and be directed to Confirmation page.
1. When Confirmation page loads, case will be certified in VACOLS, and have the Form 8 automatically uploaded into the VBMS eFolder.  User can then close browser.


#### View a complete case with 2 SSOCs

1. Open Caseflow at the base URL.
1. Enter a valid BFKEY.
1. Reconciliation page appears.
  1. VACOLS Side.
    1. NOD shows correct date.
    1. SOC shows correct date.
    1. SSOC1 shows correct date.
    1. SSOC2 shows correct date.
    1. Form 9 shows correct date.
  1. VBMS Side.
    1. NOD shows correct date.
    1. SOC shows correct date.
    1. SSOC1 shows correct date.
    1. SSOC2 shows correct date.
    1. Form 9 shows correct date.
1. As all correct dates match the, "Continue" button is enabled. When clicked, user is directed to the Questions page.
1. When user enters answers for the required questions, "Continue" button is enabled.  When clicked, user is directed to Form 8 page.
1. When Form 8 is generated, user can download the Form 8 by clicking the "Download Complete Form 8" link.  User can click "Finish Certification" button and be directed to Confirmation page.
1. When Confirmation page loads, case will be certified in VACOLS, and have the Form 8 automatically uploaded into the VBMS eFolder.  User can then close browser.
