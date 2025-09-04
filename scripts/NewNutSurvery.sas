dm 'log;clear;output;clear;odsresults;clear';
options mprint nodate pageno=1;
%SYSMSTORECLEAR;
/* Edit the following line to reflect the full path to your CSV file */
%let csv_file = 'Y:\Documents\Research Folder\PRS Nutrition Survey Study\ASurveyForExerciseAn_DATA_NOHDRS_2024-12-16_1559.csv';
*This is the file that combined - even though it says an older date;
OPTIONS nofmterr;
/* ==========================================================================================
   STEP 2: Define Custom Formats for Survey Variables

   This section uses PROC FORMAT to create custom value labels for variables in the survey.
   These formats translate numeric codes (e.g., 1, 2, 3...) into human-readable text 
   responses based on the original REDCap form.

   Purpose:
   - Make the dataset more interpretable by mapping Likert scale values and checkbox flags 
     to their full textual descriptions.
   - Ensure cleaner outputs when using PROC PRINT, PROC FREQ, or exporting to reports.

   Examples:
   - 1 ? 'Strongly agree'
   - 0 ? 'Unchecked', 1 ? 'Checked'
   - 1 ? 'Novice - I have no knowledge...', etc.

   These formats will be applied later using the FORMAT statement in the final DATA step.
========================================================================================== */
proc format;
	value consent_form_ 1='Yes' 2='No';
	value consent_complete_ 0='Incomplete' 1='Unverified' 
		2='Complete';
	value residency_type_ 1='Integrated' 2='Independent';
	value residency_year_ 1='PGY-1' 2='PGY-2' 
		3='PGY-3' 4='PGY-4' 
		5='PGY-5' 6='PGY-6' 
		7='PGY-7' 8='PGY-8' 
		9='PGY-9 or above';
	value current_skill_nutrition_ 1='Novice - I have no knowledge of evidence-based nutrition and would not feel confident discussing it with patients' 2='Advanced beginner - I have limited knowledge of evidence-based nutrition and would not feel confident discussing it with patients' 
		3='Competent - I have basic knowledge of evidence-based nutrition and can hold a conversation about it with patients' 4='Proficient - I have advanced knowledge of evidence-based nutrition and can help patients problem-solve in this area' 
		5='Expert - I have extensive training in evidence-based nutrition and can provide nutrition counseling to patients';
	value current_skill_physical_ 1='Novice - I have no knowledge of evidence-based nutrition and would not feel confident discussing it with patients' 2='Advanced beginner - I have limited knowledge of evidence-based nutrition and would not feel confident discussing it with patients' 
		3='Competent - I have basic knowledge of evidence-based nutrition and can hold a conversation about it with patients' 4='Proficient - I have advanced knowledge of evidence-based nutrition and can help patients problem-solve in this area' 
		5='Expert - I have extensive training in evidence-based nutrition and can provide nutrition counseling to patients';
	value som_prep_nutrition_ 1='Strongly agree' 2='Agree' 
		3='Neither agree nor disagree' 4='Disagree' 
		5='Strongly Disagree';
	value som_prep_physical_ 1='Strongly agree' 2='Agree' 
		3='Neither agree nor disagree' 4='Disagree' 
		5='Strongly Disagree';
	value residency_prep_nutrition_ 1='Strongly agree' 2='Agree' 
		3='Neither agree nor disagree' 4='Disagree' 
		5='Strongly Disagree';
	value residency_prep_physical_ 1='Strongly agree' 2='Agree' 
		3='Neither agree nor disagree' 4='Disagree' 
		5='Strongly Disagree';
	value current_knowledge___1_ 0='Unchecked' 1='Checked';
	value current_knowledge___2_ 0='Unchecked' 1='Checked';
	value current_knowledge___3_ 0='Unchecked' 1='Checked';
	value current_knowledge___4_ 0='Unchecked' 1='Checked';
	value current_knowledge___5_ 0='Unchecked' 1='Checked';
	value current_knowledge___6_ 0='Unchecked' 1='Checked';
	value current_knowledge___7_ 0='Unchecked' 1='Checked';
	value current_knowledge___8_ 0='Unchecked' 1='Checked';
	value current_knowledge___9_ 0='Unchecked' 1='Checked';
	value current_knowledge___10_ 0='Unchecked' 1='Checked';
	value current_knowledge___11_ 0='Unchecked' 1='Checked';
	value current_knowledge___12_ 0='Unchecked' 1='Checked';
	value current_knowledge___14_ 0='Unchecked' 1='Checked';
	value current_knowledge___15_ 0='Unchecked' 1='Checked';
	value current_knowledge___16_ 0='Unchecked' 1='Checked';
	value current_knowledge___17_ 0='Unchecked' 1='Checked';
	value form_1_complete_ 0='Incomplete' 1='Unverified' 
		2='Complete';

	run;
/* ==========================================================================================
   STEP 3: Import Survey Data from REDCap CSV File

   This DATA step reads in the raw survey data from the specified CSV file using the INFILE 
   statement and stores it as a SAS dataset in the WORK library named 'redcap'.

   Key Components:
   - &csv_file is the macro variable that holds the path to the CSV file.
   - DSD: Treats consecutive delimiters as missing values and honors quoted strings.
   - MISSOVER: Prevents SAS from moving to a new input line if data is missing.
   - LRECL=32767: Allows for very long lines (needed for wide REDCap exports).
   - FIRSTOBS=1: Starts reading from the first line (ensure this matches your CSV structure).

   Additional Notes:
   - INFORMAT statements define how each variable should be read (character or numeric).
   - FORMAT statements set how variables should be displayed once loaded.
   - INPUT specifies the exact order and type of each variable being read in.
   - The _EFIERR_ macro variable is set to "1" if any error occurs during import, 
     allowing for downstream error handling or debugging.

   This step gives you full control over how data types are assigned and ensures that long 
   text entries or checkboxes are handled appropriately.
========================================================================================== */
data work.redcap; %let _EFIERR_ = 0;
infile &csv_file  delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=1 ;

	informat record_id $500. ;
	informat redcap_survey_identifier $500. ;
	informat consent_timestamp $500. ;
	informat consent_form best32. ;
	informat consent_complete best32. ;
	informat form_1_timestamp $500. ;
	informat residency_type best32. ;
	informat residency_year best32. ;
	informat current_skill_nutrition best32. ;
	informat current_skill_physical best32. ;
	informat som_prep_nutrition best32. ;
	informat som_prep_physical best32. ;
	informat residency_prep_nutrition best32. ;
	informat residency_prep_physical best32. ;
	informat current_knowledge___1 best32. ;
	informat current_knowledge___2 best32. ;
	informat current_knowledge___3 best32. ;
	informat current_knowledge___4 best32. ;
	informat current_knowledge___5 best32. ;
	informat current_knowledge___6 best32. ;
	informat current_knowledge___7 best32. ;
	informat current_knowledge___8 best32. ;
	informat current_knowledge___9 best32. ;
	informat current_knowledge___10 best32. ;
	informat current_knowledge___11 best32. ;
	informat current_knowledge___12 best32. ;
	informat current_knowledge___14 best32. ;
	informat current_knowledge___15 best32. ;
	informat current_knowledge___16 best32. ;
	informat current_knowledge___17 best32. ;
	informat other_specify $500. ;
	informat form_1_complete best32. ;

	format record_id $500. ;
	format redcap_survey_identifier $500. ;
	format consent_timestamp $500. ;
	format consent_form best12. ;
	format consent_complete best12. ;
	format form_1_timestamp $500. ;
	format residency_type best12. ;
	format residency_year best12. ;
	format current_skill_nutrition best12. ;
	format current_skill_physical best12. ;
	format som_prep_nutrition best12. ;
	format som_prep_physical best12. ;
	format residency_prep_nutrition best12. ;
	format residency_prep_physical best12. ;
	format current_knowledge___1 best12. ;
	format current_knowledge___2 best12. ;
	format current_knowledge___3 best12. ;
	format current_knowledge___4 best12. ;
	format current_knowledge___5 best12. ;
	format current_knowledge___6 best12. ;
	format current_knowledge___7 best12. ;
	format current_knowledge___8 best12. ;
	format current_knowledge___9 best12. ;
	format current_knowledge___10 best12. ;
	format current_knowledge___11 best12. ;
	format current_knowledge___12 best12. ;
	format current_knowledge___14 best12. ;
	format current_knowledge___15 best12. ;
	format current_knowledge___16 best12. ;
	format current_knowledge___17 best12. ;
	format other_specify $500. ;
	format form_1_complete best12. ;

input
	record_id $
	redcap_survey_identifier $
	consent_timestamp $
	consent_form
	consent_complete
	form_1_timestamp $
	residency_type
	residency_year
	current_skill_nutrition
	current_skill_physical
	som_prep_nutrition
	som_prep_physical
	residency_prep_nutrition
	residency_prep_physical
	current_knowledge___1
	current_knowledge___2
	current_knowledge___3
	current_knowledge___4
	current_knowledge___5
	current_knowledge___6
	current_knowledge___7
	current_knowledge___8
	current_knowledge___9
	current_knowledge___10
	current_knowledge___11
	current_knowledge___12
	current_knowledge___14
	current_knowledge___15
	current_knowledge___16
	current_knowledge___17
	other_specify $
	form_1_complete
;
if _ERROR_ then call symput('_EFIERR_',"1");
run;


/* ==========================================================================================
   STEP 4: Assign Variable Labels and Apply Custom Formats

   This DATA step enhances the usability and interpretability of the REDCap dataset by:

   - Applying human-readable labels to each variable using the LABEL statement.
     These labels correspond to the full survey questions as written in REDCap, which 
     helps clarify the meaning of each column when viewing or exporting data.

   - Applying previously defined custom FORMATS using PROC FORMAT.
     This ensures that categorical variables (e.g., Likert responses, checkboxes) are 
     displayed as meaningful text rather than raw numeric codes (e.g., 1 = "Strongly agree").

   Purpose:
   - Make the dataset presentation-ready for PROC FREQ, PROC REPORT, or export to Excel.
   - Improve clarity for future analysts by embedding question context directly into the dataset.

   This step does not change the data values � it purely adds metadata for interpretation.
========================================================================================== */
data redcap;
	set redcap;
	label record_id='Record ID';
	label redcap_survey_identifier='Survey Identifier';
	label consent_timestamp='Survey Timestamp';
	label consent_form='Do you agree to take part in the survey?';
	label consent_complete='Complete?';
	label form_1_timestamp='Survey Timestamp';
	label residency_type='Please indicate your residency track:';
	label residency_year='What is your current year in residency?';
	label current_skill_nutrition='Please select the phrase that best describes your current skill level in counseling patients on evidence-based nutrition:';
	label current_skill_physical='Please select the phrase that best describes your current skill level in counseling patients on evidence-based physical activity:';
	label som_prep_nutrition='My medical school''s preclinical curriculum adequately prepared me to address patient questions about evidence-based nutrition.';
	label som_prep_physical='My medical school''s preclinical curriculum adequately prepared me to address patient questions about evidence-based physical activity.';
	label residency_prep_nutrition='My Plastic Surgery residency curriculum adequately prepared me to address patient questions about evidence-based nutrition.';
	label residency_prep_physical='My Plastic Surgery residency curriculum adequately prepared me to address patient questions about evidence-based physical activity.';
	label current_knowledge___1='Which areas, if any, do you have knowledge about? Select all that apply (choice=Nutrition for cardiovascular health)';
	label current_knowledge___2='Which areas, if any, do you have knowledge about? Select all that apply (choice=Nutrition for weight management)';
	label current_knowledge___3='Which areas, if any, do you have knowledge about? Select all that apply (choice=Nutrition for diabetes)';
	label current_knowledge___4='Which areas, if any, do you have knowledge about? Select all that apply (choice=Nutrition for sports/athletics)';
	label current_knowledge___5='Which areas, if any, do you have knowledge about? Select all that apply (choice=Nutrition for infants and toddlers)';
	label current_knowledge___6='Which areas, if any, do you have knowledge about? Select all that apply (choice=Nutrition for children)';
	label current_knowledge___7='Which areas, if any, do you have knowledge about? Select all that apply (choice=Nutrition during pregnancy)';
	label current_knowledge___8='Which areas, if any, do you have knowledge about? Select all that apply (choice=Nutrition for older adults)';
	label current_knowledge___9='Which areas, if any, do you have knowledge about? Select all that apply (choice=Physical activity for cardiovascular health)';
	label current_knowledge___10='Which areas, if any, do you have knowledge about? Select all that apply (choice=Physical activity for weight management)';
	label current_knowledge___11='Which areas, if any, do you have knowledge about? Select all that apply (choice=Physical activity for diabetes)';
	label current_knowledge___12='Which areas, if any, do you have knowledge about? Select all that apply (choice=Physical activity for sports/athletics)';
	label current_knowledge___14='Which areas, if any, do you have knowledge about? Select all that apply (choice=Physical activity for children)';
	label current_knowledge___15='Which areas, if any, do you have knowledge about? Select all that apply (choice=Physical activity during pregnancy)';
	label current_knowledge___16='Which areas, if any, do you have knowledge about? Select all that apply (choice=Physical activity for older adults)';
	label current_knowledge___17='Which areas, if any, do you have knowledge about? Select all that apply (choice=Other (please specify below))';
	label other_specify='If you selected other in the previous question, which area do you have knowledge about? ';
	label form_1_complete='Complete?';
	format consent_form consent_form_.;
	format consent_complete consent_complete_.;
	format residency_type residency_type_.;
	format residency_year residency_year_.;
	format current_skill_nutrition current_skill_nutrition_.;
	format current_skill_physical current_skill_physical_.;
	format som_prep_nutrition som_prep_nutrition_.;
	format som_prep_physical som_prep_physical_.;
	format residency_prep_nutrition residency_prep_nutrition_.;
	format residency_prep_physical residency_prep_physical_.;
	format current_knowledge___1 current_knowledge___1_.;
	format current_knowledge___2 current_knowledge___2_.;
	format current_knowledge___3 current_knowledge___3_.;
	format current_knowledge___4 current_knowledge___4_.;
	format current_knowledge___5 current_knowledge___5_.;
	format current_knowledge___6 current_knowledge___6_.;
	format current_knowledge___7 current_knowledge___7_.;
	format current_knowledge___8 current_knowledge___8_.;
	format current_knowledge___9 current_knowledge___9_.;
	format current_knowledge___10 current_knowledge___10_.;
	format current_knowledge___11 current_knowledge___11_.;
	format current_knowledge___12 current_knowledge___12_.;
	format current_knowledge___14 current_knowledge___14_.;
	format current_knowledge___15 current_knowledge___15_.;
	format current_knowledge___16 current_knowledge___16_.;
	format current_knowledge___17 current_knowledge___17_.;
	format form_1_complete form_1_complete_.;
run;
*To check the contents to confirm labels were placed*;
proc contents data=redcap; run;
proc print data=redcap1; run;
*This created the 52 responses I'm talking about - 5 folks started the survey but didnt finish it*;
data redcap1; set redcap; if form_1_complete = '0' then delete; run;
*Table 1*;
proc freq data = redcap1; tables residency_type residency_year ; run;
*Table 2*;
proc freq data=redcap1; tables current_knowledge___1 current_knowledge___2 current_knowledge___3 current_knowledge___4
current_knowledge___5 current_knowledge___6 current_knowledge___7 current_knowledge___8 current_knowledge___9 current_knowledge___10
current_knowledge___11 current_knowledge___12 current_knowledge___14 current_knowledge___15 current_knowledge___16 current_knowledge___17; run;
*Tables 3 / 4*;
proc freq data=redcap1;
tables som_prep_physical som_prep_nutrition current_skill_physical current_skill_nutrition/missing;
run;

proc univariate data=redcap1;
var som_prep_physical som_prep_nutrition;
run;

proc freq data=redcap;
tables residency_year ;
run;
*Table 5 code*;
proc ttest data=redcap1;
class residency_type;
var current_skill_physical current_skill_nutrition;
run;

data redcap2;
set redcap1;
if residency_year > '3' then level = '1';
else level = '0';
run;

proc ttest data=redcap2;
class level;
var current_skill_physical current_skill_nutrition;
run;
