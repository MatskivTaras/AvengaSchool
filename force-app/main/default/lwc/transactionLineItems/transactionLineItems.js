import {LightningElement, api, track, wire} from 'lwc';
import getTransactionLineItems from "@salesforce/apex/TransactionLineItemsController.getTransactionLineItems";
import generateData from './genMTOData';

const columns = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Product', fieldName: 'Product_Name_With_Code__c'},
    { label: 'Quantity', fieldName: 'Quantity__c'},
    { label: 'Amount', fieldName: 'Amount__c', type: 'currency'}
];

export default class transactionLineItems extends LightningElement {
    columns = columns;
    rowOffset = 0;
    @api recordId;
    @track error;
    lineItems = [];

    @wire(getTransactionLineItems, {transactionId: '$recordId'})
    wiredRecord({ error, data }) {
        if (error) {
            this.error = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message;
            }
            this.lineItems = undefined;
        } else if (data) {
            let dataList = [];
            data.forEach(element => {
                let elt = {};
                elt.Name = element.Name;
                elt.Product_Name_With_Code__c = element.Product_Name_With_Code__c ;
                elt.Quantity__c =  element.Quantity__c;
                elt.Amount__c =  element.Amount__c;
                dataList.push(elt);
            });
            this.lineItems = dataList;
        }
    }
}