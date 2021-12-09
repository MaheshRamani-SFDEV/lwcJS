@isTest
private class QueryOrderTest {

	@isTest
	static void testConstructor() {
		String segment = new QueryOrder('Name').build();
		System.assertEquals('Name ASC', segment);
	}

	@isTest
	static void testAscending() {
		String segment = new QueryOrder('Name').ascending().build();
		System.assertEquals('Name ASC', segment);
	}

	@isTest
	static void testDescending() {
		String segment = new QueryOrder('Name').descending().build();
		System.assertEquals('Name DESC', segment);
	}

	@isTest
	static void testNullsFirst() {
		String segment = new QueryOrder('Name').nullsFirst().build();
		System.assertEquals('Name ASC NULLS FIRST', segment);
	}

	@isTest
	static void testNullsLast() {
		String segment = new QueryOrder('Name').nullsLast().build();
		System.assertEquals('Name ASC NULLS LAST', segment);
	}

}