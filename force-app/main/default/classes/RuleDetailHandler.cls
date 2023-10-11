public class RuleDetailHandler {
	public void onBeforeUpdate(list<Rule_Detail__c> ruleDetails){
      if(TriggerStatus.shouldRunTrigger()){
        RuleDetailHelper helper = new RuleDetailHelper();
        helper.PopulateRevisedDate(trigger.new);
      }
   }
   
    public void onAfterUpdate(list<Rule_Detail__c> ruleDetails, Map<Id,Rule_Detail__c> oldruleDetailMap){
      if(TriggerStatus.shouldRunTrigger()){
        RuleDetailHelper helper = new RuleDetailHelper();
        helper.DisableactiveRuleDetails(trigger.new);
        helper.DisableactiveRule(trigger.new,oldruleDetailMap);
      }
  }
}