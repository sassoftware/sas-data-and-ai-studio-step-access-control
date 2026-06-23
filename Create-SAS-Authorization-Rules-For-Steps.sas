/*********************************************************************************************
    Copyright © 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
    SPDX-License-Identifier: Apache-2.0

    Please read the following disclaimers before using this script:
    1. If you decided against using the Create-SAS-Groups-For-Steps.sas script to create
        custom groups for the step access control, make sure to adjust the group names in the
        code below to match the groups you want to use for the access control rules. Search
        for - CHANGE GROUPS HERE.
    1. This script is using undocumented API endpoints in order to automate everything
        (namely they are /dataFlows/steps and /dataFlows/stepCategories).
    2. The csv file provided that enables you to also disable steps not just on the
        general SAS Data and AI Studio tier (Basic/Analyst/Engineer) but further down
        limiting step availability around SAS Visual Statistics, SAS Optimization, etc.
    3. As new steps are introduced into the SAS Data and AI Studio you will have to rerun
        this after every version update of SAS Viya that you do.
    4. There is three SAS macro variables just below this comment block that you will have
        to adjust before running the script in your environment. Their explanation is provided
        directly above the definition of the macro variable.

*********************************************************************************************/

* Specify where the csv it is located sasserver (File Server) vs sascontent (SAS Content);
%let specifyLocation = sasserver;
* Specify the path to the steps access control csv file;
%let pathToAccessFile = /export/pvs/sasdata/homes/gerdaw/Data;
* Specify the file name;
%let nameOfFile = Steps_Access_Control.csv;

* Get the Viya Host URL;
%let viyaHost=%sysfunc(getoption(SERVICESBASEURL));

* Get the steps available in the environment;
filename steps temp;

* Please note this API endpoint is not publicly documented;
proc http
    method = 'Get'
    url = "&viyaHost/dataFlows/steps?limit=10000"
    out = steps
    oauth_bearer = sas_services;
    headers 'Accept' = 'application/json';
run; quit;

libname steps json;

* Get the step categories available in the environment;
filename catego temp;

* Please note this API endpoint is not publicly documented;
proc http
    method = 'Get'
    url = "&viyaHost/dataFlows/stepCategories?limit=10000"
    out = catego
    oauth_bearer = sas_services;
    headers 'Accept' = 'application/json';
run; quit;

libname catego json;

* Retrieve the results from the two API calls and turn them into tables;
proc sql;
    create table work.all_steps_with_categories as
        select a.id,
            a.localDisplayName as stepName,
            a.localDescription as stepDescription,
            a.createdBy,
            a.categoryId,
            b.localDisplayName as categoryName
            from steps.items as a
                left join catego.items as b
                    on a.categoryId EQ b.id;

    create table work.sas_steps_only as
        select *
            from work.all_steps_with_categories
                where createdBy contains 'sas.';
run; quit;

libname steps clear;
filename steps clear;
libname catego clear;
filename catego clear;

* Assign a filename for the access control csv file depending on the storage location;
%if &specifyLocation. EQ sascontent %then %do;
    filename aclFN filesrvc folderPath="&pathToAccessFile." filename="&nameOfFile.";
%end;
%else %do;
    filename aclFN "&pathToAccessFile./&nameOfFile.";
%end;

* Import the access control csv file;
proc import
    dataFile = aclFN
    dbms = CSV
    out = work.step_access_list
    replace;
    guessingRows=MAX;
    getNames = YES;
run; quit;

filename aclFN clear;

* Create a joined table with all the information about available steps and recommended access control;
proc sql;
    create table work.sas_steps_with_access as
        select a.*,
            b.*
            from work.sas_steps_only as a
                left join work.step_access_list as b
                    on a.stepName eq b.step;
run; quit;

title 'Table of all the SAS provided steps in your environment';
proc print data=work.sas_steps_with_access(keep=stepName stepDescription categoryName) noObs;
run; quit;
title;

* Macro that applies the authorization rules for the steps;
%macro apply_rule(principal, objectURI, principalType=group);
    %local principal
        objectURI
        principalType;

    filename in temp;

    data _null_;
        file in;
        put '{';
        put '"type": "prohibit",';
        put '"permissions": ["read"],';
        principalType =  '"principalType": "' || "&principalType." || '",';
        put principalType;
        principal = '"principal": "' || "&principal." || '",';
        put principal;
        objectUri = '"objectUri": "' || "&objectURI." || '"';
        put objectUri;
        put '}';
    run;

    * https://developer.sas.com/rest-apis/authorization/createRule;
    proc http url = "&viyaHost./authorization/rules"
        method = 'Post'
        in = in
        oauth_bearer = sas_services;
        headers 'Accept' = 'application/json';
        headers 'Content-Type' = 'application/json';
    run;

    filename in clear;
%mend apply_rule;

* Iterate over the steps control list and create the authorization rules;
* CHANGE GROUPS HERE;
* If you decided to bring your own groups then change the first argument in the apply_rule macro calls to match the groups you want to use for the access control rules;
* If you decided against implementing/using a specific group then please remove the corresponding if condition block below;
data _null_;
    length args $256.;

    set work.sas_steps_with_access(where=(SAS_Studio_Basic NE .));

    if _n_ EQ 1 then do;
        args = '%nrstr(%apply_rule(SASStudioNone, /dataFlows/steps))';
        call execute(args);
    end;

    if SAS_Studio_Basic eq 0 then do;
        args = '%nrstr(%apply_rule(SASStudioBasic, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_Studio_Analyst eq 0 then do;
        args = '%nrstr(%apply_rule(SASStudioAnalyst, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_Studio_Engineer eq 0 then do;
        args = '%nrstr(%apply_rule(SASStudioEngineer, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_Visual_Text_Analytics eq 1 then do;
        args = '%nrstr(%apply_rule(SASStudioNoTextAnalytics, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_Intelligent_Decisioning eq 1 then do;
        args = '%nrstr(%apply_rule(SASStudioNoDecisioning, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_Visual_Statistics eq 1 then do;
        args = '%nrstr(%apply_rule(SASStudioNoStatistics, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_QC eq 1 then do;
        args = '%nrstr(%apply_rule(SASStudioNoQC, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_Model_Manager eq 1 then do;
        args = '%nrstr(%apply_rule(SASStudioNoModelManager, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_Econometrics eq 1 then do;
        args = '%nrstr(%apply_rule(SASStudioNoEconometrics, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_Optimization eq 1 then do;
        args = '%nrstr(%apply_rule(SASStudioNoOptimization, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;

    if SAS_Visual_Machine_Learning eq 1 then do;
        args = '%nrstr(%apply_rule(SASStudioNoMachineLearning, /dataFlows/steps/' || id || '))';
        call execute(args);
    end;
run;

/*
* Clean up of all variables, macros and datasets;
%symdel pathToAccessFile viyaHost;
%sysmacdelete apply_rule;
proc datasets library=work noList;
    delete all_steps_with_categories sas_steps_only sas_steps_with_access step_access_list;
run; quit;
*/