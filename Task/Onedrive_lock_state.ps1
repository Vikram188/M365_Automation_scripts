# Connect to SharePoint Online
Connect-SPOService -Url "https://innovaticT-admin.sharepoint.com"

# Get OneDrive sites
$OneDriveSites = Get-SPOSite -IncludePersonalSite $true -Limit All |
    Where-Object { $_.Url -like "*-my.sharepoint.com/personal/*" }

# Select required information and flag lock states
$Report = $OneDriveSites | Select-Object `
    Owner,
    Url,
    LockState,
    @{Name="Flag"; Expression={
        if ($_.LockState -eq "NoAccess") {
            "NoAccess"
        }
        elseif ($_.LockState -eq "ReadOnly") {
            "ReadOnly"
        }
        else {
            ""
        }
    }}

# Export report
$Report | Export-Csv -Path ".\OneDrive_LockState_Report.csv" -NoTypeInformation

Write-Host "Report generated successfully."
Write-Host "Total OneDrive sites found: $($OneDriveSites.Count)"