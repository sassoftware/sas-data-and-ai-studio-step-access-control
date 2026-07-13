/*********************************************************************************************
    Copyright © 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
    SPDX-License-Identifier: Apache-2.0

    This script deletes all the rules and groups that were created by running the
      Create-SAS-Groups-For-Steps.sas script

    Please read the following disclaimers before using this script:
    - This script is using an undocumented API endpoint in order to delete Custom Groups.
      (namely /identities/groups)

*********************************************************************************************/

* Get the Viya Host URL;
%let viyaHost=%sysfunc(getoption(SERVICESBASEURL));

* This macro deletes a group by its name;
%macro delete_group(groupID);
    %local groupID;

    * Please note this API endpoint is not publicly documented;
    proc http
        method = 'Delete'
        url = "&viyaHost./identities/groups/&groupID"
        oauth_bearer = sas_services;
    run; quit;

%mend delete_group;

%delete_group(SASDAIStudioNone)
%delete_group(SASDAIStudioBasic)
%delete_group(SASDAIStudioAnalyst)
%delete_group(SASDAIStudioEngineer)
%delete_group(SASDAIStudioNoTextAnalytics)
%delete_group(SASDAIStudioNoDecisioning)
%delete_group(SASDAIStudioNoStatistics)
%delete_group(SASDAIStudioNoQC)
%delete_group(SASDAIStudioNoModelManager)
%delete_group(SASDAIStudioNoEconometrics)
%delete_group(SASDAIStudioNoOptimization)
%delete_group(SASDAIStudioNoMachineLearning)
%delete_group(SASDAIStudioNoForecasting)
%delete_group(SASDAIStudioNoSAPIntegration)

/*
* Clean up;
%sysmacdelete delete_group;
%symdel viyaHost;
*/  