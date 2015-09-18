# Test Plan

This document contains user tests that can be used to verify that Caseflow is working correctly. Each test is broken into a section with a summary of what it tests and a series of steps to perform.

## Getting to the Application

For each of these tests, Caseflow requires the user to go to a URL with a BFKEY (a case ID from VACOLS). An example is:

```
https://vhacdwdwhcto6.vha.med.va.gov/caseflow/certifications/2741506/start
```

where `2741506` is the BFKEY. We'll call this the base URL throughout the tests.

## Functional Tests

- When a non-existed case ID (BFKEY) is used with base URL, the user gets an error
- When a case is not certifiable, the user gets an error
- When attempting to view a paper case (no eFolder), the user gets an error
- Start page
  - Missing VBMS dates (NOD, SOC, Form 9), 'Not Found' is shown
  - Missing VBMS dates (SSOC 1 - 5), 'Not Found' is shown
  - Correct VACOLS fields appear when document is present (NOD, SOC, Form 9, SSOC 1 - 5)
  - Correct VBMS fields appear when document is present (NOD, SOC, Form 9, SSOC 1 - 5)
  - When VBMS document is not found, correct error message is shown
  - When all documents are present, correct error message is shown when dates don't match (NOD, SOC, Form 9, SSOC 1-5)
  - When all documents match, user is sent to form 8 (NOD+SOC+Form9, NOD+SOC+Form9+SSOC 1-5)
  - When a BFKEY that isn't eligible for certification is used, user gets error page
  - When a user marks a case as uncertifiable, all certification fields in VACOLS are reset
  - When a user marks a case as uncertifiable, a message is displayed telling the user the case has been reset in VACOLS
- Questions page: 
  - All fields from VACOLS that do not have a question in Caseflow, are populated correctly
  - When 8B is answered with 'Located in another VA file',  8B Explanation is Displayed
  - When 9A is answered with 'No', 9B is displayed
  - When 10B is answered with 'No', 10C is displayed
  - When 11A is answered with 'Yes', 11B is displayed
  - When 13 is answered with 'Other', Specify Other question is displayed
  - 17A is a required field
  - 17B is a required field
- Certification page
  - All non-visible (not on Questions page) VACOLS fields make it onto Form 8
  - All fields from Questions page make it onto Form 8
  - Form 8 PDF is downloadable from page
  - Clicking Certify certifies the case in VACOLS
  - Clicking Certify certifies the case sends the user to a confirmation page
  - Clicking Certify uploads the Form 8 to VBMS
  - If uploading the Form 8 to VBMS fails, the user gets an error page and the case is marked as uncertifiable

### View a case with an non-existent BFKEY

#### Requires

- A non-existent BFKEY

#### Steps

1. Go to Caseflow with the base URL.

#### Expected Outcome:

HTTP 404 status will be returned (not found)