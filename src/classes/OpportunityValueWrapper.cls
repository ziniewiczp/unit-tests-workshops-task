public class OpportunityValueWrapper {
    public static final Decimal HIGH_VALUE_AMOUNT = 10000;
    public static final Decimal VERY_LOW_VALUE_AMOUNT = 100;
    private Opportunity opp;
    
    public OpportunityValueWrapper(Opportunity opp) {
        this.opp = opp;
    }
    
    public Opportunity getRecord() {
        return opp;
    }
    
    public Boolean validateOpportunityAccount() {
        if (String.isBlank(opp.AccountId)) {
            opp.addError('You tried to create opp ' + opp.Name + ' without selecting Account!');
            return false;
        }
        return true;
    }
    
    public Boolean isHighValue() {
        return (opp.Amount > HIGH_VALUE_AMOUNT);
    }
    
    public Boolean isExtremelyLowValue() {
        return (opp.Amount < VERY_LOW_VALUE_AMOUNT);
    }
    
    public void cancelOpportunity() {
        opp.StageName = 'Closed Lost';
        if(opp.Description == null)
            opp.Description = '';
        
        opp.Description += 'Opportunity of extremely low value. Not worth considering.';
    }
    
    public void addHighValueDescription() {
        if(opp.Description == null)
            opp.Description = '';
        
        opp.Description += ' THIS IS HIGH VALUE OPPORTUNITY. Take extra care!';
    }
}