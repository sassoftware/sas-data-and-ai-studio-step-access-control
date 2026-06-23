/*********************************************************************************************
    Copyright © 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
    SPDX-License-Identifier: Apache-2.0

    Please read the following disclaimers before using this script:
    1. This script is using an undocumented API endpoint in order to create Custom Groups.
        If you prefer to make use of your own provided groups (e.g. via Active Directory,
        LDAP, etc.) you can skip running this script and use those groups in the next
        Create-SAS-Authroization-Rules-For-Steps.sas script to assign the step access rules
        to those groups instead.
    2. The custom groups created by this script can be deleted using the 
        Delete-SAS-Groups-For-Steps.sas script that is part of the same repository.

*********************************************************************************************/

* Get the Viya Host URL;
%let viyaHost=%sysfunc(getoption(SERVICESBASEURL));

* Macro that generates the groups in SAS Viya;
%macro create_group(id, name, description);
    %local id
        name
        description;

    filename in temp;

    proc json out = in pretty;
        write open object;
            write values 'id' "&id.";
            write values 'name' "&name.";
            write values 'description' "&description.";
        write close;
    run;

    * Please note this API endpoint is not publicly documented;
    proc http
        method = 'Post'
        url = "&viyaHost./identities/groups"
        in = in
        oauth_bearer = sas_services;
        headers 'Accept' = 'application/json';
        headers 'Content-Type' = 'application/json';
    run; quit;

    filename in clear;
%mend create_group;

* Call for each group that we want to create for the steps access control;
data _null_;
    SASStudioNone = '%nrstr(%create_group(SASStudioNone, SAS Studio None, Disables all Steps in SAS Studio for the user))';
    call execute(SASStudioNone);
    SASStudioBasic = '%nrstr(%create_group(SASStudioBasic, SAS Studio Basic, Enables the user to use the SAS Studio Basic Steps))';
    call execute(SASStudioBasic);
    SASStudioAnalyst = '%nrstr(%create_group(SASStudioAnalyst, SAS Studio Analyst, Enables the user to use the SAS Studio Analyst and SAS Studio Basic Steps))';
    call execute(SASStudioAnalyst);
    SASStudioEngineer = '%nrstr(%create_group(SASStudioEngineer, SAS Studio Engineer, Enables the user to use the SAS Studio Basic and SAS Studio Analyst and SAS Studio Engineer Steps))';
    call execute(SASStudioEngineer);
    SASStudioNoTextAnalytics = '%nrstr(%create_group(SASStudioNoTextAnalytics, SAS Studio No Text Analytics, Disables the Text Analytics Steps for the user))';
    call execute(SASStudioNoTextAnalytics);
    SASStudioNoDecisioning = '%nrstr(%create_group(SASStudioNoDecisioning, SAS Studio No Decisioning, Disables the Intelligent Decisioning Steps for the user))';
    call execute(SASStudioNoDecisioning);
    SASStudioNoStatistics = '%nrstr(%create_group(SASStudioNoStatistics, SAS Studio No Visual Statistics, Disables the Visual Statistics Steps for the user))';
    call execute(SASStudioNoStatistics);
    SASStudioNoQC = '%nrstr(%create_group(SASStudioNoQC, SAS Studio No QC, Disables the QC Steps for the user))';
    call execute(SASStudioNoQC);
    SASStudioNoModelManager = '%nrstr(%create_group(SASStudioNoModelManager, SAS Studio No Model Manager, Disables the Model Manager Steps for the user))';
    call execute(SASStudioNoModelManager);
    SASStudioNoEconometrics = '%nrstr(%create_group(SASStudioNoEconometrics, SAS Studio No Econometrics, Disables the Econometrics Steps for the user))';
    call execute(SASStudioNoEconometrics);
    SASStudioNoOptimization = '%nrstr(%create_group(SASStudioNoOptimization, SAS Studio No Optimization, Disables the Optimization Steps for the user))';
    call execute(SASStudioNoOptimization);
    SASStudioNoMachineLearning = '%nrstr(%create_group(SASStudioNoMachineLearning, SAS Studio No Machine Learning, Disables the Machine Learning Steps for the user))';
    call execute(SASStudioNoMachineLearning);
    SASStudioNoForecasting = '%nrstr(%create_group(SASStudioNoForecasting, SAS Studio No Forecasting, Disables the Forecasting Steps for the user))';
    call execute(SASStudioNoForecasting);
run;

/*
* Clean up of all variables, macros and datasets;
%symdel viyaHost;
%sysmacdelete create_group;
*/