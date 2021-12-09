public class QueryOrder {

	public enum SortOrder { ASCENDING, DESCENDING }
	public enum NullsOrder { FIRST, LAST }

	private String field;
	private SortOrder sortValue;
	private NullsOrder nullsValue;

	public QueryOrder(String field) {
		this.field = field;
		this.sortValue = SortOrder.ASCENDING;
	}

	public QueryOrder ascending() {
		this.sortValue = SortOrder.ASCENDING;
		return this;
	}

	public QueryOrder descending() {
		this.sortValue = SortOrder.DESCENDING;
		return this;
	}

	public QueryOrder nullsFirst() {
		this.nullsValue = NullsOrder.FIRST;
		return this;
	}

	public QueryOrder nullsLast() {
		this.nullsValue = NullsOrder.LAST;
		return this;
	}

	public String build() {
		String orderString = field;

		if (sortValue == SortOrder.ASCENDING) {
			orderString += ' ASC';
		} else {
			orderString += ' DESC';
		}

		if (nullsValue != null && nullsValue == NullsOrder.FIRST) {
			orderString += ' NULLS FIRST';
		} else if (nullsValue != null && nullsValue == NullsOrder.LAST) {
			orderString += ' NULLS LAST';
		}

		return orderString;
	}
}