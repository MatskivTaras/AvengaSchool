@isTest
public class LineItemTriggerTest {
    @isTest
    static void testInsertLineItem(){
        Test.startTest();
        Line_Item__c newLineItem = new Line_Item__c(
            Name = 'new line item'
        );
        Database.SaveResult sr = Database.insert(newLineItem);
        Test.stopTest();

        System.assert(sr.isSuccess(), 'LineItemTrigger : line item created');
    }
}
