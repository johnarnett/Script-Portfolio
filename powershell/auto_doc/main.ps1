# PSVersion: 5.1.15063.0
# Author: John Arnett
# Date: 6/22/2018

# Updates documentation for monthly software builds.
# Build artifacts get put into "input" folder for processing.
# Each artifact must be in its own folder, named in the following format:
# <PART_NUMBER>_<REV_LETTER>_<COMPONENT> e.g. "3312345_B_QnxRTOS"


# Import Libraries
. lib\components.ps1
. lib\classes.ps1
. lib\utility.ps1


# Global Definitions
$global:rootpath = "$PWD"
$global:inpath = "$rootpath\input"
$global:outpath = "$rootpath\unzip"
$global:templates = "$rootpath\templates"
$global:sha256 = "$rootpath\bin\sha256sum.exe"
$global:folder_list = Get-ChildItem -Name $inpath
$global:source_arch_rev = Read-Host -Prompt "Enter Source Archive Revision (e.g '3312345 Rev H')"
$global:build_version = Read-Host -Prompt "Enter Build Version (e.g '10.0.20.10')"


# MAIN
#New-Item -ItemType Directory -Force -Path $outpath > $null

$ab_parts = @{}

foreach ($folder in $folder_list)
{
    # Get component name from folder
    $component = ($folder -split "_")[2]

    # SwAssemblyBase info will be saved so it can be processed last
    if ($component -match "SwAssemblyBase")
    {
        $ab_folder = $folder
        $ar = Assembly_Rev $ab_folder
        $ab_part = $ar[0]
        $ab_rev = $ar[1]
        $ab_part_rev = "$($ab_part)_$ab_rev"
        write-host "AB PART REV: $ab_part_rev"
        continue
    }

    # Define release / version numbers
    $num = Numbers $folder
    $part = $num[0]
    $dash = $num[1]
    $version = $num[2]
    $rev = $num[3]

    # Extract build artifact
    $filename = Get-ChildItem -Name "$inpath\$folder\*$component*.zip"
    Unzip "$inpath\$folder\$filename" $outpath

    # Call corresponding component function from template library
    $values = & $component $folder $part $dash $version $rev

    # Add SW part number of component to Assembly Base list
    $ab_parts.Add("$component", $values.desc_new_dash)

    # Remove extracted folder
    Remove-Item .\unzip -Force -Recurse

    # Prep Word files
    $file = Get-ChildItem "$templates\$($component).doc" | Select-Object -Property Fullname -ExpandProperty Fullname
    $new_file = "$inpath\$folder\$($part)_$rev.doc"
    $word = New-Object -ComObject Word.Application
    #$word.Visible = $True

    # Loop through class properties and write to file
    Write-Host "Writing to file: $new_file" -ForegroundColor Blue
    $doc = $word.Documents.Open($file)
    foreach ($v in $values.PSObject.Properties)
    {
        Write-Host "$($v.Name): $($v.Value)"
        $doc.FormFields.Item($v.Name).Result = $v.Value
    }
    Write-Host "Finished drawing for component: $component" -ForegroundColor Green
    $doc.Fields | %{$_.Unlink()}
    $doc.SaveAs([ref]$new_file)
    $word.Quit()
}

# Generate SWAssemblyBase Drawing
if ($ab_part_rev) { Gen_SWAssemblyBase $ab_folder $ab_part $ab_rev $ab_parts }

# Terminate any lingering Word process
Get-Process WINWORD | Stop-Process
# EOF
