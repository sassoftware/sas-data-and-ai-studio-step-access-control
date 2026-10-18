# SAS Data and AI Studio Step Access Control

## Overview

SAS scripts that create identity groups and authorization rules in SAS Viya to restrict access to SAS Data and AI Studio Steps. For a demonstration on the usage of this repository please check out [this YouTube video](https://youtu.be/_uhBo42TMBE).

For updates please refer to the [CHANGELOG.md](./CHANGELOG.md).

### Prerequisites

In order to run the scripts you have to be part of the SAS Administrators group or have the ability to create new groups & authorization rules via a custom setup in your environment.

Please note this repository makes us of non-public SAS Viya REST API endpoints, these might change without prior notice and may break the provided code, if this occurs please raise an Issue on this repository.

### Note

This repository does not provide the ability to control access to the [Loop step](https://go.documentation.sas.com/doc/en/sasstudiocdc/default/webeditorcdc/webeditorflows/p1eadh8hc92nhln18xa92y9cq9ah.htm) which was released as part of SAS Data and AI Studio Enterprise in the 2026.08 Stable release.

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
1. Create a list of the groups and map it against the list of groups that you can find in the table below. Note that a user should always be in one of the SASDAIStudio* groups and then you can remove additional steps based on the other capabilities.

<<<<<<< HEAD
  | **Custom Group**           | **Description**                                              | **Your Group** |
  | -------------------------- | ------------------------------------------------------------ | -------------- |
  | SASDAIStudioNone              | Disables all Steps in SAS Studio for the user                |                |
  | SASDAIStudioBasic             | Enables the user to use the SAS Studio Basic Steps           |                |
  | SASDAIStudioAnalyst           | Enables the user to use the SAS Studio Analyst and SAS Studio Basic Steps |                |
  | SASDAIStudioEngineer          | Enables the user to use the SAS Studio Basic and SAS Studio Analyst and SAS Studio Engineer Steps |                |
=======
  | **Custom Group**              | **Description**                                              | **Your Group** |
  | ----------------------------- | ------------------------------------------------------------ | -------------- |
  | SASDAIStudioNone              | Disables all Steps in SAS Data and AI Studio for the user    |                |
  | SASSDAIStudio                 | Enables the user to use the SAS Data and AI Studio Basic Steps |                |
  | SASDAIStudioAdavanced         | Enables the user to use the SAS Data and AI Studio Advanced and SAS Data and AI Studio Steps |                |
  | SASDAIStudioEnterprise        | Enables the user to use the SAS Data and AI Studio Enterprise and SAS Data and AI Studio Advanced and SAS Data and AI Studio Steps |                |
>>>>>>> 912b90f20ac30dc20d7db418ee22a8d519a5683b
  | SASDAIStudioNoTextAnalytics   | Disables the Text Analytics Steps for the user               |                |
  | SASDAIStudioNoDecisioning     | Disables the Intelligent Decisioning Steps for the user      |                |
  | SASDAIStudioNoStatistics      | Disables the Visual Statistics Steps for the user            |                |
  | SASDAIStudioNoQC              | Disables the Quality Control (QC) Steps for the user         |                |
  | SASDAIStudioNoModelManager    | Disables the Model Manager Steps for the user                |                |
  | SASDAIStudioNoEconometrics    | Disables the Econometrics Steps for the user                 |                |
  | SASDAIStudioNoOptimization    | Disables the Optimization Steps for the user                 |                |
  | SASDAIStudioNoMachineLearning | Disables the Machine Learning Steps for the user             |                |
  | SASDAIStudioNoForecasting     | Disables the Forecasting Steps for the user                  |                |
  | SASDAIStudioNoSAPIntegration  | Disables the SAP Integration Steps for the user              |                |

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
