/*
@author Hoda Ibrahim
@date 28/10/2021
@description: get available products types
*/  
public with sharing class LC01_Products_Controller {
    public LC01_Products_Controller() {

    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getProductRecordTypes(){
        try {
            //get available product record types
            Map<String,String> productRecordTypes= new Map<String, String>();
            List<RecordType> recordTypes= [SELECT Id,Name 
                                                FROM RecordType 
                                                    WHERE sObjectType='Product2'];
            for(RecordType recType: recordTypes){
                productRecordTypes.put(recType.Id,recType.Name);
            }
            return productRecordTypes;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}