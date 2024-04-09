$connectTestResult = Test-NetConnection -ComputerName strgkm3gbh7dmz4rczukako.file.core.windows.net -Port 445; 
if ($connectTestResult.TcpTestSucceeded) { 
	cmd.exe /C 'cmdkey /add:strgkm3gbh7dmz4rczukako.file.core.windows.net /user:localhost\\strgkm3gbh7dmz4rczukako /pass:7ABy+0arqVuJBg4pVkZs9n1x5zI8pWAgKdwEpqqR8EDRtRRtIs6VuGAzDAYX3h9rjUaVjfj7zL8X+ASt3zFL9w=='; 
	New-PSDrive -Name Z -PSProvider FileSystem -Root '\\\\strgkm3gbh7dmz4rczukako.file.core.windows.net\\share1' -Persist 
} else { 
	Write-Error -Message 'Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port.' 
}\""


commandToExecute: 'powershell -Command "$connectTestResult = Test-NetConnection -ComputerName {strgAcctName}.file.core.windows.net -Port 445; if ($connectTestResult.TcpTestSucceeded) { cmd.exe /C \"cmdkey /add:{strgAcctName}.file.core.windows.net /user:localhost\{strgAcctName} /pass:{strgAcctKey}\"; New-PSDrive -Name Z -PSProvider FileSystem -Root \\'\\{strgAcctName}.file.core.windows.net\\{fileShareName}' -Persist } else { Write-Error -Message 'Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port.' }\"'