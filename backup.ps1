
<#

    Script written by Qrow of the Qrow Technology blog.


    This is a script to create backup copies of files in a
        specified directory and place the backup copies in
        another specified directory.

    This script is not a replacement for a full backup program
        and process and should be used only on small scale such as
        for testing changes to files.

    This script is provides as-is and has absolutely no guarantees.
    
#>

# Add in required .NET assembly for Folder Picker
Add-Type -AssemblyName System.Windows.Forms


# Variables
    #Folder Locations
$FolderToBackup
$DestinationFolder
    #Instantiate the folder picker dialog
$FolderPicker = New-Object System.Windows.Forms.FolderBrowserDialog



Write-Host "This Script is not a replacement for a full backup program or process. Use with caution." -ForegroundColor Red -BackgroundColor Yellow

Start-Sleep -Seconds 3

Write-Host "Please select the folder containing the files to backup."

Start-Sleep -Seconds 2

# Show the folder picker dialog and get the source folder.
$null = $FolderPicker.ShowDialog()

# Test that the user didn't click cancel on the dialog, or do something else weird.
if ($FolderPicker)
{
    # Assign the chosen folder to our variable
    $FolderToBackup = $FolderPicker.SelectedPath

    # Check that we can access the folder
    if (Test-Path $FolderToBackup)
    {
        # Ask for the destination folder.
        Write-Host "Select an EMPTY folder to store the backups in, " -NoNewline
        Write-Host "as the backup process will delete any present files." -ForegroundColor Red -BackgroundColor Yellow

        Start-Sleep -Seconds 2

        # Pop the picker dialog
        $null = $FolderPicker.ShowDialog()
        

        if ($FolderPicker)
        {
            $DestinationFolder = $FolderPicker.SelectedPath

            if (Test-Path $DestinationFolder)
            {
                Write-Host "You Selected:  ($FolderToBackup)   As the Source Folder"
                Write-Host "You Selected:  ($DestinationFolder)    As the Destination Folder"

                Write-Host "The backup will DELETE ANY files already in the destination!" -ForegroundColor Red -BackgroundColor Yellow
                $Confirmation = Read-Host "Is this right?   Y/N"

                # Check the user's input
                Switch ($Confirmation)
                {
                    Y{
                        Write-Host "Proceding to backup all files in specified directory"
                        
                        # Empty the Destination directory
                        Remove-Item -Path $DestinationFolder\* -Recurse
                        
                        # Copy the items in the source folder
                        Copy-Item -Path $FolderToBackup\* -Destination $DestinationFolder -Recurse -Force
                        
                        # Rename the items in the destination folder, adding a bak extension. 
                        # -Attributes !Directory says to not rename directories, but still crawl them
                        Get-ChildItem -Path $DestinationFolder -Recurse  -exclude "*.bak" -Attributes !Directory | Rename-Item -NewName {$_.name + ".bak"} -Force
                    }
                    Yes{
                        Write-Host "Proceding to backup all files in specified directory"
                        
                        # Empty the Destination directory
                        Remove-Item -Path $DestinationFolder\* -Recurse
                        
                        # Copy the items in the source folder
                        Copy-Item -Path $FolderToBackup\* -Destination $DestinationFolder -Recurse -Force
                        
                        # Rename the items in the destination folder, adding a bak extension. 
                        # -Attributes !Directory says to not rename directories, but still crawl them
                        Get-ChildItem -Path $DestinationFolder -Recurse  -exclude "*.bak" -Attributes !Directory | Rename-Item -NewName {$_.name + ".bak"} -Force
                    }
                    N{
                        Write-Host "Stopping execution. Please start again."
                        Exit
                    }
                    No{
                        Write-Host "Stopping execution. Please start again."
                        Exit
                    }
                    Default {
                        Write-Host "I don't understand. Please start again."
                        Exit
                    }
                }


            }
            else
            {
                Write-Host "Something went wrong, please try again." -ForegroundColor Red
                Exit
            }
        }
        else
        {
            Write-Host "Something went wrong, please try again." -ForegroundColor Red
            Exit
        }
    }
    else
    {
        Write-Host "Something went wrong, please try again." -ForegroundColor Red
        Exit
    }
}
else 
{
    Write-Host "Something went wrong, please try again." -ForegroundColor Red
    Exit
}
