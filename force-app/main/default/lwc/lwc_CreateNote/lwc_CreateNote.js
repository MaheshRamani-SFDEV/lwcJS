import { LightningElement, api } from 'lwc';

export default class LWC_CreateNote extends LightningElement {
    @api note = "{'sobjectType': 'Note','Title': '','Body': '','ParentId': '','OwnerId': ''}";
    @api ParentId;
    @api saveClicked;
    @api isCreateNote;
    @api isViewNote;
    @api noRelatedNote;
    @api haveNoteForView;
    @api fetchNoteRecord;
}