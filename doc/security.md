# Caseflow

Caseflow is a software system developed by the Digital Service at the Department of Veterans Affairs to assist Original Areas of Jurisdictions in preparing benefits appeals for the Board of Veterans Appeals. This document describes the environment in which Caseflow operates and the systems with which it communicates.

Caseflow is a web based tool intended for use by Veterans Service Representatives at AOJs to ensure that the VACOLS database and the VBMS eFolder have matching views of the state of a case, particularly on which dates various documents were filed. It further provides a simplified form for inputting the data necessary to create a Form 8, as well as automatically uploading it to the VBMS eFolder.

## Environment

Caseflow is hosted on four servers located in the Austin Information Technology Center (AITC) in the VINCI cluster. Caseflow runs on Linux systems running Red Hat Enterprise Linux.

## Communications

Caseflow communicates with two systems:

- The VACOLS Database
- The VBMS eFolder API

### VACOLS Database

VACOLS is the software system which supports the appeals process at the Board of Veterans Appeals. Caseflow communicates directly with VACOLS's Oracle database.

Connections to the Oracle database from Caseflow are secured using password authentication for the database.

Caseflow and the VACOLS Oracle database exchange the following information:

- The dates on which a veteran's Form 9, NOD, SOC, and SSOC were filed.
- The state an appeal is currently in.
- Whether the contents of a folder are electronic or not.
- The file number (often this is veteran's Social Security Number)

Further, Caseflow will write the date on which a Form 8 is filed back to the VACOLS Oracle database.

### VBMS eFolder API

VBMS is the software system which supports the disability benefits claim process. It provides an API which allows for consuming the eFolder programmatically.

Connections to the VBMS eFolder API are secured using mutually authenticated TLS, which provides confidentially, integrity, and authentication of both the server and the client.

Caseflow and the VBMS eFolder API exchange the following information:

- A list of documents in the eFolder, including document name, document type, and the receipt date for the document. (This does not include the _contents_ of any documents.)

Further, Caseflow uploads a new document to the eFolder, a completed Form 8.
