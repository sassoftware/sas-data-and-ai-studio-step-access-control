/*********************************************************************************************
    Copyright © 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
    SPDX-License-Identifier: Apache-2.0

    This script deletes all the rules that were created by running the
      Create-SAS-Authroization-Rules-For-Steps.sas script.
    
    If you decided against using the Create-SAS-Groups-For-Steps.sas script to create
      custom groups for the step access control, make sure to adjust the group names in the
      code below to match the groups you want to use for the access control rules. Search
      for - CHANGE GROUPS HERE.

*********************************************************************************************/

* Get the Viya Host URL;
%let viyaHost=%sysfunc(getoption(SERVICESBASEURL));

* This macro deletes an authorization rule by its ID;
%macro delete_rule_by_id(ruleID);
    %local ruleID;

    * https://developer.sas.com/rest-apis/authorization/deleteRule;
    proc http
        method = 'Delete'
        url = "&viyaHost./authorization/rules/&ruleID."
        oauth_bearer = sas_services;
    run; quit;

%mend delete_rule_by_id;

* This macro retrieves a list of rules associated with a group id and then calls the delete_rule_by_id macro and finally calls the delete_group macro;
%macro get_rules_for_group(groupID);
    %local groupID;

    filename rules temp;

    * https://developer.sas.com/rest-apis/authorization/getRules;
    proc http
        method = 'Get'
        url = "&viyaHost./authorization/rules?filter=eq(principal,'&groupID.')%nrstr(&)limit=1000"
        out = rules
        oauth_bearer = sas_services;
        headers 'Accept' = 'application/json';
    run; quit;

    libname rules json;

    data _null_;
        set rules.items;

        args = '%nrstr(%delete_rule_by_id(' || id || '))';
        call execute(args);
    run;

    libname rules clear;
    filename rules clear;
%mend get_rules_for_group;

* CHANGE GROUPS HERE;
* If you decided to bring your own groups then change the argument in the get_rules_for_group macro calls to match the groups you want to use for the access control rules;
* If you decided against implementing/using a specific group then please delete the corresponding macro call below;
%get_rules_for_group(SASStudioNone)
%get_rules_for_group(SASStudioBasic)
%get_rules_for_group(SASStudioAnalyst)
%get_rules_for_group(SASStudioEngineer)
%get_rules_for_group(SASStudioNoTextAnalytics)
%get_rules_for_group(SASStudioNoDecisioning)
%get_rules_for_group(SASStudioNoStatistics)
%get_rules_for_group(SASStudioNoQC)
%get_rules_for_group(SASStudioNoModelManager)
%get_rules_for_group(SASStudioNoEconometrics)
%get_rules_for_group(SASStudioNoOptimization)
%get_rules_for_group(SASStudioNoMachineLearning)
%get_rules_for_group(SASStudioNoForecasting)

/*
* Clean up;
%sysmacdelete delete_rule_by_id;
%sysmacdelete get_rules_for_group;
%symdel viyaHost;
*/