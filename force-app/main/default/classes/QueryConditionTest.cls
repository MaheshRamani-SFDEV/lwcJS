@isTest
private class QueryConditionTest {

	@isTest
	static void testEqualsString() {
		String segment = new QueryCondition('Name').equalsTo('Jean-Philippe Monette').build();
		System.assertEquals('Name = \'Jean-Philippe Monette\'', segment);
	}

	@isTest
	static void testEqualsInteger() {
		String segment = new QueryCondition('Age').equalsTo(5).build();
		System.assertEquals('Age = 5', segment);
	}

	@isTest
	static void testNotEquals() {
		String segment = new QueryCondition('Name').notEqualsTo('Jean-Philippe Monette').build();
		System.assertEquals('Name != \'Jean-Philippe Monette\'', segment);
	}

	@isTest
	static void testIsLessThan() {
		String segment = new QueryCondition('Age').isLessThan(5).build();
		System.assertEquals('Age < 5', segment);
	}

	@isTest
	static void testIsLessOrEquals() {
		String segment = new QueryCondition('Age').isLessOrEquals(5).build();
		System.assertEquals('Age <= 5', segment);
	}

	@isTest
	static void testIsGreaterThan() {
		String segment = new QueryCondition('Age').isGreaterThan(5).build();
		System.assertEquals('Age > 5', segment);
	}

	@isTest
	static void testIsGreaterOrEquals() {
		String segment = new QueryCondition('Age').isGreaterOrEquals(5).build();
		System.assertEquals('Age >= 5', segment);
	}

	@isTest
	static void testIsLike() {
		String segment = new QueryCondition('Name').isLike('%Acme%').build();
		System.assertEquals('Name LIKE \'%Acme%\'', segment);
	}

	@isTest
	static void testIsIn() {
		List<String> names = new List<String>{'John', 'Jane'};
		String segment = new QueryCondition('Name').isIn(names).build();
		System.assertEquals('Name IN (\'John\', \'Jane\')', segment);
	}

	@isTest
	static void testIsNotIn() {
		List<String> names = new List<String>{'John', 'Jane'};
		String segment = new QueryCondition('Name').isNotIn(names).build();
		System.assertEquals('Name NOT IN (\'John\', \'Jane\')', segment);
	}

	@isTest
	static void testIncludes() {
		List<String> markets = new List<String>{'APAC', 'EMEA'};
		String segment = new QueryCondition('Market').includes(markets).build();
		System.assertEquals('Market INCLUDES (\'APAC\', \'EMEA\')', segment);
	}

	@isTest
	static void testExcludes() {
		List<String> markets = new List<String>{'APAC', 'EMEA'};
		String segment = new QueryCondition('Market').excludes(markets).build();
		System.assertEquals('Market EXCLUDES (\'APAC\', \'EMEA\')', segment);
	}

	@isTest
	static void testIsNull() {
		String segment = new QueryCondition('Name').isNull().build();
		System.assertEquals('Name = null', segment);
	}

	@isTest
	static void testIsNotNull() {
		String segment = new QueryCondition('Name').isNotNull().build();
		System.assertEquals('Name != null', segment);
	}

}