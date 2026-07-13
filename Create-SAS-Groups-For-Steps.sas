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
* DAI is short for Data and AI;
data _null_;
    SASDAIStudioNone = '%nrstr(%create_group(SASDAIStudioNone, SAS Data and AI Studio None, Disables all Steps in SAS Data and AI Studio for the user))';
    call execute(SASDAIStudioNone);
    SASSDAIStudio = '%nrstr(%create_group(SASSDAIStudio, SAS Data and AI Studio, Enables the user to use the SAS Data and AI Studio Basic Steps))';
    call execute(SASSDAIStudio);
    SASDAIStudioAdavanced = '%nrstr(%create_group(SASDAIStudioAdavanced, SAS Data and AI Studio Advanced, Enables the user to use the SAS Data and AI Studio Advanced and SAS Data and AI Studio Steps))';
    call execute(SASDAIStudioAdavanced);
    SASDAIStudioEnterprise = '%nrstr(%create_group(SASDAIStudioEnterprise, SAS Data and AI Studio Enterprise, Enables the user to use the SAS Data and AI Studio Enterprise and SAS Data and AI Studio Advanced and SAS Data and AI Studio Steps))';
    call execute(SASDAIStudioEnterprise);
    SASDAIStudioNoTextAnalytics = '%nrstr(%create_group(SASDAIStudioNoTextAnalytics, SAS Data and AI Studio No Text Analytics, Disables the Text Analytics Steps for the user))';
    call execute(SASDAIStudioNoTextAnalytics);
    SASDAIStudioNoDecisioning = '%nrstr(%create_group(SASDAIStudioNoDecisioning, SAS Data and AI Studio No Decisioning, Disables the Intelligent Decisioning Steps for the user))';
    call execute(SASDAIStudioNoDecisioning);
    SASDAIStudioNoStatistics = '%nrstr(%create_group(SASDAIStudioNoStatistics, SAS Data and AI Studio No Visual Statistics, Disables the Visual Statistics Steps for the user))';
    call execute(SASDAIStudioNoStatistics);
    SASDAIStudioNoQC = '%nrstr(%create_group(SASDAIStudioNoQC, SAS Data and AI Studio No QC, Disables the QC Steps for the user))';
    call execute(SASDAIStudioNoQC);
    SASDAIStudioNoModelManager = '%nrstr(%create_group(SASDAIStudioNoModelManager, SAS Data and AI Studio No Model Manager, Disables the Model Manager Steps for the user))';
    call execute(SASDAIStudioNoModelManager);
    SASDAIStudioNoEconometrics = '%nrstr(%create_group(SASDAIStudioNoEconometrics, SAS Data and AI Studio No Econometrics, Disables the Econometrics Steps for the user))';
    call execute(SASDAIStudioNoEconometrics);
    SASDAIStudioNoOptimization = '%nrstr(%create_group(SASDAIStudioNoOptimization, SAS Data and AI Studio No Optimization, Disables the Optimization Steps for the user))';
    call execute(SASDAIStudioNoOptimization);
    SASDAIStudioNoMachineLearning = '%nrstr(%create_group(SASDAIStudioNoMachineLearning, SAS Data and AI Studio No Machine Learning, Disables the Machine Learning Steps for the user))';
    call execute(SASDAIStudioNoMachineLearning);
    SASDAIStudioNoForecasting = '%nrstr(%create_group(SASDAIStudioNoForecasting, SAS Data and AI Studio No Forecasting, Disables the Forecasting Steps for the user))';
    call execute(SASDAIStudioNoForecasting);
    SASDAIStudioNoSAPIntegration = '%nrstr(%create_group(SASDAIStudioNoSAPIntegration, SAS Data and AI Studio No SAP Integration, Disables the SAP Integration Steps for the user))';
    call execute(SASDAIStudioNoSAPIntegration);
run;

/*
* Clean up of all variables, macros and datasets;
%symdel viyaHost;
%sysmacdelete create_group;
*/