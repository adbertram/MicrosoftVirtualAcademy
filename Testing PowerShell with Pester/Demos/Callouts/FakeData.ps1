function Sync-AdUser {
	param(
		$CsvFilePath
	)

	$users = Import-Csv -Path $CsvFilePath
	foreach ($user in $users) {
		$user.FirstName
	}
}

describe 'Fake Data Demo' {

	mock 'Import-Csv' {
            ConvertFrom-Csv -InputObject @'
    "FirstName","LastName","Department","Title"
    "Katie","Green","Accounting","Manager of Accounting"
    "Joe","Blow", "Information Systems","System Administrator"
    "Joe","Schmoe", "Information Systems", "Software Developer"
    "Barack","Obama", "Executive Office", "CEO"
    "Donald","Trump", "Janitorial Services", "Custodian"
'@
	}

	it 'returns the first name of each user' {
		$result = Sync-AdUser -CsvFilePath 'doesnotmatter.csv'

		diff $result @('Katie','Joe','Joe','Barack','Donald')
	}
}