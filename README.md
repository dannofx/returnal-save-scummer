# Returnal Save Scummer

A tool for managing and restoring backup save files for **Returnal**, with easy-to-use hotkeys for backing up, restoring, and managing game processes.

## Features

- **F1**: Backup the current SaveGames to a timestamped backup folder.
- **F2**: Restore the latest SaveGames backup and start the game.
- **F3**: Kill processes related to the game, restore the latest SaveGames backup, and start the game.
- **F4**: Kill processes related to the game.
- **F5**: Kill processes related to the game and exit the script.

## Requirements

- **AutoHotkey**: This script depends on AutoHotkey to run. You can download it from [https://www.autohotkey.com/](https://www.autohotkey.com/).
- **Returnal Game Files**: The script assumes that the game executables (`Returnal.exe`, `SmartSteamLoader_x64.exe`, etc.) are in the same directory as this script.

## Usage

1. Place this script in the same folder as your **Returnal** executables (e.g., `Returnal.exe`).
2. Run the script via AutoHotkey.
3. Use the hotkeys to manage your save files and processes.

### Backup Behavior

The script will create backups of your SaveGames folder in the `SaveBackups` directory. The backup folder names will include a timestamp to keep them organized.

### Force Backup Priority

The script prioritizes backups that contain the word `"force"` in the backup folder name. If you want to stop prioritizing "force" backups, simply remove the word "force" from the backup folder name.

### Cleaning Old Backups

The script will keep the most recent 100 backups. Older backups will be automatically removed to save space.

## Hotkeys

- **F1**: Backup SaveGames.
- **F2**: Restore the latest SaveGames and start the game.
- **F3**: Kill processes, restore the latest SaveGames, and start the game.
- **F4**: Kill game processes.
- **F5**: Kill game processes and exit the script.

## Example Log

All actions performed by the script (such as backup creation and process killing) are logged in the `script_log.txt` file.

```text
[2024-12-03 18:10:22] 'SavedGames' folder copied to backup folder with timestamp: C:\Users\Username\Documents\Returnal-Save-Scummer\SaveBackups\SaveGames_2024-12-03_18-10-22
[2024-12-03 18:12:01] Restored from backup: C:\Users\Username\Documents\Returnal-Save-Scummer\SaveBackups\SaveGames_2024-12-03_18-10-22
