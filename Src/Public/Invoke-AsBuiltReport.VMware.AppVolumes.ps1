﻿function Invoke-AsBuiltReport.VMware.AppVolumes {
    <#
    .SYNOPSIS
        PowerShell script which documents the configuration of VMware AppVolumes in Word/HTML/XML/Text formats
    .DESCRIPTION
        Documents the configuration of VMware AppVolumes in Word/HTML/XML/Text formats using PScribo.
    .NOTES
        Version:        0.1.1
        Author:         Chris Hildebrandt, @childebrandt42
        Editor:         Jonathan Colon, @jcolonfzenpr
        Twitter:        @asbuiltreport
        Github:         AsBuiltReport
        Credits:        Iain Brighton (@iainbrighton) - PScribo module


    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.VMware.AppVolumes
    #>


    [CmdletBinding()]
    param (
        [String[]] $Target,
        [PSCredential] $Credential,
        [String] $StylePath
    )

    # Check if the required version of VMware PowerCLI is installed
    #Get-RequiredModule -Name 'VMware.PowerCLI' -Version '12.7'


    # Import JSON Configuration for Options and InfoLevel
    $Report = $ReportConfig.Report
    $InfoLevel = $ReportConfig.InfoLevel
    $Options = $ReportConfig.Options

    $RESTAPIUser = $Credential.UserName
    $RESTAPIPassword = $Credential.GetNetworkCredential().password

    $AppVolRestCreds = @{
        username = $RESTAPIUser
        password = $RESTAPIPassword
    }

    foreach ($AppVolServer in $Target) {

        Try {
            $AppVolServerRest = Invoke-RestMethod -SkipCertificateCheck -SessionVariable SourceServerSession -Method Post -Uri "https://$AppVolServer/cv_api/sessions" -Body $AppVolRestCreds
        } Catch {
            Write-Error $_
        }

        # Generate report if connection to AppVolumes Server Connection is successful
        if ($AppVolServerRest.success -eq 'Ok') {
            # Generate report if connection to AppVolumes Manager General Information is successful
            if ($InfoLevel.AppVolumes.General -ge 1) {
                section -Style Heading1 $($AppVolServer) {
                    Paragraph "The following section provides a summary of the implemented components on the VMware App Volumes infrastructure."
                    Get-AbrAPPVolGeneral
                    section -Style Heading2 "Inventory" {
                        Get-AbrAppVolAppstack
                        Get-AbrAppVolWritable
                    }
                    section -Style Heading2 "Directory" {
                        Get-AbrAppVolADUser
                        Get-AbrAppVolADGroup
                        Get-AbrAppVolADOU
                    }
                    section -Style Heading2 "Infrastructure" {
                        Get-AbrAppVolStorage
                        Get-AbrAppVolStorageGroup
                    }
                    section -Style Heading2 "Configuration" {
                        Paragraph "The following section details configuration settings for App Volumes Manager $($AppVolServer.split('.')[0])."
                        Blankline
                        Get-AbrAppVolLicense
                        Get-AbrAppVolADDomain
                        Get-AbrAppVolAdminRole
                        Get-AbrAppVolMachineManager
                        Get-AbrAppVolDatastore
                        Get-AbrAPPVolManager
                        Get-AbrAppVolSetting
                    }
                }
            }
        }
    }
}