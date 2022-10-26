export default function generateData({ amountOfRecords }) {
    return [...Array(amountOfRecords)].map((_, index) => {
        return {
            Name: `Name (${index})`,
            Product_Name_With_Code__c: 'www.salesforce.com',
            Quantity__c: Math.floor(Math.random() * 100),
            Amount__c: Math.floor(Math.random() * 100)
        };
    });
}