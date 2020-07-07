# AsBuiltReport.VMware.AppVolumes
Repository for VMware AppVolumes AsBuilt Report


# Sample Reports

<Coming Soon>

# Getting Started

Below are the instructions on how to install, configure and generate a VMware AppVolumes As Built Report

## Pre-requisites
The following PowerShell modules are required for generating a VMware AppVolumes As Built report.

Each of these modules can be easily downloaded and installed via the PowerShell Gallery 

- [AsBuiltReport Module](https://www.powershellgallery.com/packages/AsBuiltReport/)

### Module Installation

Open a Windows PowerShell terminal window and install each of the required modules as follows;
```powershell
Install-Module AsBuiltReport
```

### Required Privileges

To generate a VMware AppVolumes report, a user account with the Admin role or higher on the AppVolumes is required. (Required Admin rights to use the AppVol APIs)

## Configuration

The VMware AppVolumes As Built Report utilises a JSON file to allow configuration of report information, options, detail and healthchecks.

A VMware AppVolumes report configuration file can be generated by executing the following command;

New-AsBuiltReportConfig -Report VMware.Appvolumes -Path <User specified folder> -Name <Optional> 
Executing this command will copy the default VMware AppVolumes report JSON configuration to a user specified folder.

All report settings can then be configured via the JSON file.

The following provides information of how to configure each schema within the report's JSON file.

Report
The Report sub-schema provides configuration of the Nutanix Prism report information

Schema	Sub-Schema	Description
Report	Name	The name of the As Built Report
Report	Version	The report version
Report	Status	The report release status

InfoLevel
The InfoLevel sub-schema allows configuration of each section of the report at a granular level.

There are 4 levels (0-3) of detail granularity for each section as follows;

Setting	InfoLevel	Description
0	Disabled	does not collect or display any information
1	Summary	provides summarised information for a collection of objects
2	Detailed	provides detailed information for a collection of objects
3	Comprehensive	provides comprehensive information for individual objects
The following sections can be set

Schema	    Sub-Schema	        Default Setting     Max Setting
InfoLevel	General	            1                   1
InfoLevel	Managers	        1                   1
InfoLevel	License             1                   1
InfoLevel	AppStacks	        1                   2
InfoLevel	ADUsers 	        1                   2
InfoLevel	ADGroups	        1                   2
InfoLevel   Writeables          1                   2
InfoLevel	Applications	    1                   2
InfoLevel	StorageLocations	1                   2
InfoLevel	StorageGroups       1                   2
InfoLevel	ADDomains       	1                   2
InfoLevel	AdminGroups      	1                   2
InfoLevel	MachineManagers 	1                   2
InfoLevel   Storage             1                   2
InfoLevel   Settings            1                   1


## Examples
There is one example listed below on running the AsBuiltReport script against a VMware AppVolumes target. Refer to the `README.md` file in the main AsBuiltReport project repository for more examples.

- The following creates a VMware AppVolumes As-Built report in HTML & Word formats in the folder C:\scripts\.
```powershell
PS C:\>New-AsBuiltReport -Report VMware.AppVolumes -Target 192.168.1.100 -Credential (Get-Credential) -Format HTML,Word -OutputPath C:\scripts\
```

## Known Issues
The AppVolumes is required to have a trusted cert installed. If there is no trusted cert it will error. Workaround is to install a trusted cert or add the cert to the trusted certs store on the machine running the VMware AppVolumes AS Built Report.

## Supported Versions
Should work on versions 2.x. Has been tested on 2.14 through 2.18.4 and Version 4.0.0 and 4.0.1