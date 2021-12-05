/*
@author Hoda Ibrahim
@date 28/10/2021
@description: prevent adding multiple contacts to consumer accounts
*/ 
public with sharing class AP01_Contact {
    public AP01_Contact() {

    }
    public static void preventConsumerAccountMultipleContacts(List<Contact> oldContacts, List<Contact> newContacts){
    
        Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.ConsumerAccountType).getRecordTypeId();
        //get consumer accounts, and associated contacts
        Map<Id,Account> accounts = new Map<Id,Account>([SELECT Id, RecordTypeId, Name, (SELECT Name, AccountId,IsDeleted FROM Contacts WHERE IsDeleted=false) FROM Account Where RecordTypeId=:consumerRecordTypeId]);
        //handle data in bulk
        List<Id> currentConsumerAccounts= new List<Id>();//key=accountId, value= recordTypeId 
        for(Integer i=0;i<newContacts.size();i++){
            //to handle contacts in bulk
            if(currentConsumerAccounts.size()>0 && currentConsumerAccounts.contains(newContacts[i].AccountId)){
                newContacts[i].addError('Consumer Account can only have one associated contact');
            }else if(accounts.containsKey(newContacts[i].AccountId)){
                currentConsumerAccounts.add(newContacts[i].AccountId);
            }
            //used for afterupdate trigger, if account id changes
            if(oldContacts!=NULL && oldContacts[i].AccountId==newContacts[i].AccountId){
                return;
            }
            if(oldContacts!=NULL && oldContacts.size()>0 && oldContacts[i].AccountId!=newContacts[i].AccountId){
              
                if(accounts.containsKey(newContacts[i].AccountId) && accounts.get(newContacts[i].AccountId).Contacts.size()>0){
                    newContacts[i].addError('Consumer Account can only have one associated contact');
                }
            }
            //if selected account is a consumer account, and already have contacts, prevent user from adding the current contact
            else if(accounts.containsKey(newContacts[i].AccountId) && accounts.get(newContacts[i].AccountId).Contacts.size()>0){
             
                newContacts[i].addError('Consumer Account can only have one associated contact');
            }
        }

    }
}