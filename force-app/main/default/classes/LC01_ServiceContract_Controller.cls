/*
@author Hoda Ibrahim
@date 28/10/2021
@description: assigns service contract to the convienient pricebook based on the account type
*/ 
public with sharing class LC01_ServiceContract_Controller {
    public LC01_ServiceContract_Controller() {

    }
    @AuraEnabled
    public static String updateContractPriceBookByAccountType(Id serviceContractId){
        try {
            Id priceBookId;
            Boolean updateContract=false;
            
            system.debug('SELECT Account.Id, Account_Type__c, PriceBook2Id, StartDate, EndDate, Account.RecordType.Name FROM ServiceContract WHERE Id=:serviceContractId LIMIT 1');
            ServiceContract contract = [SELECT Account.Id, Account_Type__c, PriceBook2Id, StartDate, EndDate, Account.RecordType.Name FROM ServiceContract WHERE Id=:serviceContractId LIMIT 1][0];
            system.debug(contract);
            system.debug('record type name');
            system.debug(contract.Account.RecordType.Name);
            system.debug(contract!=NULL);
            if(contract!=NULL){
                Id accountId=contract.Account.Id;
                Account account= [SELECT RecordType.Name FROM Account WHERE Id=:accountId];
                system.debug('account');
                system.debug(account);
              
                PriceBook2 priceBook;
                if(account.RecordType.Name == System.label.EnterpriseAccountType){
                      //get pricebook id for enterprise 
                     priceBook=[SELECT Id FROM Pricebook2 WHERE Name=:System.label.EnterprisePriceBook LIMIT 1][0];
                }
                else{
                    // get standard price book id
                    priceBook=[SELECT Id FROM Pricebook2 WHERE Name=:System.label.StandardPriceBook LIMIT 1][0];
                }
                if(priceBook!=NULL){
                    priceBookId=priceBook.Id;
                    if(contract.PriceBook2Id!=priceBookId){
                        contract.PriceBook2Id=priceBookId;
                        system.debug('contracts price book id is '+ contract.PriceBook2Id);
                        system.debug('chosen price book id is '+priceBookId);
                        updateContract=true;
                    }
                }
                if(contract.Account_Type__c==NULL){
                    contract.Account_Type__c=contract.Account.RecordType.Name;
                    updateContract=true;
                }
                if(updateContract){
                    update contract;
                }
            }
            return JSON.serialize(contract);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}