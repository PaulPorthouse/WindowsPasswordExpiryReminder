# WindowsPasswordExpiryReminder
A small Powershell script which can be scheduled to run on log on to remind you to change your password before it expires. 

# Usage
* Create a scheduled task and ensure the following settings
  * Run using the account of the logged in user
  * `Run only when user is logged on`
  * Add a trigger for `At log on` for the specific user
  * Add an action to `Start a program` using the following settings
    * Program/Script: `powershell.exe`
    * Arguments: `-File C:\Users\[Username]\.startup\CheckPasswordExpiry.ps1`
  * Save the task
 
You can right-click on the task and `Run` to ensure it's working. You should see a toast notification appear
