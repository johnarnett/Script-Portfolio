# Data structures to store values for text form fields (MS Word)
# Components are mapped to template classes from lib/components.ps1

Class Assembly_Base
{
    [string]$sw_part_num
    
	Assembly_Base ([string]$sw_part_num)
	{
        $this.sw_part_num = $sw_part_num
    }
}


Class Format_QNX_A
{
    [string]$attachment01
    [string]$attachment02
    [string]$desc_new_dash
    [string]$desc_old_rev
    [string]$desc_new_rev
    [string]$desc_new_version
    [string]$desc_old_source_arch
    [string]$desc_new_source_arch
    [string]$part_dash_num
    [string]$file_name_zip
    [string]$file_name_sha
    [string]$source_arch_rev_01
    [string]$source_arch_rev_02
    [string]$exec_attach01_file
    [string]$exec_attach01_sha
    [string]$source_arch_rev_03

    Format_QNX_A (
        [string]$attachment01, 			[string]$attachment02, 
        [string]$desc_new_dash, 		[string]$desc_old_rev, 
        [string]$desc_new_rev, 			[string]$desc_new_version, 
        [string]$desc_old_source_arch, 	[string]$desc_new_source_arch, 
        [string]$part_dash_num, 		[string]$file_name_zip, 
        [string]$file_name_sha, 		[string]$source_arch_rev_01, 
        [string]$source_arch_rev_02, 	[string]$exec_attach01_file, 
        [string]$exec_attach01_sha, 	[string]$source_arch_rev_03
        )
    {
        $this.attachment01 = $attachment01
        $this.attachment02 = $attachment02
        $this.desc_new_dash = $desc_new_dash
        $this.desc_old_rev = $desc_old_rev
        $this.desc_new_rev = $desc_new_rev
        $this.desc_new_version = $desc_new_version
        $this.desc_old_source_arch = $desc_old_source_arch
        $this.desc_new_source_arch = $desc_new_source_arch
        $this.part_dash_num = $part_dash_num
        $this.file_name_zip = $file_name_zip
        $this.file_name_sha = $file_name_sha
        $this.source_arch_rev_01 = $source_arch_rev_01
        $this.source_arch_rev_02 = $source_arch_rev_02
        $this.exec_attach01_file = $exec_attach01_file
        $this.exec_attach01_sha = $exec_attach01_sha
        $this.source_arch_rev_03 = $source_arch_rev_03
    }
}


Class Format_QNX_B
{
    [string]$attachment01
    [string]$desc_new_dash
    [string]$desc_old_rev
    [string]$desc_new_rev
    [string]$desc_new_version
    [string]$desc_old_source_arch
    [string]$desc_new_source_arch
    [string]$part_dash_num
    [string]$file_name_zip
    [string]$file_name_sha
    [string]$source_arch_rev_01
    [string]$source_arch_rev_02
    [string]$exec_attach01_part
    [string]$exec_attach01_file
    [string]$exec_attach01_ver
    [string]$exec_attach01_sha
    [string]$exec_attach02_part
    [string]$exec_attach02_file
    [string]$exec_attach02_ver
    [string]$exec_attach02_sha
    [string]$source_arch_rev_03

    Format_QNX_B (
        [string]$attachment01,          [string]$desc_new_dash, 
        [string]$desc_old_rev,          [string]$desc_new_rev, 
        [string]$desc_new_version,      [string]$desc_old_source_arch,
        [string]$desc_new_source_arch,  [string]$part_dash_num,
        [string]$file_name_zip,         [string]$file_name_sha,
        [string]$source_arch_rev_01,    [string]$source_arch_rev_02,
        [string]$exec_attach01_part,    [string]$exec_attach01_file,
        [string]$exec_attach01_ver,     [string]$exec_attach01_sha,
        [string]$exec_attach02_part,    [string]$exec_attach02_file,
        [string]$exec_attach02_ver,     [string]$exec_attach02_sha,
        [string]$source_arch_rev_03
        )
    {
        $this.attachment01 = $attachment01
        $this.desc_new_dash = $desc_new_dash
        $this.desc_old_rev = $desc_old_rev
        $this.desc_new_rev = $desc_new_rev
        $this.desc_new_version = $desc_new_version
        $this.desc_old_source_arch = $desc_old_source_arch
        $this.desc_new_source_arch = $desc_new_source_arch
        $this.part_dash_num = $part_dash_num
        $this.file_name_zip = $file_name_zip
        $this.file_name_sha = $file_name_sha
        $this.source_arch_rev_01 = $source_arch_rev_01
        $this.source_arch_rev_02 = $source_arch_rev_02
        $this.exec_attach01_part = $exec_attach01_part
        $this.exec_attach01_file = $exec_attach01_file
        $this.exec_attach01_ver = $exec_attach01_ver
        $this.exec_attach01_sha = $exec_attach01_sha
        $this.exec_attach02_part = $exec_attach02_part
        $this.exec_attach02_file = $exec_attach02_file
        $this.exec_attach02_ver = $exec_attach02_ver
        $this.exec_attach02_sha = $exec_attach02_sha
        $this.source_arch_rev_03 = $source_arch_rev_03
    }
}


Class Format_App_A
{
    [string]$attachment01
    [string]$desc_new_dash
    [string]$desc_old_rev
    [string]$desc_new_rev
    [string]$desc_new_version
    [string]$desc_old_source_arch
    [string]$desc_new_source_arch
    [string]$part_dash_num
    [string]$file_name_zip
    [string]$file_name_sha
    [string]$source_arch_rev_01
    [string]$source_arch_rev_02
    [string]$exec_attach01_part
    [string]$exec_attach01_file
    [string]$exec_attach01_ver
    [string]$exec_attach01_sha
    [string]$exec_attach02_part
    [string]$exec_attach02_file
    [string]$exec_attach02_sha
    [string]$exec_attach03_part
    [string]$exec_attach03_file
    [string]$exec_attach03_sha
    [string]$source_arch_rev_03

    Format_App_A (
        [string]$attachment01,          [string]$desc_new_dash, 
        [string]$desc_old_rev,          [string]$desc_new_rev, 
        [string]$desc_new_version,      [string]$desc_old_source_arch,
        [string]$desc_new_source_arch,  [string]$part_dash_num,
        [string]$file_name_zip,         [string]$file_name_sha,
        [string]$source_arch_rev_01,    [string]$source_arch_rev_02,
        [string]$exec_attach01_part,    [string]$exec_attach01_file,
        [string]$exec_attach01_ver,     [string]$exec_attach01_sha,
        [string]$exec_attach02_part,    [string]$exec_attach02_file,
        [string]$exec_attach02_sha,     [string]$exec_attach03_part,
        [string]$exec_attach03_file,    [string]$exec_attach03_sha,
        [string]$source_arch_rev_03
        )
    {
        $this.attachment01 = $attachment01
        $this.desc_new_dash = $desc_new_dash
        $this.desc_old_rev = $desc_old_rev
        $this.desc_new_rev = $desc_new_rev
        $this.desc_new_version = $desc_new_version
        $this.desc_old_source_arch = $desc_old_source_arch
        $this.desc_new_source_arch = $desc_new_source_arch
        $this.part_dash_num = $part_dash_num
        $this.file_name_zip = $file_name_zip
        $this.file_name_sha = $file_name_sha
        $this.source_arch_rev_01 = $source_arch_rev_01
        $this.source_arch_rev_02 = $source_arch_rev_02
        $this.exec_attach01_part = $exec_attach01_part
        $this.exec_attach01_file = $exec_attach01_file
        $this.exec_attach01_ver = $exec_attach01_ver
        $this.exec_attach01_sha = $exec_attach01_sha
        $this.exec_attach02_part = $exec_attach02_part
        $this.exec_attach02_file = $exec_attach02_file
        $this.exec_attach02_sha = $exec_attach02_sha
        $this.exec_attach03_part = $exec_attach03_part
        $this.exec_attach03_file = $exec_attach03_file
        $this.exec_attach03_sha = $exec_attach03_sha
        $this.source_arch_rev_03 = $source_arch_rev_03
    }
}


Class Format_App_B
{
    [string]$attachment01
    [string]$desc_new_dash
    [string]$desc_old_rev
    [string]$desc_new_rev
    [string]$desc_new_version
    [string]$desc_old_source_arch
    [string]$desc_new_source_arch
    [string]$part_dash_num
    [string]$file_name_zip
    [string]$file_name_sha
    [string]$source_arch_rev_01
    [string]$source_arch_rev_02
    [string]$exec_attach01_part
    [string]$exec_attach01_file
    [string]$exec_attach01_ver
    [string]$exec_attach01_sha
    [string]$exec_attach02_part
    [string]$exec_attach02_file
    [string]$exec_attach02_ver
    [string]$exec_attach02_sha
    [string]$exec_attach03_part
    [string]$exec_attach03_file
    [string]$exec_attach03_sha
    [string]$exec_attach04_part
    [string]$exec_attach04_file
    [string]$exec_attach04_sha
    [string]$source_arch_rev_03

    Format_App_B (
        [string]$attachment01,          [string]$desc_new_dash,
        [string]$desc_old_rev,          [string]$desc_new_rev,
        [string]$desc_new_version,      [string]$desc_old_source_arch,
        [string]$desc_new_source_arch,  [string]$part_dash_num,
        [string]$file_name_zip,         [string]$file_name_sha,
        [string]$source_arch_rev_01,    [string]$source_arch_rev_02,
        [string]$exec_attach01_part,    [string]$exec_attach01_file,
        [string]$exec_attach01_ver,     [string]$exec_attach01_sha,
        [string]$exec_attach02_part,    [string]$exec_attach02_file,
        [string]$exec_attach02_ver,     [string]$exec_attach02_sha,
        [string]$exec_attach03_part,    [string]$exec_attach03_file,
        [string]$exec_attach03_sha,     [string]$exec_attach04_part,
        [string]$exec_attach04_file,    [string]$exec_attach04_sha,
        [string]$source_arch_rev_03
        )
    {
        $this.attachment01 = $attachment01
        $this.desc_new_dash = $desc_new_dash
        $this.desc_old_rev = $desc_old_rev
        $this.desc_new_rev = $desc_new_rev
        $this.desc_new_version = $desc_new_version
        $this.desc_old_source_arch = $desc_old_source_arch
        $this.desc_new_source_arch = $desc_new_source_arch
        $this.part_dash_num = $part_dash_num
        $this.file_name_zip = $file_name_zip
        $this.file_name_sha = $file_name_sha
        $this.source_arch_rev_01 = $source_arch_rev_01
        $this.source_arch_rev_02 = $source_arch_rev_02
        $this.exec_attach01_part = $exec_attach01_part
        $this.exec_attach01_file = $exec_attach01_file
        $this.exec_attach01_ver = $exec_attach01_ver
        $this.exec_attach01_sha = $exec_attach01_sha
        $this.exec_attach02_part = $exec_attach02_part
        $this.exec_attach02_file = $exec_attach02_file
        $this.exec_attach02_ver = $exec_attach02_ver
        $this.exec_attach02_sha = $exec_attach02_sha
        $this.exec_attach03_part = $exec_attach03_part
        $this.exec_attach03_file = $exec_attach03_file
        $this.exec_attach03_sha = $exec_attach03_sha
        $this.exec_attach04_part = $exec_attach04_part
        $this.exec_attach04_file = $exec_attach04_file
        $this.exec_attach04_sha = $exec_attach04_sha
        $this.source_arch_rev_03 = $source_arch_rev_03
    }
}


Class Format_App_C
{
    [string]$attachment01
    [string]$desc_new_dash
    [string]$desc_old_rev
    [string]$desc_new_rev
    [string]$desc_new_version
    [string]$desc_old_source_arch
    [string]$desc_new_source_arch
    [string]$part_dash_num
    [string]$file_name_zip
    [string]$file_name_sha
    [string]$source_arch_rev_01
    [string]$source_arch_rev_02
    [string]$exec_attach01_part
    [string]$exec_attach01_file
    [string]$exec_attach01_ver
    [string]$exec_attach01_sha
    [string]$exec_attach02_part
    [string]$exec_attach02_file
    [string]$exec_attach02_ver
    [string]$exec_attach02_sha
    [string]$exec_attach03_part
    [string]$exec_attach03_file
    [string]$exec_attach03_ver
    [string]$exec_attach03_sha
    [string]$exec_attach04_part
    [string]$exec_attach04_file
    [string]$exec_attach04_ver
    [string]$exec_attach04_sha
    [string]$exec_attach05_part
    [string]$exec_attach05_file
    [string]$exec_attach05_ver
    [string]$exec_attach05_sha
    [string]$exec_attach06_part
    [string]$exec_attach06_file
    [string]$exec_attach06_ver
    [string]$exec_attach06_sha
    [string]$exec_attach07_part
    [string]$exec_attach07_file
    [string]$exec_attach07_ver
    [string]$exec_attach07_sha
    [string]$exec_attach08_part
    [string]$exec_attach08_file
    [string]$exec_attach08_sha
    [string]$source_arch_rev_03
    

    Format_App_C (
        [string]$attachment01,          [string]$desc_new_dash, 
        [string]$desc_old_rev,          [string]$desc_new_rev, 
        [string]$desc_new_version,      [string]$desc_old_source_arch, 
        [string]$desc_new_source_arch,  [string]$part_dash_num, 
        [string]$file_name_zip,         [string]$file_name_sha, 
        [string]$source_arch_rev_01,    [string]$source_arch_rev_02, 
        [string]$exec_attach01_part,    [string]$exec_attach01_file, 
        [string]$exec_attach01_ver,     [string]$exec_attach01_sha, 
        [string]$exec_attach02_part,    [string]$exec_attach02_file, 
        [string]$exec_attach02_ver,     [string]$exec_attach02_sha, 
        [string]$exec_attach03_part,    [string]$exec_attach03_file, 
        [string]$exec_attach03_ver,     [string]$exec_attach03_sha, 
        [string]$exec_attach04_part,    [string]$exec_attach04_file, 
        [string]$exec_attach04_ver,     [string]$exec_attach04_sha, 
        [string]$exec_attach05_part,    [string]$exec_attach05_file, 
        [string]$exec_attach05_ver,     [string]$exec_attach05_sha, 
        [string]$exec_attach06_part,    [string]$exec_attach06_file, 
        [string]$exec_attach06_ver,     [string]$exec_attach06_sha, 
        [string]$exec_attach07_part,    [string]$exec_attach07_file, 
        [string]$exec_attach07_ver,     [string]$exec_attach07_sha, 
        [string]$exec_attach08_part,    [string]$exec_attach08_file, 
        [string]$exec_attach08_sha,     [string]$source_arch_rev_03
        
        )
    {
        $this.attachment01 = $attachment01
        $this.desc_new_dash = $desc_new_dash
        $this.desc_old_rev = $desc_old_rev
        $this.desc_new_rev = $desc_new_rev
        $this.desc_new_version = $desc_new_version
        $this.desc_old_source_arch = $desc_old_source_arch
        $this.desc_new_source_arch = $desc_new_source_arch
        $this.part_dash_num = $part_dash_num
        $this.file_name_zip = $file_name_zip
        $this.file_name_sha = $file_name_sha
        $this.source_arch_rev_01 = $source_arch_rev_01
        $this.source_arch_rev_02 = $source_arch_rev_02
        $this.exec_attach01_part = $exec_attach01_part
        $this.exec_attach01_file = $exec_attach01_file
        $this.exec_attach01_ver = $exec_attach01_ver
        $this.exec_attach01_sha = $exec_attach01_sha
        $this.exec_attach02_part = $exec_attach02_part
        $this.exec_attach02_file = $exec_attach02_file
        $this.exec_attach02_ver = $exec_attach02_ver
        $this.exec_attach02_sha = $exec_attach02_sha
        $this.exec_attach03_part = $exec_attach03_part
        $this.exec_attach03_file = $exec_attach03_file
        $this.exec_attach03_ver = $exec_attach03_ver
        $this.exec_attach03_sha = $exec_attach03_sha
        $this.exec_attach04_part = $exec_attach04_part
        $this.exec_attach04_file = $exec_attach04_file
        $this.exec_attach04_ver = $exec_attach04_ver
        $this.exec_attach04_sha = $exec_attach04_sha
        $this.exec_attach05_part = $exec_attach05_part
        $this.exec_attach05_file = $exec_attach05_file
        $this.exec_attach05_ver = $exec_attach05_ver
        $this.exec_attach05_sha = $exec_attach05_sha
        $this.exec_attach06_part = $exec_attach06_part
        $this.exec_attach06_file = $exec_attach06_file
        $this.exec_attach06_ver = $exec_attach06_ver
        $this.exec_attach06_sha = $exec_attach06_sha
        $this.exec_attach07_part = $exec_attach07_part
        $this.exec_attach07_file = $exec_attach07_file
        $this.exec_attach07_ver = $exec_attach07_ver
        $this.exec_attach07_sha = $exec_attach07_sha
        $this.exec_attach08_part = $exec_attach08_part
        $this.exec_attach08_file = $exec_attach08_file
        $this.exec_attach08_sha = $exec_attach08_sha
        $this.source_arch_rev_03 = $source_arch_rev_03
    }
}
