describe 'MVA Tests' {

	context 'Arithmetic' {

		it '1 plus 1 should be 2' {
			1 + 1 | should be 2
		}

		it '3 minus 2 should 1' {
			3 - 2 | should be 1
		}
	}

	context 'String matching' {

		it 'an i should not be in team - like assertion' {
			'team' | should not belike '*i*'
		}

		it 'an i should not be in team - match assertion' {
			'team' | should not match 'i'
		}
	}

	context 'AAA approach' {

		$stringToTest = 'team'

		it 'an i should not be in team - like assertion' {
			$stringToTest | should not belike '*i*'
		}

		it 'an i should not be in team - like assertion' {
			$stringToTest | should belike '*i*'
		}

		it 'an i should not be in team - match assertion' {
			$stringToTest | should not match 'i'
		}
	}
}