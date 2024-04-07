$uname = "mocchiri zukako"
$password = "P@ssw0rd1234"
$password = ConvertTo-SecureString -AsPlainText -Force $password
$nickname = "zukako-shoten16"
$upn = "zukako-shoten16@kedamakawaii.com"
New-AzADUser -DisplayName $uname -Password $password -AccountEnabled $true -MailNickname $nickname -UserPrincipalName $upn