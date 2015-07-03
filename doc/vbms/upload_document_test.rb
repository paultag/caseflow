path = "/Users/admin/Development/ruby/caseflow/tmp/forms/VA8-543adaad5e831e1e65bf4bec95ee528a.pdf"
request = VBMS::Requests::UploadDocumentWithAssociations.new("784449089", Time.now, "Joe", "R", "Snuffy", "form8", path, "625", "Caseflow VBMS test", true)
$vbms.send(request)
