public class AccountTriggerHandler extends TriggerHandler implements ITriggerHandler{
    private Map<Id, Account> newMap;
    private Map<Id, Account> oldMap;
    private List<Account> triggerNew;
    private List<Account> triggerOld;
    public AccountTriggerHandler() {
        this.newMap = (Map<Id, Account>) Trigger.newMap;
        this.oldMap = (Map<Id, Account>) Trigger.oldMap;
        this.triggerNew= (List<Account>) Trigger.New;
        this.triggerOld= (List<Account>) Trigger.Old;

    }
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }

    public override void beforeInsert() {
    }

    public override void afterInsert() {
        try{
            system.debug('account after insert trigger');
            system.debug('after insert trigger: '+System.IsBatch());
            if(triggerNew.size()>0){
                String newAccountsString= JSON.serialize(triggerNew);
                //AccountTriggerHandlerHelper.getEnterpriseInformation(newAccountsString);
                AP01_Account.getEnterpriseInformation(newAccountsString);
            }
        }catch(Exception ex){
            throw ex;
        }
    }

    public override void beforeUpdate() {
    }

    public override void afterUpdate() {
        try{
            
            if(!System.isFuture() && !System.isBatch()){
                system.debug('after update trigger');
                String oldAccountsString= JSON.serialize(triggerOld);
                String newAccountsString = JSON.serialize(triggerNew);
                //AccountTriggerHandlerHelper.updateEnterpriseInformation(newAccountsString,oldAccountsString);
                AP01_Account.getEnterpriseInformation(newAccountsString);
                
            }
            
        }catch(Exception ex){
                throw ex;
        }
    }

    public override void beforeDelete() {}

    public override void afterDelete() {}

    public override void afterUnDelete() {}
}