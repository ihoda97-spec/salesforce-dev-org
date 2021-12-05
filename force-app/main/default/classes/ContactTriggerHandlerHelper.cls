public with sharing class ContactTriggerHandlerHelper {
    public ContactTriggerHandlerHelper() {

    }
    public static void preventConsumerAccountMultipleContacts(List<Contact> oldContacts, List<Contact> newContacts){
    
        Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.ConsumerAccountType).getRecordTypeId();
        //get consumer accounts, and associated contacts
        Map<Id,Account> accounts = new Map<Id,Account>([SELECT Id, Name, (SELECT Name, AccountId,IsDeleted FROM Contacts WHERE IsDeleted=false) FROM Account Where RecordTypeId=:consumerRecordTypeId]);
        System.debug('consumer accounts');
        for(Integer i=0;i<newContacts.size();i++){
            //used for afterupdate trigger, if account id changes
            if(oldContacts!=NULL && oldContacts[i].AccountId==newContacts[i].AccountId){
                return;
            }
            if(oldContacts!=NULL && oldContacts.size()>0 && oldContacts[i].AccountId!=newContacts[i].AccountId){
                system.debug('current accounts contacts size is');
                // system.debug('account name: '+accounts.get(newContacts[i].AccountId).Name);
                // system.debug(accounts.get(newContacts[i].AccountId).Contacts.size());
                // System.debug(accounts.get(newContacts[i].AccountId).Contacts);
                if(accounts.containsKey(newContacts[i].AccountId) && accounts.get(newContacts[i].AccountId).Contacts.size()>0){
                    newContacts[i].addError('Consumer Account can only have one associated contact');
                }
            }
            //if selected account is a consumer account, and already have contacts, prevent user from adding the current contact
            else if(accounts.containsKey(newContacts[i].AccountId) && accounts.get(newContacts[i].AccountId).Contacts.size()>0){
                system.debug('current accounts contacts size is');
                // system.debug(accounts.get(newContacts[i].AccountId).Contacts.size());
                // System.debug(accounts.get(newContacts[i].AccountId).Contacts);
                newContacts[i].addError('Consumer Account can only have one associated contact');
            }
        }

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

            for(Integer i=0;i<newContracts.size();i++){
                // //system.debug(oldContracts[i].AccountId);
                // system.debug(newContracts[i].AccountId);
                // system.debug(oldContracts[i].AccountId==newContracts[i].AccountId);
                if(oldContracts!=NULL && oldContracts[i].AccountId==newContracts[i].AccountId){
                    return;
                }
                if(oldContracts!=NULL && oldContracts[i].AccountId!=newContracts[i].AccountId){
                    if(consumerAccountsIdsWithContracts.containsKey(newContracts[i].AccountId) && consumerAccountsIdsWithContracts.get(newContracts[i].AccountId)>Date.today()){
                        if(newContracts[i].StartDate<consumerAccountsIdsWithContracts.get(newContracts[i].AccountId)){
                            newContracts[i].addError('Consumer accounts can only have one active contract');  
                        }
                        
                    }    
                }
                else  if(consumerAccountsIdsWithContracts.containsKey(newContracts[i].AccountId) && consumerAccountsIdsWithContracts.get(newContracts[i].AccountId)>Date.today()){
                    if(newContracts[i].StartDate<consumerAccountsIdsWithContracts.get(newContracts[i].AccountId)){
                        newContracts[i].addError('Consumer accounts can only have one active contract');  
                    }
                }   
            }
        }catch(Exception ex){
            throw ex;
        }
    }
    public static void preventConsumerAccountsMultipleContractLineItems(List<ContractLineItem> newContracts){
        try{
            Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.ConsumerAccountType).getRecordTypeId();
            //non-expired contracts with consumer accounts
            List<ServiceContract> consumerAccountsContracts= [SELECT Id, Name, Account.Id, EndDate, (SELECT Id FROM ContractLineItems) FROM ServiceContract WHERE Account.RecordTypeId=:consumerRecordTypeId AND EndDate>=:Date.today()];

            Map<Id,ServiceContract> consumerAccountsWithContractsMap= new Map<Id,ServiceContract>();//id= servicecontractid
            for(ServiceContract contract:consumerAccountsContracts){
                consumerAccountsWithContractsMap.put(contract.Id,contract);
            }
            system.debug(consumerAccountsWithContractsMap);
            Map<Id,ServiceContract> serviceContractForNewContractLineItems= new Map<Id,ServiceContract>();
            Map<Id,ServiceContract> allActiveServiceContracts= new Map<Id,ServiceContract>([SELECT Id, Account_Type__c FROM ServiceContract WHERE EndDate>=:Date.today()]);
            for(Integer i=0;i<newContracts.size();i++){
                system.debug(newContracts[i].ServiceContract.Account_Type__c);
                if(consumerAccountsWithContractsMap.containsKey(newContracts[i].ServiceContractId) && consumerAccountsWithContractsMap.get(newContracts[i].ServiceContractId).ContractLineItems.size()>0){
                    //system.debug();
                    newContracts[i].addError('Consumers Cant rent more than one vehicle');
                }else if(allActiveServiceContracts.get(newContracts[i].ServiceContractId).Account_Type__c=='Consumer'){
                    if(serviceContractForNewContractLineItems.containsKey(newContracts[i].ServiceContractId)){
                        newContracts[i].addError('Consumers Cant rent more than one vehicle');
                    }else{
                        serviceContractForNewContractLineItems.put(newContracts[i].ServiceContractId,allActiveServiceContracts.get(newContracts[i].ServiceContractId));
                    }
                }
            }
        }catch(Exception ex){
            throw ex;
        }
    }
}