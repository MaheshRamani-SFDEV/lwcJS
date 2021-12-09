public class QueryCondition {

	public enum ComparisonOperator { EQUALS, NOT_EQUALS, LESS_THAN, LESS_OR_EQUAL, GREATER_THAN, GREATER_OR_EQUAL, IS_LIKE, IS_IN, NOT_IN, INCLUDES, EXCLUDES }

	private ComparisonOperator operatorValue;

	private String field {
		private get { return String.escapeSingleQuotes(field); }
		private set;
	}

	private Object fieldValue {
		private get { return formatFieldValue(fieldValue); }
		private set { fieldValue = value; }
	}
	public QueryCondition(String field) {
		this.field = field;
	}

	private Object formatFieldValue(Object val) {
		if (val instanceof List<Object>) {
			List<String> values = new List<String>();
			for (Object value : (List<Object>) val) {
				if (value instanceof String) {
					values.add('\'' + String.escapeSingleQuotes((String) value) + '\'');
				} else {
					values.add((String) value);
				}
			}
			return String.join(values, ', ');
		}
		if (val instanceof String) {
			return '\'' + String.escapeSingleQuotes((String) val) + '\'';
		} else if (val instanceof Date) {
			String dateString = String.valueOf(val);
			return dateString.substring(0, dateString.indexOf(' '));
		} else {
			return val;
		}
	}

	public QueryCondition equalsTo(Object value) {
		this.operatorValue = ComparisonOperator.EQUALS;
		this.fieldValue = value;
		return this;
	}

	public QueryCondition notEqualsTo(Object value) {
		this.operatorValue = ComparisonOperator.NOT_EQUALS;
		this.fieldValue = value;
		return this;
	}

	public QueryCondition isLessThan(Object value) {
		this.operatorValue = ComparisonOperator.LESS_THAN;
		this.fieldValue = value;
		return this;
	}

	public QueryCondition isLessOrEquals(Object value) {
		this.operatorValue = ComparisonOperator.LESS_OR_EQUAL;
		this.fieldValue = value;
		return this;
	}

	public QueryCondition isGreaterThan(Object value) {
		this.operatorValue = ComparisonOperator.GREATER_THAN;
		this.fieldValue = value;
		return this;
	}

	public QueryCondition isGreaterOrEquals(Object value) {
		this.operatorValue = ComparisonOperator.GREATER_OR_EQUAL;
		this.fieldValue = value;
		return this;
	}

	public QueryCondition isLike(String value) {
		this.operatorValue = ComparisonOperator.IS_LIKE;
		this.fieldValue = value;
		return this;
	}

	public QueryCondition isIn(List<Object> values) {
		this.operatorValue = ComparisonOperator.IS_IN;
		this.fieldValue = values;
		return this;
	}

	public QueryCondition isNotIn(List<Object> values) {
		this.operatorValue = ComparisonOperator.NOT_IN;
		this.fieldValue = values;
		return this;
	}

	public QueryCondition includes(List<Object> values) {
		this.operatorValue = ComparisonOperator.INCLUDES;
		this.fieldValue = values;
		return this;
	}

	public QueryCondition excludes(List<Object> values) {
		this.operatorValue = ComparisonOperator.EXCLUDES;
		this.fieldValue = values;
		return this;
	}

	public QueryCondition isNull() {
		this.operatorValue = ComparisonOperator.EQUALS;
		this.fieldValue = null;
		return this;
	}

	public QueryCondition isNotNull() {
		this.operatorValue = ComparisonOperator.NOT_EQUALS;
		this.fieldValue = null;
		return this;
	}

	public String build() {
		if (operatorValue.equals(ComparisonOperator.EQUALS)) {
			return field + ' = ' + fieldValue;
		} else if (operatorValue.equals(ComparisonOperator.NOT_EQUALS)) {
			return field + ' != ' + fieldValue;
		} else if (operatorValue.equals(ComparisonOperator.LESS_THAN)) {
			return field + ' < ' + fieldValue;
		} else if (operatorValue.equals(ComparisonOperator.LESS_OR_EQUAL)) {
			return field + ' <= ' + fieldValue;
		} else if (operatorValue.equals(ComparisonOperator.GREATER_THAN)) {
			return field + ' > ' + fieldValue;
		} else if (operatorValue.equals(ComparisonOperator.GREATER_OR_EQUAL)) {
			return field + ' >= ' + fieldValue;
		} else if (operatorValue.equals(ComparisonOperator.IS_LIKE)) {
			return field + ' LIKE ' + fieldValue;
		} else if (operatorValue.equals(ComparisonOperator.IS_IN)) {
			return field + ' IN (' + fieldValue + ')';
		} else if (operatorValue.equals(ComparisonOperator.NOT_IN)) {
			return field + ' NOT IN (' + fieldValue + ')';
		} else if (operatorValue.equals(ComparisonOperator.INCLUDES)) {
			return field + ' INCLUDES (' + fieldValue + ')';
		} else if (operatorValue.equals(ComparisonOperator.EXCLUDES)) {
			return field + ' EXCLUDES (' + fieldValue + ')';
		} else {
			return '';
		}
	}

}