public without sharing class FieldUsage_LWC {
   @AuraEnabled(cacheable=true)
   public static Map<String, String> getAllFields(String objectAPIName){
       try {
            Map<String, String> mLabelToAPI = new Map<String, String>();
            SObjectType dynamicType = Schema.getGlobalDescribe().get(objectAPIName);
            Map<String, Schema.SObjectField> schemaFieldMap;
            if(objectAPIName != null){
                schemaFieldMap = dynamicType.getDescribe().fields.getMap();
            } else {
                return new Map<String, String>();
            }
            for(String s : schemaFieldMap.keySet()){
                if(s.endsWith('__c')){
                    mLabelToAPI.put(schemaFieldMap.get(s).getDescribe().getLabel(), s);
                }
            }
            return mLabelToAPI;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
   }

   @AuraEnabled
   public static List<FieldUsage> getUsageNumbers(List<String> lFieldAPINames, String objectAPIName){
        try {
            SObjectType dynamicType = Schema.getGlobalDescribe().get(objectAPIName);
            Map<String, Schema.SObjectField> schemaFieldMap;
            if(objectAPIName != null){
                schemaFieldMap = dynamicType.getDescribe().fields.getMap();
            } else {
                return new List<FieldUsage>();
            }
            Integer totalCount = Database.countQuery('SELECT Count() FROM ' + objectAPIName);
            List<FieldUsage> lFieldUsage = new List<FieldUsage>();
            for(String apiName : lFieldAPINames){
                    String label = schemaFieldMap.get(apiName).getDescribe().getLabel();
                    Integer total = Database.countQuery('SELECT COUNT() FROM ' + objectAPIName + ' WHERE ' + apiName + ' != null');
                    FieldUsage usage = new FieldUsage();
                    usage.label = label;
                    usage.apiName = apiName;
                    if(total > 0 && total/totalCount < 1){
                        usage.percentage = '<1%';
                    } else {
                        usage.percentage = String.valueOf(total/totalCount) + '%';
                    }
                    usage.total = total;
                    lFieldUsage.add(usage);
            }
            return lFieldUsage;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class FieldUsage {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String apiName;
        @AuraEnabled
        public String percentage;
        @AuraEnabled
        public Integer total;
    }
}
