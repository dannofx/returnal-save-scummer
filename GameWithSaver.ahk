/*
    AutoHotkey Script for Managing Returnal Save Files and Processes

    This script provides the following hotkeys for managing game save files and related processes for the Returnal game:
    
    - F1: Backup the current SaveGames to a timestamped backup folder.
    - F2: Restore the latest SaveGames backup and start the game.
    - F3: Kill processes related to the game, restore the latest SaveGames backup, and start the game.
    - F4: Kill processes related to the game.
    - F5: Kill processes related to the game and exit the script.

    Script Requirements:
    - The script assumes the game and launcher executables are in the same directory as the script.
    - It backs up and restores the SaveGames folder from a backup folder located in the script's directory.
    - A log of actions is saved in "script_log.txt" in the same directory as the script.

    Usage:
    1. Place this script in the same folder as your Returnal executables (e.g., "Returnal.exe").
    2. Run the script and use the hotkeys to manage your save files and processes.
    3. The script prioritizes backups containing the word "force" for restoration. If you want to stop prioritizing "force" backups, simply remove the word "force" from the name of the backup folder.
*/

#SingleInstance Force
#Persistent
SetWorkingDir, %A_ScriptDir%
EnvGet, A_LocalAppData, LocalAppData

scriptDir := A_ScriptDir
gameExePath := scriptDir "\Returnal.exe"
launcherExePath := scriptDir "\SmartSteamLoader_x64.exe"
assistantExePath := scriptDir "\Returnal-Win64-Shipping.exe"
saveFolder := LocalAppData "\Returnal\Steam\Saved\SaveGames"
backupFolder := scriptDir "\SaveBackups"
logFile := scriptDir "\script_log.txt"

If !FileExist(backupFolder)
    FileCreateDir, %backupFolder%

F1::
    BackupSaveGames()
    return

F2::
    RestoreLatestSave()
    StartGame()
    return

F3::
    KillProcesses()
    RestoreLatestSave()
    StartGame()
    return

F4::
    KillProcesses()
    return

F5::
    KillProcesses()
    ExitApp
    return

BackupSaveGames() {
    global saveFolder, backupFolder

    If FileExist(saveFolder) {
        timestamp := Format("{:T}", A_Now)
        StringReplace, timestamp, timestamp, :, -, All
        StringReplace, timestamp, timestamp, /, _, All
        StringReplace, timestamp, timestamp, \, _, All
        backupName := backupFolder "\SaveGames_" timestamp

        if FileExist(backupFolder "\SavedGames") {
            FileRemoveDir, %backupFolder%\SavedGames, 1
            Log("Existing 'SavedGames' folder deleted.")
        }

        FileCreateDir, %backupName%
        if !FileExist(backupName) {
            Log("Error: Unable to create the backup folder.")
            return
        }

        FileCopyDir, %saveFolder%, %backupName%, 1
        if (ErrorLevel) {
            Log("Error copying 'SavedGames'. ErrorLevel: " ErrorLevel)
            return
        }
        Log("'SavedGames' folder copied to backup folder with timestamp: " backupName)

        CleanOldBackups()
    } Else {
        Log("SaveGames folder not found. Skipping backup.")
    }
}

RestoreLatestSave() {
    global saveFolder, backupFolder
    FileNames := []
    Loop, Files, %backupFolder%\*, D
        FileNames.Push(A_LoopFileFullPath)
    FileNames.Sort()

    ; Check if any backup contains "force" in the name
    forceBackup := ""
    for index, filePath in FileNames {
        if InStr(filePath, "force") {
            forceBackup := filePath
            break
        }
    }

    ; If a "force" backup is found, use that for restoration
    if forceBackup {
        FileRemoveDir, %saveFolder%, 1
        FileCopyDir, %forceBackup%, %saveFolder%, 1
        Log("Restored from force backup: " forceBackup)
    } else {
        ; Otherwise, use the most recent backup
        latestBackup := FileNames[FileNames.MaxIndex()]
        If latestBackup {
            FileRemoveDir, %saveFolder%, 1
            FileCopyDir, %latestBackup%, %saveFolder%, 1
            Log("Restored from backup: " latestBackup)
        } Else {
            Log("No backups found.")
        }
    }
}

CleanOldBackups() {
    global backupFolder
    FileNames := []
    Loop, Files, %backupFolder%\*, D
        FileNames.Push(A_LoopFileFullPath)
    FileNames.Sort()
    If FileNames.Length() > 100 {
        Loop, % FileNames.Length() - 100
            FileRemoveDir, % FileNames[A_Index], 1
        Log("Cleaned old backups. Remaining backups: " FileNames.Length())
    }
}

KillProcesses() {
    Run, taskkill /IM "Returnal.exe" /T /F, , Hide
    Sleep, 1000

    Run, taskkill /IM "SmartSteamLoader_x64.exe" /T /F, , Hide
    Sleep, 1000

    Run, taskkill /IM "Returnal-Win64-Shipping.exe" /T /F, , Hide
    Sleep, 1000

    Log("Attempted to kill all processes.")
}

StartGame() {
    global launcherExePath
    Run, %launcherExePath%
    Log("Game started via launcher.")
}

Log(msg) {
    global logFile
    timestamp := Format("{:T}", A_Now)
    FileAppend, [%timestamp%] %msg%`n, %logFile%
}
