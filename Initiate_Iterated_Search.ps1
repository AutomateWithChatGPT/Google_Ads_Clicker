# Load the System.Windows.Forms assembly
Add-Type -AssemblyName System.Windows.Forms
# Create a new instance of the FolderBrowserDialog class
$dialog = New-Object System.Windows.Forms.FolderBrowserDialog
# Configure the dialog settings
$dialog.Description = "Please select the path to the root of the Google Ads Clicker project."
$dialog.RootFolder = [System.Environment+SpecialFolder]::Desktop
# Show the dialog and wait for the user to select a folder path
if ($dialog.ShowDialog() -eq 'OK') {
    $path = $dialog.SelectedPath
}
# Set the current directory to the selected folder path
Set-Location $path
$pythonScriptPath = "ad_clicker_iterate_searches_take_screenshots.py"
# Create a new instance of the OpenFileDialog class
$fileDialog = New-Object System.Windows.Forms.OpenFileDialog

# Configure the dialog settings
$fileDialog.Title = "Please select the file containing search keywords."
$fileDialog.InitialDirectory = $path
$fileDialog.Filter = "Text files (*.txt)|*.txt"
# Show the dialog and wait for the user to select a file
if ($fileDialog.ShowDialog() -eq 'OK') {
    $keywordFilePath = $fileDialog.FileName
}
# Prompt the user for the number of seconds to wait on the ad page
$adVisitTime = Read-Host "Please enter the number of seconds to wait on the ad page opened"
# Loop through each keyword in the file
foreach ($keyword in Get-Content $keywordFilePath) {
    # Construct the Python command with user inputs
    $pythonCommand = "python `"$pythonScriptPath`" -f `"$keywordFilePath`" -t $adVisitTime --headless"  
    # Prompt the user for an excludes input
    $excludes = Read-Host "Please enter a string of words to exclude in ads"
    # If excludes is entered, add the argument to the Python command
    if ($excludes) {
        $pythonCommand += " --excludes `"$excludes`""
    }
    # Run the Python script using the constructed command
    Start-Process powershell -ArgumentList "-Command `"$pythonCommand`"" -NoNewWindow -Wait
    # Replace this with your desired wait time between script runs
    Start-Sleep -Seconds 10
}
