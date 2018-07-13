### Templates and input zip archives have been replaced with blank files for confidentiality ###

# Generates checksums and updates documentation for monthly software builds.

PREREQUISITES:
--------------
- Build artifacts get put into "input" folder for processing.

	- Each artifact must be in its own folder, using the following naming convention:

	 	<PART_NUMBER>_<REV_LETTER>_<COMPONENT>

	 	e.g. "input/3312345_B_QnxRTOS"
	      	     "input/3312346_E_PowerApp"
	      	     "input/3312347_B_LPQ5Default"

	- Source Archive is the exception, which does not need a rev letter:

		e.g. "input/3312349_SourceArchive"


RUNNING THE SCRIPT:
-------------------
- This script uses relative file locations. Run from this folder.

	Example: cd <script_root>
		 ./main.ps1

	Or:	right-click main.ps1 > edit > F5 to run script

- User will be prompted to enter Source Archive Version to be used throughout script:
	e.g "3312340 Rev H"


ADDITIONAL INFO:
----------------
- The script loops through the list of folders in 'input' and uses the corresponding template in ./templates to generate a new documentation file. Documentation for each component is stored back in the input folder, along with any attachments generated during the process.

Folder Hierarchy:
- /bin: SHA256 checksum binary.
- /input: component folders storing build artifacts are put here for processing.
- /lib: additional libraries called by the script.
- /templates: Document templates for each component.

