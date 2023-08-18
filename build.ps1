Remove-Item .\out -Recurse -ErrorAction 'SilentlyContinue'

New-Item -ItemType Directory -Path .\out -ErrorAction 'SilentlyContinue'


New-Item -ItemType Directory -Path .\out\assets\favicon\ -Force
Copy-Item .\src\assets\favicon\favicon.ico .\out\assets\favicon\favicon.ico
Copy-Item .\src\html\* .\out\ -Recurse
elm make .\src\Main.elm --output .\out\spa.js


function Concatenate-CSSFiles {
    param(
        [string]$SourceDirectory,
        [string]$OutputFile
    )

    # Get all CSS files in the source directory
    $cssFiles = Get-ChildItem -Path $SourceDirectory -Recurse -Filter "*.css" -File

    Write-Host $cssFiles
    # Initialize an empty string to store the concatenated CSS content
    $concatenatedContent = ""

    # Loop through each CSS file and concatenate its content
    foreach ($file in $cssFiles) {
        $content = Get-Content $file.FullName -Raw
        $concatenatedContent += $content
    }

    # Write the concatenated CSS content to the output file
    $concatenatedContent | Out-File $OutputFile -Encoding UTF8

    Write-Host "CSS files concatenated successfully. Output file: $OutputFile"
}


Concatenate-CSSFiles -SourceDirectory ".\src\style" -OutputFile ".\out\main.css"
