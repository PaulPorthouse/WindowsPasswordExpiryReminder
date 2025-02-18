function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text | where { $_.id -eq "1" }).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text | where { $_.id -eq "2" }).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    $Toast.Tag = "PowerShell"
    $Toast.Group = "PowerShell"
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
    $Notifier.Show($Toast);
}


# Get the current date
$Today = Get-Date
$Tomorrow = ($Today.AddDays(1)).Date

# Get the local user
$Username = $Env:USERNAME

# Get the expiry date
$User = Get-LocalUser -Name $Username
$ExpiryDate = ($User.PasswordExpires).Date

if ($Tomorrow -eq $ExpiryDate) {
    Show-Notification -ToastTitle "Password Expiry Warning" -ToastText "Warning, your password is due to expire tomorrow, please change it now."
}
else {
    $ExpiresInDays = ($ExpiryDate - $Tomorrow).Days
    Show-Notification -ToastTitle "Password Expiry Warning" -ToastText "Password due to expire in $ExpiresInDays days"
}
