@isTest
public class OpportunityTriggerHandlerTest {
    
    @TestSetup
    private static void prepareData() {
        Account acc = New Account(Name = 'TestAccount');
        insert acc;
        
        List<Opportunity> opps = new List<Opportunity>();
        
        // Opportunity with Account and high value
        Opportunity opp = new Opportunity(
        	Name = 'TestOpp HighVal',
        	Probability = 50,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(3),
            Amount = 1500000,
            AccountId = acc.id
        );
        opps.add(opp);
        
        // Opportunity with Account and extremely low value
		opp = new Opportunity(
        	Name = 'TestOpp LowVal',
        	Probability = 50,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(3),
            Amount = 0,
            AccountId = acc.id
        );
        opps.add(opp);
        
        insert opps;
    }

    @isTest
    private static void testBeforeInsertPositive() {
        List<Opportunity> opps = [SELECT AccountId, Description, Amount FROM Opportunity];
        
        Test.startTest();
        OpportunityTriggerHandler.beforeInsert(opps);
        Test.stopTest();
        
        Opportunity highValue = [SELECT Description FROM Opportunity WHERE Name = 'TestOpp HighVal'];
        System.assertEquals('THIS IS HIGH VALUE OPPORTUNITY. Take extra care!', highValue.Description);
        
        Account acc = [SELECT Id FROM Account];
        
        // there are two identical tasks inserted - one during TestSetup and second during testing
        Task task = [SELECT WhatId, Priority, Subject FROM Task LIMIT 1];
        System.assertEquals(acc.id, task.WhatId);
        System.assertEquals('High', task.Priority);
        System.assertEquals('Verify Account validity', task.Subject);
        
        Opportunity canceled = [SELECT StageName, Description FROM Opportunity WHERE Name = 'TestOpp LowVal'];
        System.assertEquals('Closed Lost', canceled.StageName);
        System.assertEquals('Opportunity of extremely low value. Not worth considering.', canceled.Description);
    }
    
    @isTest
    private static void testBeforeInsertNegative() {
        Exception thrownException;
        
        // Opportunity without Account
        Opportunity opp = new Opportunity(
        	Name = 'TestOpp NoAcc',
        	Probability = 50,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(3),
            Amount = 11550
        );
        
        Test.startTest();
        try {
            insert opp;
        
        } catch (Exception e) {
            thrownException = e;
        }
        Test.stopTest();
        
        System.assertEquals('System.DmlException', thrownException.getTypeName());
    }
}