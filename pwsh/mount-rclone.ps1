# Function to run rclone listremotes and select a remote using fzf
function Select-RcloneRemote {
    <#
    .SYNOPSIS
        Runs rclone listremotes and allows interactive selection of a remote using fzf.
    .DESCRIPTION
        Executes rclone listremotes to fetch the list of configured remotes and prompts the user
        to select one using fzf for interactive selection.
    .NOTES
        Requires rclone and fzf to be installed and accessible in the environment.
    #>

}

# Main script
try {
    # Call the function to select a remote
    $selectedRemote = Select-RcloneRemote

    if ($selectedRemote) {
        # Construct the mount path
        $mountPath = "C:\mnt\$($selectedRemote -replace ':','')"

        "Mounting $selectedRemote at $mountPath ..."

        # Build the rclone mount command
        $rcloneMountCommand = "rclone mount $selectedRemote $mountPath"

        # Start a background job to run the mount command
        $job = Start-Job -Name $mountPath -ScriptBlock {
            param ($cmd)
            Invoke-Expression $cmd
        } -ArgumentList $rcloneMountCommand

        # Wait for a brief moment to ensure the job starts
        Start-Sleep -Seconds 2

        # Check if the job is running
        if ($job.State -ne "Running") {
            # If not running, receive the job output and stop/remove it
            Receive-Job $job.Id
            Stop-Job $job.Id
            Remove-Job $job.Id
        } else {
            # If still running, return the job object
            $job
        }
    } else {
        "No remote selected."
    }
}
catch {
    Write-Error "Failed to mount remote: $_"
}
