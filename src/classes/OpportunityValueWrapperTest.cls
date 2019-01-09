@isTest
public class OpportunityValueWrapperTest {
    
    @TestSetup
    private static void prepareData() {
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        
        Opportunity opp = new Opportunity(
       		Name = 'TestOpp',
            Probability = 30,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(3),
            AccountId = acc.id
        );
        
        insert opp;
    }

    @isTest
    private static void testGetRecord() {
        Opportunity opp = [SELECT Id FROM Opportunity];
        
        Test.startTest();
        OpportunityValueWrapper oppValueWrapper = new OpportunityValueWrapper(opp);
        Opportunity retrievedOpp = oppValueWrapper.getRecord();
        Test.stopTest();
        
        System.assertEquals(retrievedOpp, opp);
    }
    
    @isTest
    private static void testValidateOpportunityAccountPositive() {
        Opportunity opp = [SELECT AccountId FROM Opportunity];
        
        Test.startTest();
        OpportunityValueWrapper oppValueWrapper = new OpportunityValueWrapper(opp);
        Boolean result = oppValueWrapper.validateOpportunityAccount();
        Test.stopTest();
        
        System.assertEquals(true, result);
	}
    
    @isTest
    private static void testValidateOpportunityAccountNegative() {
        Opportunity opp = [SELECT AccountId FROM Opportunity];
        opp.AccountId = null;
        
        Test.startTest();
        OpportunityValueWrapper oppValueWrapper = new OpportunityValueWrapper(opp);
        Boolean result = oppValueWrapper.validateOpportunityAccount();
        Test.stopTest();
        
        System.assertEquals(false, result);
	}
    
    @isTest
    private static void testIsHighValuePositive() {
        Opportunity opp = [SELECT Amount FROM Opportunity];
        opp.Amount = 1000000;
        
        Test.startTest();
        OpportunityValueWrapper oppValueWrapper = new OpportunityValueWrapper(opp);
        Boolean result = oppValueWrapper.isHighValue();
        Test.stopTest();
        
        System.assertEquals(true, result);
    }
    
    @isTest
    private static void testIsHighValueNegative() {
        Opportunity opp = [SELECT Amount FROM Opportunity];
        opp.Amount = 0;
        
        Test.startTest();
        OpportunityValueWrapper oppValueWrapper = new OpportunityValueWrapper(opp);
        Boolean result = oppValueWrapper.isHighValue();
        Test.stopTest();
        
        System.assertEquals(false, result);
    }
    
    @isTest
    private static void testIsExtremelyLowValuePositive() {
        Opportunity opp = [SELECT Amount FROM Opportunity];
        opp.Amount = 0;
        
        Test.startTest();
        OpportunityValueWrapper oppValueWrapper = new OpportunityValueWrapper(opp);
        Boolean result = oppValueWrapper.isExtremelyLowValue();
        Test.stopTest();
        
        System.assertEquals(true, result);
    }
    
    @isTest
    private static void testIsExtremelyLowValueNegative() {
        Opportunity opp = [SELECT Amount FROM Opportunity];
        opp.Amount = 120;
        
        Test.startTest();
        OpportunityValueWrapper oppValueWrapper = new OpportunityValueWrapper(opp);
        Boolean result = oppValueWrapper.isExtremelyLowValue();
        Test.stopTest();
        
        System.assertEquals(false, result);
    }
    
    @isTest
    private static void testCancelOpportunity() {
        Opportunity opp = [SELECT StageName, Description FROM Opportunity];
        
        System.assertEquals('Prospecting', opp.StageName);
        System.assertEquals(true, String.isBlank(opp.Description));
        
        Test.startTest();
        OpportunityValueWrapper oppValueWrapper = new OpportunityValueWrapper(opp);
        oppValueWrapper.cancelOpportunity();
        Test.stopTest();
        
        System.assertEquals('Closed Lost', opp.StageName);
        System.assertEquals('Opportunity of extremely low value. Not worth considering.', opp.Description);
    }
    
    @isTest
    private static void testAddHighValueDescription() {
        Opportunity opp = [SELECT Description FROM Opportunity];
        
        System.assertEquals(true, String.isBlank(opp.Description));
        
        Test.startTest();
        OpportunityValueWrapper oppValueWrapper = new OpportunityValueWrapper(opp);
        oppValueWrapper.addHighValueDescription();
        Test.stopTest();
        
        System.assertEquals(' THIS IS HIGH VALUE OPPORTUNITY. Take extra care!', opp.Description);
    }
}