# Component Functions - Maps component to template format

function QnxRTOS
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_QNX_A $folder $part $dash $version $rev
}

function QnxQt
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_QNX_A $folder $part $dash $version $rev
}

function QnxComm
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_QNX_A $folder $part $dash $version $rev
}

function QnxLPQ5Device
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_QNX_A $folder $part $dash $version $rev
}

function QnxOpenSSL
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_QNX_A $folder $part $dash $version $rev
}

function LPQ5Default
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_QNX_A $folder $part $dash $version $rev
}

function QnxIPL
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_QNX_B $folder $part $dash $version $rev
}

function PowerApp
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_A $folder $part $dash $version $rev
}

function VsmApp
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_A $folder $part $dash $version $rev
}

function IfaceApp
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_A $folder $part $dash $version $rev
}

function TherapyApp
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_A $folder $part $dash $version $rev
}

function QnxAltOS
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_A $folder $part $dash $version $rev
}

function PaddlesApp
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_B $folder $part $dash $version $rev
}

function PatientApp
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_C $folder $part $dash $version $rev
}

function ArchiveApp
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_C $folder $part $dash $version $rev
}

function SetupApp
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_C $folder $part $dash $version $rev
}

function RuntestApp
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)
    return Format_App_C $folder $part $dash $version $rev
}


# Template formats - Defines values and maps components to classes in lib/classes.ps1

function Format_QNX_A
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)

    $versions = Versions $part $dash $version $rev
    $new_dash = $versions[0]
    $old_rev = $versions[1]
    $new_rev = $versions[2]
    $new_version = $versions[3]
    $old_source_arch = $versions[4]
    $new_source_arch = $versions[5]

    Filelist $folder $part $dash $rev
    $attach = Attachments $folder
    $build_artifact = $attach[0]
    $file_list = $attach[1]
    $build_artifact_sha = Checksum "$inpath\$folder\$build_artifact"
    $file_list_sha = Checksum "$inpath\$folder\$file_list"

    $values = [Format_QNX_A]::new(
        $build_artifact, $file_list,
        $new_dash, $old_rev,
        $new_rev, $new_version,
        $old_source_arch, $new_source_arch,
        $new_dash, $file_list,
        $file_list_sha, $source_arch_rev,
        $source_arch_rev, $build_artifact,
        $build_artifact_sha, $source_arch_rev
        )

    return $values
}

function Format_QNX_B
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)

    $versions = Versions $part $dash $version $rev
    $new_dash = $versions[0]
    $old_rev = $versions[1]
    $new_rev = $versions[2]
    $new_version = $versions[3]
    $old_source_arch = $versions[4]
    $new_source_arch = $versions[5]

    $attach = Attachments $folder
    $build_artifact = $attach[0]
    $build_artifact_sha = Checksum "$inpath\$folder\$build_artifact"

    $files = (Get-ChildItem "$outpath\*" -Recurse)

    $ba_files = @()
    foreach ($file in $files)
    {
        $ba_files += $file
    }

    $exec_attach01_file = $ba_files[0]
    $exec_attach01_sha = Checksum "$outpath\$exec_attach01_file"
    $exec_attach02_file = $ba_files[1]
    $exec_attach02_sha = Checksum "$outpath\$exec_attach02_file"

    $values = [Format_QNX_B]::new(
        $build_artifact,
        $new_dash,
        $old_rev, $new_rev,
        $new_version,
        $old_source_arch, $new_source_arch,
        $new_dash, $build_artifact,
        $build_artifact_sha, $source_arch_rev,
        $source_arch_rev, $new_dash,
        $exec_attach01_file, $new_version,
        $exec_attach01_sha, $new_dash,
        $exec_attach02_file, $new_version,
        $exec_attach02_sha, $source_arch_rev
        )

    return $values
}

function Format_App_A
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)

    $versions = Versions $part $dash $version $rev
    $new_dash = $versions[0]
    $old_rev = $versions[1]
    $new_rev = $versions[2]
    $new_version = $versions[3]
    $old_source_arch = $versions[4]
    $new_source_arch = $versions[5]

    $attach = Attachments $folder
    $build_artifact = $attach[0]
    $build_artifact_sha = Checksum "$inpath\$folder\$build_artifact"

    $files = (Get-ChildItem "$outpath\*" -Recurse)

    if ($folder -like "*QnxAltOS*")
    {
        foreach ($file in $files)
        {
            if ($file -like "*.bin")
            {
                $exec_attach01_file = $file
            }
            elseif ($file -like "*.ver")
            {
                $exec_attach02_file = $file
            }
            else
            {
                $exec_attach03_file = $file
            }
        }
    }
    else
    {
        $ba_files = @()
        foreach ($file in $files)
        {
            $ba_files += $file
        }
    
        $exec_attach01_file = $ba_files[0]
        $exec_attach02_file = $ba_files[1]
        $exec_attach03_file = $ba_files[2]
    }

    $exec_attach01_sha = Checksum "$outpath\$exec_attach01_file"
    $exec_attach02_sha = Checksum "$outpath\$exec_attach02_file"
    $exec_attach03_sha = Checksum "$outpath\$exec_attach03_file"

    $values = [Format_App_A]::new(
        $build_artifact,
        $new_dash,
        $old_rev, $new_rev,
        $new_version,
        $old_source_arch, $new_source_arch,
        $new_dash, $build_artifact,
        $build_artifact_sha, $source_arch_rev,
        $source_arch_rev, $new_dash,
        $exec_attach01_file, $new_version,
        $exec_attach01_sha, $new_dash,
        $exec_attach02_file, $exec_attach02_sha,
        $new_dash, $exec_attach03_file,
        $exec_attach03_sha, $source_arch_rev
        )

    return $values
}

function Format_App_B
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)

    $versions = Versions $part $dash $version $rev
    $new_dash = $versions[0]
    $old_rev = $versions[1]
    $new_rev = $versions[2]
    $new_version = $versions[3]
    $old_source_arch = $versions[4]
    $new_source_arch = $versions[5]

    $attach = Attachments $folder
    $build_artifact = $attach[0]
    $build_artifact_sha = Checksum "$inpath\$folder\$build_artifact"

    $files = (Get-ChildItem "$outpath\*" -Recurse)

    $ba_files = @()
    foreach ($file in $files)
    {
        $ba_files += $file
    }

    $exec_attach01_file = $ba_files[0]
    $exec_attach02_file = $ba_files[1]
    $exec_attach03_file = $ba_files[2]
    $exec_attach04_file = $ba_files[3]
    $exec_attach01_sha = Checksum "$outpath\$exec_attach01_file"
    $exec_attach02_sha = Checksum "$outpath\$exec_attach02_file"
    $exec_attach03_sha = Checksum "$outpath\$exec_attach03_file"
    $exec_attach04_sha = Checksum "$outpath\$exec_attach04_file"

    $values = [Format_App_B]::new(
        $build_artifact,
        $new_dash,
        $old_rev, $new_rev,
        $new_version,
        $old_source_arch, $new_source_arch,
        $new_dash, $build_artifact,
        $build_artifact_sha, $source_arch_rev,
        $source_arch_rev, $new_dash,
        $exec_attach01_file, $new_version,
        $exec_attach01_sha, $new_dash,
        $exec_attach02_file, $new_version,
        $exec_attach02_sha, $new_dash,
        $exec_attach03_file, $exec_attach03_sha,
        $new_dash, $exec_attach04_file,
        $exec_attach04_sha, $source_arch_rev
        )

    return $values
}

function Format_App_C
{
    param([string]$folder, [string]$part, [string]$dash, [string]$version, [string]$rev)

    $versions = Versions $part $dash $version $rev
    $new_dash = $versions[0]
    $old_rev = $versions[1]
    $new_rev = $versions[2]
    $new_version = $versions[3]
    $old_source_arch = $versions[4]
    $new_source_arch = $versions[5]

    $attach = Attachments $folder
    $build_artifact = $attach[0]
    $build_artifact_sha = Checksum "$inpath\$folder\$build_artifact"

    $files = (Get-ChildItem "$outpath\*" -Recurse)

    $ba_files = @()
    foreach ($file in $files)
    {
        if ($file -like "*.sh*")
        {
            $exec_sh_file = $file
        } else {
            $ba_files += $file
        }
    }
    
    $exec_attach01_file = $ba_files[0]
    $exec_attach02_file = $ba_files[1]
    $exec_attach03_file = $ba_files[2]
    $exec_attach04_file = $ba_files[3]
    $exec_attach05_file = $ba_files[4]
    $exec_attach06_file = $ba_files[5]
    $exec_attach07_file = $ba_files[6]
    $exec_attach01_sha = Checksum "$outpath\$exec_attach01_file"
    $exec_attach02_sha = Checksum "$outpath\$exec_attach02_file"
    $exec_attach03_sha = Checksum "$outpath\$exec_attach03_file"
    $exec_attach04_sha = Checksum "$outpath\$exec_attach04_file"
    $exec_attach05_sha = Checksum "$outpath\$exec_attach05_file"
    $exec_attach06_sha = Checksum "$outpath\$exec_attach06_file"
    $exec_attach07_sha = Checksum "$outpath\$exec_attach07_file"
    $exec_sh_file_sha = Checksum "$outpath\$exec_sh_file"

    $values = [Format_App_C]::new(
        $build_artifact,        $new_dash, 
        $old_rev,               $new_rev, 
        $new_version,           $old_source_arch, 
        $new_source_arch,       $new_dash,
        $build_artifact,        $build_artifact_sha, 
        $source_arch_rev,       $source_arch_rev, 
        $new_dash,              $exec_attach01_file, 
        $new_version,           $exec_attach01_sha, 
        $new_dash,              $exec_attach02_file, 
        $new_version,           $exec_attach02_sha, 
        $new_dash,              $exec_attach03_file, 
        $new_version,           $exec_attach03_sha, 
        $new_dash,              $exec_attach04_file, 
        $new_version,           $exec_attach04_sha, 
        $new_dash,              $exec_attach05_file, 
        $new_version,           $exec_attach05_sha, 
        $new_dash,              $exec_attach06_file, 
        $new_version,           $exec_attach06_sha, 
        $new_dash,              $exec_attach07_file, 
        $new_version,           $exec_attach07_sha, 
        $new_dash,              $exec_sh_file, 
        $exec_sh_file_sha,      $source_arch_rev
        )

    return $values
}
