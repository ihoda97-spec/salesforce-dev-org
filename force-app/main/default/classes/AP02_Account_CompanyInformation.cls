public with sharing class AP02_Account_CompanyInformation {
    public AP02_Account_CompanyInformation() {

    }
    public String logo;
    public AP03_Account_CompanyInformation_Organization organization;

    public class AP03_Account_CompanyInformation_Organization{
        public Integer approxEmployees;
        public Integer founded;// year founded
        public String overview;//biography
        public AP04_Account_CompanyInformation_Organization_ContactInformation contactInfo;
        public AP03_Account_CompanyInformation_Organization(){

        }

        
    }
    public class AP04_Account_CompanyInformation_Organization_ContactInformation{
        public List<AP05_Account_CompanyInformation_Organization_ContactInformation_Address> addresses;
        public AP04_Account_CompanyInformation_Organization_ContactInformation(){

        }
    }
    public class AP05_Account_CompanyInformation_Organization_ContactInformation_Address{
        public String addressLine1;
        public AP05_Account_CompanyInformation_Organization_ContactInformation_Address(){

        }
    }
}