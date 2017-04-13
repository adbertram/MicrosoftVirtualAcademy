function Do-Thing {
	param()

	throw 'I have been thrown'
}

describe 'Exception testing demo' {
	
	it 'throws an exception' {

		{ Do-Thing } | should throw 
	
	}

	it 'throws a specific exception message' {
		{ Do-Thing } | should throw 'notright'
	}
}