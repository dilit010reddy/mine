public with sharing class GenerateDeveloperInvoiceController {

    public List<DeveloperInfo> diViewList {get;set;}
    public Id accId{get;set;}
    public String accName {get;set;}
    public String accQBInvoiceDate {get;set;}
    public String firstOfNextMonth {get;set;}
    public String middleOfNextMonth {get;set;}
    public Decimal invoiceGrandTotal {get;set;}
    public String remit1 {get;set;}
    public String remit3 {get;set;}
    public String remit4 {get;set;}
    public String emailHG {get;set;}
    public String accPhone {get;set;}
    public String devAcct {get;set;}
    public String accAddress {get;set;}
    public String accCSZ {get;set;}
    public string statementno {get;set;}

    public GenerateDeveloperInvoiceController() {
        Id accId = apexpages.currentpage().getparameters().get('accId');
        Account sourceAccount = [
            SELECT Name, Remit_1__c, Remit_3__c, Remit_4__c, QB_Invoice_Date__c, HG_Association_Email__c, DevAcct__c, HG_Management_Address__c, HG_Management_City_State_Zip__c, HG_Management_Phone__c
            FROM Account
            WHERE Id =: accId
        ];
        accName = sourceAccount.Name;
        accQBInvoiceDate = sourceAccount.QB_Invoice_Date__c;
        remit1 = sourceAccount.Remit_1__c;
        remit3 = sourceAccount.Remit_3__c;
        remit4 = sourceAccount.Remit_4__c;
        emailHG = sourceAccount.HG_Association_Email__c;
        accPhone = sourceAccount.HG_Management_Phone__c;
        devAcct = sourceAccount.DevAcct__c;
        accAddress = sourceAccount.HG_Management_Address__c;
        accCSZ = sourceAccount.HG_Management_City_State_Zip__c;

        firstOfNextMonth = System.today().addMonths(1).toStartOfMonth().format();
        middleOfNextMonth = System.today().addMonths(1).toStartOfMonth().addDays(14).format();
        statementno = '';
        if (System.today().addMonths(1).month() < 10) 
            statementno = '0';
        statementno += String.valueOf(System.today().addMonths(1).month());
        statementno += String.valueOf(System.today().addMonths(1).year()).right(2);        


        List<Developer_Billing_Data__c> dbdList = [SELECT Id, 
                            ResidentTransactionKey__c, 
                            ResidentKey__c, 
                            ret_Transaction__c, 
                            ret_Posted__c, 
                            ret_PostCode__c, 
                            ret_Amount__c, 
                            ret_Memo__c, 
                            UnitKey__c, 
                            u_StreetName__c, 
                            u_StreetNumber__c, 
                            u_UnitNumber__c, 
                            u_Lot__c, 
                            CompanyKey__c, 
                            CommunityKey__c, 
                            co_Name__c, 
                            DeveloperKey__c, 
                            d_Name__c, 
                            d_Address__c, 
                            d_Address2__c, 
                            d_City__c, 
                            d_State__c, 
                            d_Zipcode__c, 
                            BalanceForward__c, 
                            Account__r.Name, 
                            Developer_Unit_Key__c 
                        FROM Developer_Billing_Data__c 
                        WHERE Account__c =: accId
                        ORDER BY DeveloperKey__c, UnitKey__c, ret_Amount__c DESC];
        
        // Key UnitKey__c -> List BillingData
        Map<Integer, List<BillingData>> unitKeyToBillingDataMap = new Map<Integer, List<BillingData>>();
        // Key DeveloperKey__c -> List Unit
        Map<Integer, List<Unit>> developerToUnitMap = new Map<Integer, List<Unit>>();
        // Key DeveloperKey__c -> List DeveloperInfo
        Map<Integer, DeveloperInfo> developerKeyToDeveloperInfoMap = new Map<Integer, DeveloperInfo>();
        Set<Decimal> unitKeysAdded = new Set<Decimal>();
        Set<String> itemPostCodeAdded = new Set<String>();
        // Key Item ret_PostCode__c -> List BillingData
        Map<String, List<BillingData>> itemPostCodeToBillingDataMap = new Map<String, List<BillingData>>();
        // Key DeveloperKey__c -> List Item
        Map<Integer, List<Item>> developerToItemMap = new Map<Integer, List<Item>>();

        for (Developer_Billing_Data__c currentDBD : dbdList) {
            if (!unitKeyToBillingDataMap.containsKey((Integer)currentDBD.UnitKey__c)) {
                unitKeyToBillingDataMap.put((Integer)currentDBD.UnitKey__c, new List<BillingData>());
            }
            unitKeyToBillingDataMap.get((Integer)currentDBD.UnitKey__c).add(new BillingData(currentDBD));
            if(!unitKeysAdded.contains(currentDBD.UnitKey__c)){
                if (!developerToUnitMap.containsKey((Integer)currentDBD.DeveloperKey__c)) {
                    developerToUnitMap.put((Integer)currentDBD.DeveloperKey__c, new List<Unit>());
                } 
                developerToUnitMap.get((Integer)currentDBD.DeveloperKey__c).add(new Unit(currentDBD));
                unitKeysAdded.add(currentDBD.UnitKey__c);
            }
            // Populate item post code to developer billing map 
            if (!itemPostCodeToBillingDataMap.containsKey(currentDBD.ret_PostCode__c)) {
                itemPostCodeToBillingDataMap.put(currentDBD.ret_PostCode__c, new List<BillingData>());
            }
            itemPostCodeToBillingDataMap.get(currentDBD.ret_PostCode__c).add(new BillingData(currentDBD));
            if(!itemPostCodeAdded.contains(currentDBD.ret_PostCode__c)){
                if (!developerToItemMap.containsKey((Integer)currentDBD.DeveloperKey__c)) {
                    developerToItemMap.put((Integer)currentDBD.DeveloperKey__c, new List<Item>());
                } 
                developerToItemMap.get((Integer)currentDBD.DeveloperKey__c).add(new Item(currentDBD));
                itemPostCodeAdded.add(currentDBD.ret_PostCode__c);
            }

            developerKeyToDeveloperInfoMap.put((Integer)currentDBD.DeveloperKey__c, new DeveloperInfo(currentDBD));
        }

        // Populate the BillingData list on existing Units
        for(List<Unit> lu : developerToUnitMap.values()){
            for (Unit u : lu) {
                u.bdList = unitKeyToBillingDataMap.get(u.UnitKey);
                for(BillingData bd : u.bdList){
                    u.AggregateTotal += bd.ret_Amount;
                }
            }
        }

        invoiceGrandTotal = 0.0;
        // Populate the Unit list on existing DeveloperInfo
        for(DeveloperInfo di : developerKeyToDeveloperInfoMap.values()) {
            di.units = developerToUnitMap.get(di.DeveloperKey);
            for(Unit u : di.units){
                di.AggregateTotal += u.AggregateTotal;
            }
            invoiceGrandTotal += di.AggregateTotal;
        }

        // Populate the BillingData list on existing Items
        for(List<Item> li : developerToItemMap.values()){
            for (Item i : li) {
                i.bdList = itemPostCodeToBillingDataMap.get(i.ret_PostCode);
            }
        }
        // Populate the Item list on existing DeveloperInfo
        for(DeveloperInfo di : developerKeyToDeveloperInfoMap.values()) {
            di.items = developerToItemMap.get(di.DeveloperKey);
        }

        // Create list of Developer Infos for display
        diViewList = developerKeyToDeveloperInfoMap.values();
 
    }

    public class DeveloperInfo{
        public Integer DeveloperKey{get;set;}
        public String d_Name{get;set;}
        public String d_Address{get;set;}
        public String d_Address2{get;set;}
        public String d_City{get;set;}
        public String d_State{get;set;}
        public String d_Zipcode{get;set;}
        public Decimal AggregateTotal{get;set;}
        public List<Unit> units{get;set;}
        public List<Item> items{get;set;}

        public DeveloperInfo(Developer_Billing_Data__c dbd) {
            this.DeveloperKey = (Integer)dbd.DeveloperKey__c;
            this.d_Name = dbd.d_Name__c;
            this.d_Address = dbd.d_Address__c;
            this.d_Address2 = dbd.d_Address2__c;
            this.d_City = dbd.d_City__c;
            this.d_State = dbd.d_State__c;
            this.d_Zipcode = dbd.d_Zipcode__c;
            this.AggregateTotal = 0.0;
            this.units = new List<Unit>();
            this.items = new List<Item>();
        }
    }

    public class Unit{
        public Integer UnitKey{get;set;}
        public String u_StreetName{get;set;}
        public String u_StreetNumber{get;set;}
        public String u_UnitNumber{get;set;}
        public String u_Lot{get;set;}
        public List<BillingData> bdList{get;set;}
        public Decimal AggregateTotal{get;set;}

        public Unit(Developer_Billing_Data__c dbd) {
            this.UnitKey = (Integer)dbd.UnitKey__c;
            this.u_StreetName = dbd.u_StreetName__c;
            this.u_StreetNumber = dbd.u_StreetNumber__c;
            this.u_UnitNumber = dbd.u_UnitNumber__c;
            this.u_Lot = dbd.u_Lot__c;
            this.bdList = new List<BillingData>();
            this.AggregateTotal = 0.0;
        }
    }

    public class BillingData{
        public Decimal ret_Amount{get;set;}
        public Date ret_Transaction{get;set;}
        public Decimal BalanceForward{get;set;}
        public Date ret_Posted{get;set;}
        public String ret_PostCode{get;set;}
        public String ret_Memo{get;set;}
        public String u_StreetName{get;set;}
        public String u_StreetNumber{get;set;}
        public String u_UnitNumber{get;set;}

        public BillingData(Developer_Billing_Data__c dbd) {
            this.ret_Amount = dbd.ret_Amount__c;
            this.ret_Transaction = dbd.ret_Transaction__c;
            this.BalanceForward = dbd.BalanceForward__c;
            this.ret_Posted = dbd.ret_Posted__c;
            this.ret_PostCode = dbd.ret_PostCode__c;
            this.ret_Memo = dbd.ret_Memo__c;
            this.u_StreetName = dbd.u_StreetName__c;
            this.u_StreetNumber = dbd.u_StreetNumber__c;
            this.u_UnitNumber = dbd.u_UnitNumber__c;
        }
    }

    public class Item {
        public String ret_PostCode{get;set;}
        public List<BillingData> bdList{get;set;}

        public Item (Developer_Billing_Data__c dbd) {
            this.ret_PostCode = dbd.ret_PostCode__c;
            this.bdList = new List<BillingData>();
        }
    }

}