#
# PowerPushBullet created by Wipsly - www.wipsly.com
#

# Function to send push notification
function sendPushNotification($title, $message) {

	# API-Key
	$apikey = 'YOURAPIKEY'

    # Make PSCredential object from apikey
    $cred = New-Object System.Management.Automation.PSCredential ($apiKey, (ConvertTo-SecureString $apikey -AsPlainText -Force))

    # Get all devices
    $devices = Invoke-RestMethod -Uri 'https://api.pushbullet.com/api/devices' -Method Get -Credential $cred

    # Loop trough all devices and send notification
    foreach ($device in $devices.devices) {

        # Create the notification
        $notification = @{
            device_iden = $device.iden
            type = 'note'
            title = $title
            body = $message
        }

        # Send the notification
        Invoke-RestMethod -Uri 'https://api.pushbullet.com/api/pushes' -Body $notification -Method Post -Credential $cred
    }
}