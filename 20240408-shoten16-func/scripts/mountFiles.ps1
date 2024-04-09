$connectTestResult = Test-NetConnection -ComputerName {strgAcctName}.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # 再起動時にドライブが維持されるように、パスワードを保存する
    cmd.exe /C "cmdkey /add:`"{strgAcctName}.file.core.windows.net`" /user:`"localhost\{strgAcctName}`" /pass:`"{strgAcctKey}`""
    # ドライブをマウントする
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\{strgAcctName}.file.core.windows.net\{fileShareName}" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}