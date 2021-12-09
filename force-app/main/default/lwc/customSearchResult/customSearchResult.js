import { LightningElement, track, api } from 'lwc';

export default class customSearchResult extends LightningElement {
    @api searchResultData;
    @api searchResultColumn;
    @api selectedRecordId;
    @track isButtonDisabled = true;
    @track defaultSortDirection = 'asc';
    @track sortDirection = 'asc';
    @track sortby;
    @api isSearchResultFound;

    getSelectedRecord(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedRecordId = selectedRows[0].Id
        this.isButtonDisabled = false;
    }

    handleUseSelected() {       
       this.dispatchEvent(new CustomEvent('next', {detail : {select : this.selectedRecordId}}));
    }

    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;

        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.searchResultData));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.searchResultData = parseData;

    }
}