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
# Output the value of the parameter
Write-Host "The folder path you selected is: $path"
# Set the current directory to the selected folder path
Set-Location $path
# Prompt the user for input
$googleQuery = Read-Host "What Are We Googl-ing This Time?"
$googleException = Read-Host "Are there URLs or Specific Words do I need to Avoid Clicking On?"
$count = Read-Host "Please enter the number of times to run this search and click on the links"
$count = [int]$count
.\env\Scripts\activate
$command = "python ad_clicker.py -q `"$googleQuery`" -e `"$googleException`" -t 10"
for ($i = 1; $i -le $count; $i++) {
    Invoke-Expression $command
}
#python ad_clicker.py -q "Houses for sale in arlington texas" -e "christineballardrealestate.com" -t 10
