/*
@author Hoda Ibrahim
@date 28/10/2021
@description: automatically fill enterprise information using future callout on the enterprise's website
*/ 
public with sharing class AP01_Account {
    public AP01_Account() {

    }
    @future(callout=true)
    public static void getEnterpriseInformation(String newAccountsString){
        try{
            List<Account> accountList = (List<Account>)Json.deserialize(newAccountsString,List<Account>.class);
            List<Account> oldAccountList= new List<Account>();
            Id enterpriseRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.EnterpriseAccountType).getRecordTypeId();
            List<Account> accountsToBeInserted= new List<Account>();
            List<Account> accountsToBeUpdated= new List<Account>();
            for(Integer i=0;i <accountList.size();i++){
                if(accountList[i].RecordTypeId==enterpriseRecordTypeId){
                    Http http = new Http();
                    HttpRequest request= new HttpRequest();
                    //pass company's website to retrieve important information about company
                    string urlToBeRequested=System.label.EnterpriseInformationURL+'&domain='+accountList[i].Website;
                    system.debug('url to be requested is '+ urlToBeRequested);
                    //send get request
                    request.setEndpoint(urlToBeRequested);
                    request.setMethod('GET');
                    
                    HttpResponse response= http.send(request);
                    Type resultType = Type.forName('AP02_Account_CompanyInformation');
                    //fill in company's information and add account to accountsTobeInserted
                    AP02_Account_CompanyInformation companyInfo= (AP02_Account_CompanyInformation)JSON.deserialize(response.getBody(), resultType);
                    System.debug('after deserialization');
                    System.debug(companyInfo);
                    
                    ApexPages.PageReference ref = new ApexPages.PageReference(companyInfo.logo);
                    accountList[i].LogoUrl__c=ref.getUrl();
                    System.debug('logo url: '+companyInfo.logo);
                    System.debug('Account Logo url: '+ accountList[i].LogoUrl__c);
    
                    accountList[i].NumberOfEmployees=companyInfo.organization.approxEmployees;
                    System.debug('number of employees:'+ companyInfo.organization.approxEmployees);
                    system.debug('Account Number Of Employees:' + accountList[i].NumberOfEmployees);
    
                    accountList[i].Founded__c=companyInfo.organization.founded;
                    System.debug('year founded:'+ companyInfo.organization.founded);    
                    system.debug('Account Founded:' + accountList[i].Founded__c);
    
                    accountList[i].Address__c=companyInfo.organization.contactInfo.addresses[0].addressLine1;
                    System.debug('Address: '+ companyInfo.organization.contactInfo.addresses[0].addressLine1);
                    system.debug('Account Address:' + accountList[i].Address__c);
    
                    accountList[i].Biography__c=companyInfo.organization.overview;
                    System.debug('biography: '+ companyInfo.organization.overview);
                    system.debug('Account Biography:' + accountList[i].Biography__c);
                    accountsToBeInserted.add(accountList[i]);
                }
                       
               
            }
            if(accountsToBeInserted.size()>0){
                update accountsToBeInserted;
            }
        }catch(Exception ex){
            throw ex;
        }
    }
    @future(callout=true)
    public static void updateEnterpriseInformation(String newAccountsString, String oldAccountsString){
        try{
            List<Account> accountList = (List<Account>)Json.deserialize(newAccountsString,List<Account>.class);
            List<Account> oldAccountList= new List<Account>();
            Id enterpriseRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.label.EnterpriseAccountType).getRecordTypeId();
            if(oldAccountsString!=''){
                    oldAccountList=(List<Account>)Json.deserialize(oldAccountsString,List<Account>.class);
            }
            system.debug('account after deserializing');
            system.debug(accountList);
            List<Account> accountsToBeUpdated= new List<Account>();
            //List<Account> accountsToBeUpdated= new List<Account>();
            for(Integer i=0;i <accountList.size();i++){
                //only enter this trigger if account's website is changed
                if(oldAccountList.size()>0 && oldAccountList[i].Website!=accountList[i].Website){
                    if(accountList[i].RecordTypeId==enterpriseRecordTypeId){
                        Http http = new Http();
                        HttpRequest request= new HttpRequest();
                        //pass company's website to retrieve important information about company
                        string urlToBeRequested=System.label.EnterpriseInformationURL+'&domain='+accountList[i].Website;
                        system.debug('url to be requested is '+ urlToBeRequested);
                        
                        //send get request
                        request.setEndpoint(urlToBeRequested);
                        request.setMethod('GET');      
                        HttpResponse response= http.send(request);
                        
                        //fill in company's information and add account to accountsTobeInserted
                        Type resultType = Type.forName('AP02_Account_CompanyInformation');
                        AP02_Account_CompanyInformation companyInfo= (AP02_Account_CompanyInformation)JSON.deserialize(response.getBody(), resultType);
                        System.debug('after deserialization');
                        System.debug(companyInfo);
                        
                        ApexPages.PageReference ref = new ApexPages.PageReference(companyInfo.logo);
                        accountList[i].LogoUrl__c=ref.getUrl();
                        System.debug('logo url: '+companyInfo.logo);
                        System.debug('Account Logo url: '+ accountList[i].LogoUrl__c);
        
                        accountList[i].NumberOfEmployees=companyInfo.organization.approxEmployees;
                        System.debug('number of employees:'+ companyInfo.organization.approxEmployees);
                        system.debug('Account Number Of Employees:' + accountList[i].NumberOfEmployees);
        
                        accountList[i].Founded__c=companyInfo.organization.founded;
                        System.debug('year founded:'+ companyInfo.organization.founded);    
                        system.debug('Account Founded:' + accountList[i].Founded__c);
        
                        accountList[i].Address__c=companyInfo.organization.contactInfo.addresses[0].addressLine1;
                        System.debug('Address: '+ companyInfo.organization.contactInfo.addresses[0].addressLine1);
                        system.debug('Account Address:' + accountList[i].Address__c);
        
                        accountList[i].Biography__c=companyInfo.organization.overview;
                        System.debug('biography: '+ companyInfo.organization.overview);
                        system.debug('Account Biography:' + accountList[i].Biography__c);
                        accountsToBeUpdated.add(accountList[i]);
                    }
                    
                }
               
            }
            if(accountsToBeUpdated.size()>0){
                update accountsToBeUpdated;
            }
        }catch(Exception ex){
            throw ex;
        }
    }
}