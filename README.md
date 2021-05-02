#compare_N_lists_fast.pl
This is a perl file tested under perl perl 5, version 26, subversion 1 (v5.26.1) performing a merge of multiple tabular files based on the content of the first column.
Important notes:
-lists must have the same nuber of columns,
-lists are compared according to the names in the first column,
-names in the first columns should not have empty spaces,
-the files (lists) to be merged cannot have multiple elements with the same ID (name) in the first column,
-the files have to be listed (one per line) in a file which is the only argument of the script,
-lunch the script as "compare_N_lists_fast.pl list_of_files_to_be_merged.txt"
-the output will be in "merged_lists.txt"
-after launching the script you have to insert the number of columns of your files and press "enter"

-In the folder "example files" there are some annotation obtained using eggNOG, files are tabular and includes seven columns.
-After downloading the folder just create using a list with the files you are going to merge using "ls ./example_files/* > list_of_files_merge.txt"
-Then launch the script using "perl compare_N_lists_fast.pl list_of_files_merge.txt"
-When you will read "Insert the number of columns that your lists have", enter 7 and press enter.
-The Output file will be named "merged_lists.txt"
-The first column of the file is the global (univocal) list of all the codes present in the first column.
