import {LightningElement, track, wire} from 'lwc';
import getLineItemWrappers from '@salesforce/apex/LineItemsResponseController.getLineItemWrappers';
import getResponseResult from '@salesforce/apex/LineItemsResponseController.getResponseResult';

const columns = [
    { label: 'Product', fieldName: 'productName' },
    { label: 'Product code', fieldName: 'productCode' },
    { label: 'Quantity', fieldName: 'quantity' },
    { label: 'Amount', fieldName: 'amount', type: 'currency' },
    { label: 'Transaction', fieldName: 'transactionNumber' }
];

export default class LineItems extends LightningElement {
    columns = columns;
    rowOffset = 0;
    @track error;
    lineItemWrappers = [];

    showJSONParagraph = false;
    jsonString;
    
    handleLoadClick() {
        this.fillData();
    }

    handleShowClick() {
        this.showJSONParagraph = true;
    }

    fillData() {
        getLineItemWrappers().then(
            result => {
                let dataList = [];
                result.forEach(element => {
                    let elt = {};
                    elt.productName = element.productName;
                    elt.productCode = element.productCode;
                    elt.quantity =  element.quantity;
                    elt.amount =  element.amount;
                    elt.transactionNumber = element.transactionNumber;
                    dataList.push(elt);
                });

                this.lineItemWrappers = dataList;
                this.error = undefined;
            }).catch(
            error => {
                this.lineItemWrappers = undefined;
                this.error = error;
            });

        getResponseResult().then(
            result => {
                console.log(result);
                this.jsonString = result;
            });
    }
}