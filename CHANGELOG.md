# Changelog

## SAS Viya 2026.06 Release

In this release SAS Studio was renamed to SAS Data and AI Studio. A long with this renaming the three tiers of SAS Studio where also renamed, as follows:

| Previous Name       | New Name                        |
| ------------------- | ------------------------------- |
| SAS Studio Basic    | SAS Data and AI Studio          |
| SAS Studio Analyst  | SAS Data and AI Studio Advanced |
| SAS Studio Engineer | SAS Data and AI Studio Engineer |

The **default custom groups** and the **columns** in the *Steps_Access_Control.csv* file have been renamed accordingly. For the groups and coumns the shorthand DAI was introduced, which is short for Data and AI. Since this is a one-time effort a migration script is not provided.

### Added

- New step: Extract BW Metadata
- New custom group: SAP_Integration
- CHANGLOG

### Changed

- Renamed custom groups and columns to align with the official product names