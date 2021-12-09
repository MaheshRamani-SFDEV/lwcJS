public class QueryGenerator {

	private String fromText;
	private Integer numberOfRows;
	private Integer numberOfRowsToSkip;

	private Set<String> fieldList = new Set<String>();
	private List<QueryOrder> orders = new List<QueryOrder>();
	private List<QueryCondition> conditions = new List<QueryCondition>();
	private List<QueryGenerator> subQueries = new List<QueryGenerator>();

	public QueryGenerator(SObjectType fromType)	{ 
        this.fromText = String.valueOf(fromType); 
    }
	public QueryGenerator(String fromText){ 
        this.fromText = fromText; 
    }

	/**
	 * Instantiate an OrderBy object
	 */
	public static QueryOrder orderBy(String fieldName) {
		QueryOrder od = new QueryOrder(fieldName);
		return od;
	}

	/**
	 * Instantiate a Condition object
	 */
	public static QueryCondition condition(String fieldName) {
		QueryCondition cond = new QueryCondition(fieldName);
		return cond;
	}

	/**
	 * Add an OrderBy statement
	 */
	public QueryGenerator add(QueryOrder ob) {
		this.orders.add(ob);
		return this;
	}

	/**
	 * Add a Condition statement
	 */
	public QueryGenerator add(QueryCondition cnd) {
		this.conditions.add(cnd);
		return this;
	}

	/**
	 * Add an SELECT sub-query
	 */
	public QueryGenerator addSubquery(QueryGenerator qb) {
		this.subQueries.add(qb);
		return this;
	}

	/**
	 * Add fields to the SELECT statement from FieldSet
	 */
	public QueryGenerator selectFields(Schema.FieldSet fs) {
		for(Schema.FieldSetMember field : fs.getFields()) {
			this.fieldList.add(field.getFieldPath());
		}
		return this;
	}

	/**
	 * Add fields to the SELECT statement from Set of Strings
	 */
	public QueryGenerator selectFields(Set<String> fields) {
		for(String field : fields) {
			this.fieldList.add(field);
		}
		return this;
	}

	/**
	 * Add a LIMIT statement
	 */
	public QueryGenerator addLimit(Integer i) {
		this.numberOfRows = i;
		return this;
	}

	/**
	 * Add an OFFSET statement
	 */
	public QueryGenerator addOffset(Integer i) {
		this.numberOfRowsToSkip = i;
		return this;
	}

	/**
	 * Build the SELECT statement
	 */
	public String buildSelect() {
		for (QueryGenerator qb : this.subQueries) {
			this.fieldList.add('(' + qb.build() + ')');
		}

		if (!this.fieldList.isEmpty()) {
			return 'SELECT ' + String.join(new List<String>(this.fieldList), ', ');
		} else {
			return 'SELECT Id';
		}
	}

	/**
	 * Build the WHERE statement
	 */
	public String buildConditions() {
		List<String> condList = new List<String>();

		for (QueryCondition cond : this.conditions) {
			condList.add(cond.build());
		}

		if (!this.conditions.isEmpty()) {
			return 'WHERE ' + String.join(condList, ' AND ');
		} else {
			return null;
		}
	}

	/**
	 * Build the ORDER BY statement
	 */
	public String buildOrderBy() {
		List<String> orderList = new List<String>();

		for (QueryOrder order : this.orders) {
			orderList.add(order.build());
		}

		if (!this.orders.isEmpty()) {
			return 'ORDER BY ' + String.join(orderList, ', ');
		} else {
			return '';
		}

	}

	/**
	 * Build the SOQL query
	 */
	public String build() {
		List<String> queryParts = new List<String>();

		queryParts.add(this.buildSelect());
		queryParts.add('FROM ' + this.fromText);

		if (!this.conditions.isEmpty()) {
			queryParts.add(this.buildConditions());
		}

		if (!this.orders.isEmpty()) {
			queryParts.add(this.buildOrderBy());
		}

		if (this.numberOfRows != null) {
			queryParts.add('LIMIT ' + this.numberOfRows);
		}

		if (this.numberOfRowsToSkip != null) {
			queryParts.add('OFFSET ' + this.numberOfRowsToSkip);
		}

		return String.join(queryParts, ' ');
	}

}


/*Example 1
QueryGenerator query = new QueryGenerator(Account.SObjectType)
    .selectFields(SObjectType.Account.fieldSets.dataTableFieldSet)
    .addSubquery(new QueryGenerator('Contacts'))
    .add(QueryGenerator.condition('Name').isLike('%Test%'))
    .add(QueryGenerator.condition('BillingCountry').isNotNull())
    .addLimit(5);

System.debug(query.build());
// SELECT MasterRecordId, Name, Industry, Active__c, AnnualRevenue, Type, (SELECT Id FROM Contacts) FROM Account WHERE Name LIKE '%Test%' AND BillingCountry != null LIMIT 5
 * 
 * 
 * Example 2

QueryGenerator query = new QueryGenerator(Contact.SObjectType).addLimit(5);

if (String.isNotBlank(firstName)) {
  query.add(QueryGenerator.condition('FirstName').equalsTo(firstName))
}

if (String.isNotBlank(lastName)) {
  query.add(QueryGenerator.condition('LastName').equalsTo(lastName))
}

System.debug(query.build());
// SELECT Id FROM Contact WHERE FirstName = 'Céline' AND LastName = 'Dion' LIMIT 5
// *
// *
// Example 3
Set<String> fields = new Set<String>();
fields.add('Name');
fields.add('Phone');
QueryGenerator query = new QueryGenerator('Account')
    .selectFields(fields)
    .addSubquery(new QueryGenerator('Contacts'))
    .add(QueryGenerator.condition('Name').isLike('%Test%'))
    .add(QueryGenerator.condition('BillingCountry').isNotNull())
    .addLimit(5);

System.debug(query.build());
//SELECT Name, Phone, (SELECT Id FROM Contacts) FROM Account WHERE Name LIKE '%Test%' AND BillingCountry != null LIMIT 5
// */