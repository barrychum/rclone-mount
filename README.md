# Rclone Remote Mount Script

This script interacts with rclone to list configured remotes, allows interactive selection using fzf, and mounts the selected remote using rclone mount.

## Prerequisites

Before using this script, ensure the following are installed and configured:

- [rclone](https://rclone.org/) - Command line program to manage files on cloud storage.
- [fzf](https://github.com/junegunn/fzf) - Command line fuzzy finder for interactive selection.

## Usage

1. Clone the repository or download the script file `mount-rclone.ps1`.

2. Open PowerShell and navigate to the directory containing `mount-rclone.ps1`.

3. Execute the script:
   ```powershell
   ./mount-rclone.ps1
   ```

4. Follow the interactive prompts:
   - Use `fzf` to select a remote from the list provided by `rclone listremotes`.
   - Once a remote is selected, the script will mount it locally under `C:\mnt\<remote-name>`.


## Notes

- This script assumes that `rclone` and `fzf` are accessible via the PATH environment variable.
- Ensure proper permissions and configurations are set for accessing your cloud storage remotes via rclone.

