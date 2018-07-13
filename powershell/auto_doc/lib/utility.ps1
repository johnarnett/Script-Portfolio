# Utility functions

function Unzip
{
    param([string]$zipfile, [string]$outpath)
    Expand-Archive $zipfile -DestinationPath $outpath -Force
}

function Assembly_Rev
{
    param([string]$folder)
    $part = ($folder -split "_")[0]
    $rev = ($folder -split "_")[1]

    # Return values
    $part
    $rev
}

function Numbers
{
    param([string]$folder)
    $zip = Get-ChildItem "$inpath\$folder\*.zip" | Select-Object -expand name
    $f1 = $zip -split "_"
    $f2 = $f1[0] -split "-"
    $dash = $f2[1]
    $part = $f2[0]
    $version = $f1[1]
    $rev = ($folder -split "_")[1]

    # Return values
    $part
    $dash
    $version
    $rev
}

function Attachments
{
    param([string]$folder)
    $attachments = Get-ChildItem -Name "$inpath\$folder\*.zip"

    foreach ($a in $attachments)
    {
        if ($a -like "*Filelist*")
        { $file_list = $a } else { $build_artifact = $a }
    }
    # Return objects
    $build_artifact
    $file_list
}

function Checksum
{
    param([string]$file)
    $chksum = ((& $sha256 "$file") -split " ")[0] -replace '\\', ''
    return $chksum
}

function Filelist
{
    param([string]$folder, [string]$part, [string]$dash, [string]$rev)
    $filename = "$part-$dash" + "_Filelist.txt"
    $zipname = "$part" + "_" + "$rev" + "_Attachment_A_Filelist.zip"
    $files = (Get-ChildItem "$outpath\*" -Recurse).FullName
    Write-Host "Creating $zipname..." -ForegroundColor Blue
    foreach ($f in $files) { (((& $sha256 "$f") -replace '\\(.)', '$1') -replace '\*', '') -replace [Regex]::Escape("$outpath\"), "" >> "$inpath\$folder\$filename" 2>$null }

    # Method using powershell cmdlet (instead of included sha256sum binary)
    # This needs more work
    #foreach ($f in $files)
    #{
    #    $sha = Get-FileHash $f -Algorithm SHA256
    #    $hash = $sha.hash | Select-Object Hash
    #    Out-File -FilePath "$inpath\$folder\$filename" -InputObject $sha_output
    #}

    Compress-Archive -LiteralPath "$inpath\$folder\$filename" -CompressionLevel Optimal -DestinationPath "$inpath\$folder\$zipname" -Force
    Remove-Item  "$inpath\$folder\$filename" -Force
}

function Versions
{
    param([int]$part, [int]$dash, [string]$version, [string]$rev)

    $new_dash = "$part" + "-" + $dash.ToString("000")
    $old_rev = "$part"
    $new_rev = "$part" + " Rev " + $rev
    $new_version = $version
    $old_source_arch = $source_arch_rev.Split(" ")[0]
    $new_source_arch = $source_arch_rev
    # SKIP THESE REV LETTERS: I, O, Q, S, Z

    # Return values
    $new_dash
    $old_rev
    $new_rev
    $new_version
    $old_source_arch
    $new_source_arch
}

function Gen_SWAssemblyBase
{
	param([string]$ab_folder, [string]$ab_part, [string]$ab_rev, [array]$ab_parts)
    
    $ab_part_rev = "$($ab_part)_$ab_rev"
    $ab_doc_rev = "$ab_part-000 Rev $ab_rev"
	$ab_template = Get-ChildItem "$templates\SwAssemblyBase.doc" | Select-Object -Property Fullname -ExpandProperty Fullname
	$ab_file = "$inpath\$ab_folder\$($ab_part_rev).doc"
	$word = New-Object -ComObject Word.Application
    #$word.Visible = $True
    
	Write-Host "Writing to file: $ab_file" -ForegroundColor Blue
    $doc = $word.Documents.Open($ab_template)
	$doc.FormFields.Item("build_version_01").Result = $build_version
    $doc.FormFields.Item("build_version_02").Result = $build_version
    $doc.FormFields.Item("doc_rev_01").Result = $ab_doc_rev
    $doc.FormFields.Item("doc_rev_02").Result = $ab_doc_rev

    # Manually update bootloader lines
    $doc.FormFields.Item("PowerBoot_rev").Result = $ab_doc_rev
    $doc.FormFields.Item("VsmBoot_rev").Result = $ab_doc_rev
    $doc.FormFields.Item("IfaceBoot_rev").Result = $ab_doc_rev
    $doc.FormFields.Item("TherapyBoot_rev").Result = $ab_doc_rev
    $doc.FormFields.Item("PaddlesBoot_rev").Result = $ab_doc_rev

	foreach ($sw_part in $ab_parts.keys)
	{
	    Write-Host "$($sw_part): $($ab_parts.$sw_part)"
        $doc.FormFields.Item($sw_part).Result = $ab_parts.$sw_part
        $doc.FormFields.Item("$($sw_part)_rev").Result = $ab_doc_rev
	}
	Write-Host "Finished drawing for SWAssemblyBase" -ForegroundColor Green
	$doc.Fields | %{$_.Unlink()}
	$doc.SaveAs([ref]$ab_file)
	$word.Quit()
}
