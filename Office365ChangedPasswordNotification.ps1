# Email settings
    $From = "password@contoso.com"
    $To = "admin@contoso.com"
    $SMTPServer = "mail.contoso.com"
    $SMTPPort = "25"

# Convert mail password
    $Password = ConvertTo-SecureString -string "password" -AsPlainText -Force 

# Credential object with username and password for mail authentification
    $Cred = new-object System.Management.Automation.PSCredential ($From, $Password)

# Module for Office365
    Import-Module MSOnline

# Office365 admin account
    $Office365Admin = "admin@contoso.com"

# Convert Office365 password
    $Office365Password = ConvertTo-SecureString -string "password" -AsPlainText -Force 

# Credential object with username and password for office365 authentification
    $Office365Cred = new-object System.Management.Automation.PSCredential ($Office365Admin, $Office365Password)

# Connect to Office365
    Connect-MsolService –Credential $Office365Cred

# Create session
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Office365Cred -Authentication Basic -AllowRedirection
 
# Import Session
    Import-PSSession $Session 

# Set script run interval (in minutes). If you run the script again you don't get double notifications
$scriptRunInterval = 720
 
# Get script launch time
$compareDateTime = get-date -Format s
 
# Convert script interval in hours
$scriptRunIntervalHours = (New-Timespan -Minutes $scriptRunInterval).Hours
 
# Create empty array
$usersFound = @()
# HTML for list
$usersFound += "<ul>"
$usersFoundDL = @()
 
# Counter (if email should be sent or not)
$userCount = 0
 
# Get the last password change timestamp
$userinfo = Get-MsolUser -All | select DisplayName, LastPasswordChangeTimeStamp
 
foreach ($user in $userinfo) {
 
    if ($user.LastPasswordChangeTimeStamp -ne $null) {
 
        # Get the amount of minutes between the run time of this script and the last password change time
        $timeDiff = (New-TimeSpan $user.LastPasswordChangeTimeStamp $compareDateTime).TotalMinutes
 
        # If the password has been changed in the last 4 hours
        if ($timeDiff -le $scriptRunInterval) {
 
            $usersFound += "<li>" + $user.displayname  + "</li>"
            $usersFoundDL += $user.SamAccountName + ";"
            $userCount++
 
        }
    
    }
 
}
 
# End the ordered list
$usersFound += "</ul>"
 
# Determine if we need to send an e-mail or not
if ($userCount -ne 0) {
 
    # Craft the e-mail based on the user information gathered
    $emailSubject = "[Password Change Notificaton] for $compareDateTime"
    $emailBody = "The following users have changed their password in the last $scriptRunIntervalHours hours from $compareDateTime `n`r$usersFound `n`rNice and easy copy/paste DL of the found users: `n`r$usersFoundDL"
 
    # Send a notification for each user who has changed their password
    Send-MailMessage -From $From -To $To -Subject $emailSubject -Body $emailBody -SmtpServer $SMTPServer -Port $SMTPPort -Credential $Cred -BodyAsHtml 
 
}

 
 
 
