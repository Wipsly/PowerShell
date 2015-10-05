# Email settings
    $From = "admin@contoso.com"
    $To = "support@contoso.com"
    $Subject = "Your Subject"
    $Body = "Your Body Text"
    $SMTPServer = "mail.contoso.com"
    $SMTPPort = "25"

# Convert password
    $Password = ConvertTo-SecureString -string "YourPassword" -AsPlainText -Force 

# Credential object with username and password
    $Cred = new-object System.Management.Automation.PSCredential ($From, $Password)

# Send Email with email settings and authenticate with credentials object
    Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -Credential $Cred

