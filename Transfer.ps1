# Email Settings
$From = "XXX@XXX.com"
$To = "XXX@XXX.com"
$SMTPServer = "XXX.mail.protection.outlook.com"
$SMTPPort = "25"

# Clear Error Log and Set Start Time
$moveFile = “”
$start = get-date

# Mount Azure Instance
cmdkey /add: XXX.file.core.windows.net /user: XXX /pass: XXX

# Grab and Count Files From Local Folder and Set Location Folder
$files = get-childitem "C:\XXX" -filter “*.bak”
$count = (get-childitem "C:\XXX" -filter “*.bak”).Count
$blob = “\\XXX.file.core.windows.net\XXX”

# Transfer Files to Azure Storage
Foreach ($file in $files) {
Move-Item ("C:\XXX\" + $file) $blob -force -ErrorVariable +moveFile }

# Error Handling and Email Message Creation
if ($moveFile) {
$Subject = "Backup File Transfer Failed"
$Body = “The file failed to transfer due to the following error:

“ + ($moveFile | out-string)  + “

Please log into the respective server and correct the issue.

Process Run Time:
Began: ” + $start + "
Completed: " + (get-date) }
Elseif ($count -lt 2) {
$Subject = "Backup File Transfer Failed"
$Body = "There were " + $count + “ file(s) transferred successfully.
" + (2 - $count) + " file(s) were/was not present. Backup(s) may have failed.
Please log into the respective server and correct the issue.

Process Run Time:
Began: ” + $start + "
Completed: " + (get-date) }
Else {
$Subject = "Backup File Transfer Successful"
$Body = "" + $count + “ files transferred successfully.

Process Run Time:
Began: ” + $start + "
Completed: " + (get-date) }

# Send Status Email
Send-MailMessage -From $From -to $To -Subject $Subject `
-Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl
