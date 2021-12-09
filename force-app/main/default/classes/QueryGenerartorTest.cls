@isTest
private class QueryGenerartorTest {

	@isTest
	static void testConstructor() {
		String query =
			new QueryGenerator(Account.SObjectType)
				.build();

		System.assertEquals('SELECT Id FROM Account', query);
		Database.query(query);
	}

	@isTest
	static void testAddSubQuery() {
		String query =
			new QueryGenerator(Account.SObjectType)
				.addSubquery(new QueryGenerator('Contacts'))
				.build();

		System.assertEquals('SELECT (SELECT Id FROM Contacts) FROM Account', query);
		Database.query(query);
	}

	@isTest
	static void testSelectFieldsUsingFieldSet() {
		String query =
			new QueryGenerator(Account.SObjectType)
				.selectFields(SObjectType.Account.fieldSets.dataTableFieldSet)
				.build();

		System.assertEquals('SELECT CreatedById, Description, Owner.Email FROM Account', query);
		Database.query(query);
	}

	@isTest
	static void testSelectFieldsUsingSetString() {
		String query =
			new QueryGenerator(Account.SObjectType)
				.selectFields(new Set<String>{'CreatedById', 'Description', 'Owner.Email'})
				.build();

		System.assertEquals('SELECT CreatedById, Description, Owner.Email FROM Account', query);
		Database.query(query);
	}

	@isTest
	static void testAddOrders() {
		String query =
			new QueryGenerator(Account.SObjectType)
				.add(QueryGenerator.orderBy('Name').nullsLast())
				.add(QueryGenerator.orderBy('BillingCountry').descending())
				.build();

		System.assertEquals('SELECT Id FROM Account ORDER BY Name ASC NULLS LAST, BillingCountry DESC', query);
		Database.query(query);
	}

	@isTest
	static void testAddCondition1() {
		String query =
			new QueryGenerator(Account.SObjectType)
				.add(QueryGenerator.condition('BillingCountry').isNotNull())
				.build();

		System.assertEquals('SELECT Id FROM Account WHERE BillingCountry != null', query);
		Database.query(query);
	}

	@isTest
	static void testAddCondition2() {
		String query =
			new QueryGenerator(Account.SObjectType)
				.add(QueryGenerator.condition('Name').isLike('%Acme%'))
				.build();

		System.assertEquals('SELECT Id FROM Account WHERE Name LIKE \'%Acme%\'', query);
		Database.query(query);
	}

	@isTest
	static void testAddLimit() {
		String query =
			new QueryGenerator(Account.SObjectType)
				.addLimit(5)
				.build();

		System.assertEquals('SELECT Id FROM Account LIMIT 5', query);
		Database.query(query);
	}

	@isTest
	static void testAddOffset() {
		String query =
			new QueryGenerator(Account.SObjectType)
				.addOffset(5)
				.build();

		System.assertEquals('SELECT Id FROM Account OFFSET 5', query);
		Database.query(query);
	}

}