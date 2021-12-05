/*
@author Hoda Ibrahim
@date 28/10/2021
@description: prevent consumer account from having multiple service contracts that are active at the same time
*/ 
public with sharing class AP01_ServiceContract {
    public AP01_ServiceContract() {

    }
    public static void preventConsumerAccountMultipleServiceContracts(List<ServiceContract> oldContracts, List <ServiceContract> newContracts){
        try{
            Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.ConsumerAccountType).getRecordTypeId();
            //non-expired contracts with consumer accounts
            List<ServiceContract> consumerAccountsContracts= [SELECT Id, Account.Id, EndDate FROM ServiceContract WHERE Account.RecordTypeId=:consumerRecordTypeId AND EndDate>=:Date.today()];
            Map<Id,Date> consumerAccountsIdsWithContracts= new Map<Id,Date>();//id= account id, date: contract end date
            for(ServiceContract contract: consumerAccountsContracts){
                consumerAccountsIdsWithContracts.put(contract.AccountId,contract.EndDate);
            }
            system.debug('consumerAccountsIdsWithContracts');
            system.debug(consumerAccountsIdsWithContracts);
            for(Integer i=0;i<newContracts.size();i++){
                //only check the trigger if contract is assigned to different account
                if(oldContracts!=NULL && oldContracts[i].AccountId==newContracts[i].AccountId){
                    return;
                }
                if(oldContracts!=NULL && oldContracts[i].AccountId!=newContracts[i].AccountId){
                    if(consumerAccountsIdsWithContracts.containsKey(newContracts[i].AccountId) && consumerAccountsIdsWithContracts.get(newContracts[i].AccountId)>=Date.today()){
                        if(newContracts[i].StartDate<consumerAccountsIdsWithContracts.get(newContracts[i].AccountId)){
                            newContracts[i].addError('Consumer accounts can only have one active contract');  
                        }
                        
                    }    
                }
                else  if(consumerAccountsIdsWithContracts.containsKey(newContracts[i].AccountId) && consumerAccountsIdsWithContracts.get(newContracts[i].AccountId)>=Date.today()){
                    if(newContracts[i].StartDate<consumerAccountsIdsWithContracts.get(newContracts[i].AccountId)){
                        newContracts[i].addError('Consumer accounts can only have one active contract');  
                    }
                }   
            }
        }catch(Exception ex){
            throw ex;
        }
    }
}