@isTest
public class OpportunityTriggerHandlerTest {

    @isTest
    private static void testBeforeInsertPositive() {
        Account acc = New Account(Name = 'TestAccount');
        insert acc;

        List<Opportunity> opps = new List<Opportunity>();

        // Opportunity with Account and high value
        Opportunity opp = new Opportunity(
        	Name = 'TestOpp HighVal',
        	Probability = 50,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(3),
            Amount = OpportunityValueWrapper.HIGH_VALUE_AMOUNT + 1,
            AccountId = acc.id
        );
        opps.add(opp);

        // Opportunity with Account and extremely low value
		opp = new Opportunity(
        	Name = 'TestOpp LowVal',
        	Probability = 50,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(3),
            Amount = OpportunityValueWrapper.VERY_LOW_VALUE_AMOUNT - 1,
            AccountId = acc.id
        );
        opps.add(opp);

        Test.startTest();
        insert opps;
        Test.stopTest();

        Opportunity highValue = [SELECT Description FROM Opportunity WHERE Name = 'TestOpp HighVal'];
        System.assertEquals('THIS IS HIGH VALUE OPPORTUNITY. Take extra care!', highValue.Description);

        Task task = [SELECT WhatId, Priority, Subject FROM Task];
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
