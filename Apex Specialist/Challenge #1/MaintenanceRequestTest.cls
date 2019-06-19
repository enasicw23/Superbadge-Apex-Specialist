@isTest
public class MaintenanceRequestTest {

    @testSetup
    static void setup(){
        Product2 prod = new Product2();
        prod.Cost__c = 50;
        prod.Name = 'Ball Valve 10 cm';
        prod.Lifespan_Months__c = 12;
        prod.Maintenance_Cycle__c = 365;
        prod.Current_Inventory__c = 50;
        prod.Replacement_Part__c = true;
        prod.Warehouse_SKU__c = '100009';
        insert prod;
        
        List<Case> caseList = new List<Case>();
        for(Integer i=0; i<300; i++) {
            Case caseNew = new Case();
            caseNew.Subject = 'Maintenance ' + i;
            caseNew.Type = 'Other';
            caseNew.Status = 'New';
            caseNew.Equipment__c = prod.Id;
            caseNew.SuppliedName = 'Test';
            caseList.add(caseNew);   
        }
        
        insert caseList;
        
        List<Work_Part__c> workPartList = new List<Work_Part__c>();
        for(Case caseHere : [select Id from Case where SuppliedName = 'Test']) {
            Work_Part__c workPart = new Work_Part__c();
            workPart.Maintenance_Request__c = caseHere.Id;
            workPart.Equipment__c = prod.Id;
            workPartList.add(workPart);   
        }
        
        insert workPartList;
    }
    
    @isTest
    static void testMaintenanceRequest(){
        List<Case> caseList = new List<Case>();
        for(Case caseHere : [select Id from Case where SuppliedName = 'Test']) {
            caseHere.Type = 'Repair';
            caseHere.Status = 'Closed';
            caseList.add(caseHere);
        }
        
        Test.startTest();
        update caseList;
        System.assertEquals(300, [SELECT count() FROM Case WHERE Type = 'Routine Maintenance' and Date_Reported__c = :Date.today()]);
        Test.stopTest();
        
    }
}
