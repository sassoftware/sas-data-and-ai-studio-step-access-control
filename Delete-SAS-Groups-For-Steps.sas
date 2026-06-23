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

%delete_group(SASStudioNone)
%delete_group(SASStudioBasic)
%delete_group(SASStudioAnalyst)
%delete_group(SASStudioEngineer)
%delete_group(SASStudioNoTextAnalytics)
%delete_group(SASStudioNoDecisioning)
%delete_group(SASStudioNoStatistics)
%delete_group(SASStudioNoQC)
%delete_group(SASStudioNoModelManager)
%delete_group(SASStudioNoEconometrics)
%delete_group(SASStudioNoOptimization)
%delete_group(SASStudioNoMachineLearning)
%delete_group(SASStudioNoForecasting)

/*
* Clean up;
%sysmacdelete delete_group;
%symdel viyaHost;
*/  