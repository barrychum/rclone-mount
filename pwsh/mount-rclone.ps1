# Function to run rclone listremotes and select a remote using fzf
function Select-RcloneRemote {
    # Run rclone listremotes to get the list of remotes
    $remotes = rclone listremotes

    # Use fzf for interactive selection
    $selectedRemote = $remotes | ForEach-Object { $_ -replace ':\r?\n', '' } | fzf --height 50% --reverse --prompt="Select a remote: " | Out-String

    # Return the selected remote name without the colon and newline
    return $selectedRemote -replace "\r|\n", ""
}

# Main script
try {
    # Call the function to select a remote
    $selectedRemote = Select-RcloneRemote

    if ($selectedRemote) {

        # Mount the selected remote using rclone mount
        $mountPath = "C:\mnt\$($selectedRemote -replace ':','')"

        "mounting $mountPath ..."

        $rcloneMountCommand = "rclone mount $selectedRemote $mountPath"

        $job = Start-Job -name $mountPath -ScriptBlock {
            param (
                $cmd
            )
            Invoke-Expression $cmd
        } -ArgumentList $rcloneMountCommand
        Start-Sleep -Seconds 2
        if ($job.state -ne "Running") {
            Receive-Job $job.Id
            Stop-Job $job.Id
            Remove-Job $job.id
        }  else {
            $job
        }    
    } else {
        "No file mount point has been selected"
    }
}
catch {
    Write-Error "Failed to mount remote: $_"
}
