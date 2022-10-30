import {LightningElement, track} from 'lwc';
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
    @track lineItemWrappers = [];

    @track showTable = false;
    @track showJSONParagraph = false;

    @track btnLoad = 'Load';
    @track btnShowJSON = 'Show JSON';

    @track jsonString;
    
    handleLoadClick() {
        this.getJSONResponse();

        this.btnLoad = 'Loaded';
        this.showTable = false;
    }

    handleDisplayClick() {
        this.fillDatatable(this.jsonString);

        this.btnLoad = 'Load';
        this.showTable = true;
    }

    handleShowClick() {
        if (this.showJSONParagraph === true) {
            this.showJSONParagraph = false;
            this.btnShowJSON = 'Show JSON';
        } else {
            this.showJSONParagraph = true;
            this.btnShowJSON = 'Hide JSON';
        }
    }

    getJSONResponse() {
        getResponseResult().then(
            result => {
                this.jsonString = result;
            });
    }

    fillDatatable(tmpResponseResult) {
        getLineItemWrappers({responseResult: tmpResponseResult}).then(
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
    }
}