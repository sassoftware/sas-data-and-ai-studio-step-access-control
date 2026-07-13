# SAS Data and AI Studio Step Access Control

## Overview

SAS scripts that create identity groups and authorization rules in SAS Viya to restrict access to SAS Data and AI Studio Steps.

For updates please refer to the [CHANGELOG.md](./CHANGELOG.md).

### Prerequisites

In order to run the scripts you have to be part of the SAS Administrators group or have the ability to create new groups & authorization rules via a custom setup in your environment.

Please note this repository makes us of non-public SAS Viya REST API endpoints, these might change without prior notice and may break the provided code, if this occurs please raise an Issue on this repository.

## Installation

Clone/upload this project to your SAS Viya environment. Cloning is recommended as this project gets updated as new steps are released for SAS Data and AI Studio overtime.

### Getting Started

Once you have the .csv file and .sas files available on your SAS Viya environment let us quickly run through how this project works and the key files:

1. **Steps_Access_Control.csv**, provides a table with all the SAS Steps provided and a connection to all SAS Data and AI Studio tiers (Basic/Analyst/Engineer) and further algorithmic capabilities used like SAS Visual Statistics, SAS Optimization, etc.. This file will be updated as new SAS steps are released.
2. **Create-SAS-Groups-For-Steps.sas [optional]**, running this script is optional if you do not want the default custom groups but rather want to use the groups you already have in your Azure Active Directory, LDAP, etc.. Running this script will create new custom groups in your SAS Viya environment, the *Delete-SAS-Groups-For-Steps.sas* can delete them again fully. Please read the program header carefully before running the script.
3. **Create-SAS-Authroization-Rules-For-Steps.sas**, running this script is the core of adding the authorization rules to your SAS Viya environment in order to implement the access control for the SAS Data and AI Studio Steps. Please read the program header carefully before running the script.
4. **Delete-SAS-Authroziation-Rules-For-Steps.sas**, running this script will remove all the authorization rules that were created by the *Create-SAS-Authorization-Rules-For-Steps.sas* script. Please read the program header carefully before running the script.
5. **Delete-SAS-Groups-For-Steps.sas [optional]**, running this script will remove all the custom groups that were created by the *Create-SAS-Groups-For-Steps.sas* script. Please read the program header carefully before running the script.

If you are running it with all the default custom groups than do the following:
1. Run the *Create-SAS-Groups-For-Steps.sas* script.
2. Run the *Create-SAS-Authorization-Rules-For-Steps.sas* script.
3. Assign your users to the groups as appropriate.
4. Add checking this repository for updates to your To-do list when updating your SAS Viya environment.

If you are using your own groups, instead of the provided custom groups, please follow this list:
1. Create a list of the groups and map it against the list of groups that you can find in the table below. Note that a user should always be in one of the SASStudio* groups and then you can remove additional steps based on the other capabilities.

  | **Custom Group**           | **Description**                                              | **Your Group** |
  | -------------------------- | ------------------------------------------------------------ | -------------- |
  | SASStudioNone              | Disables all Steps in SAS Studio for the user                |                |
  | SASStudioBasic             | Enables the user to use the SAS Studio Basic Steps           |                |
  | SASStudioAnalyst           | Enables the user to use the SAS Studio Analyst and SAS Studio Basic Steps |                |
  | SASStudioEngineer          | Enables the user to use the SAS Studio Basic and SAS Studio Analyst and SAS Studio Engineer Steps |                |
  | SASStudioNoTextAnalytics   | Disables the Text Analytics Steps for the user               |                |
  | SASStudioNoDecisioning     | Disables the Intelligent Decisioning Steps for the user      |                |
  | SASStudioNoStatistics      | Disables the Visual Statistics Steps for the user            |                |
  | SASStudioNoQC              | Disables the Quality Control (QC) Steps for the user         |                |
  | SASStudioNoModelManager    | Disables the Model Manager Steps for the user                |                |
  | SASStudioNoEconometrics    | Disables the Econometrics Steps for the user                 |                |
  | SASStudioNoOptimization    | Disables the Optimization Steps for the user                 |                |
  | SASStudioNoMachineLearning | Disables the Machine Learning Steps for the user             |                |
  | SASStudioNoForecasting     | Disables the Forecasting Steps for the user                  |                |

2. Now go ahead and adjust the *Create-SAS-Authorization-Rules-For-Steps.sas* (read the SAS program header carefully on how to do it). Then run this script.

3. Assign your users to the groups as appropriate.

4. Add checking this repository for updates to your To-do list when updating your SAS Viya environment.

## Intended Use of this Software

This project is intended to help SAS administrators align user access in SAS Viya with their organization's SAS entitlements. It is offered as a practical starting point, not a formal compliance or audit tool.  Using this software does not by itself determine whether a given configuration matches the terms of any particular contract.  Use of SAS software is governed by the written agreements between SAS and customers. If you have questions about how a specific SAS license applies in your environment, please contact your SAS account team. Nothing in this repository is legal advice.

## Contributing

Maintainers are not currently accepting patches and contributions to this project.

## License

This project is licensed under the [Apache 2.0 License](LICENSE).

## Third-Party Dependencies

This project as no Third-Party dependencies.

## Additional Resources

* [SAS Data and AI Studio Documentation](https://go.documentation.sas.com/doc/en/sasstudiocdc/default/webeditorcdc/webeditorug/p1ui8s49rgabu4n0z3sjvr4q6v69.htm)
* [SAS Authorization API endpoint](https://developer.sas.com/rest-apis/authorization)
