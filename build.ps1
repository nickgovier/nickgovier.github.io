$ErrorActionPreference = "Stop"

$Root = $PSScriptRoot
$ContentDir = Join-Path $Root "content"
$OutputDir = Join-Path $Root "docs"
$StaticDir = Join-Path $Root "static"
$LayoutDir = Join-Path $Root "layout"

if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    throw "Pandoc is not installed or is not available on PATH."
}

if (Test-Path $OutputDir) {
    Remove-Item $OutputDir -Recurse -Force
}

New-Item $OutputDir -ItemType Directory | Out-Null

# Copy the content tree, including article images.
Copy-Item "$ContentDir\*" $OutputDir -Recurse -Force

# Copy the shared stylesheet.
Copy-Item `
    (Join-Path $StaticDir "style.css") `
    (Join-Path $OutputDir "style.css")

# Prevent GitHub Pages from processing the output with Jekyll.
New-Item `
    (Join-Path $OutputDir ".nojekyll") `
    -ItemType File |
    Out-Null

$MarkdownFiles = Get-ChildItem $ContentDir -Filter "*.md" -Recurse

$ContentRoot = (Resolve-Path $ContentDir).Path.TrimEnd('\', '/') +
    [System.IO.Path]::DirectorySeparatorChar

foreach ($SourceFile in $MarkdownFiles) {
    $RelativePath = $SourceFile.FullName.Substring($ContentRoot.Length)

    $OutputRelativePath = [System.IO.Path]::ChangeExtension(
        $RelativePath,
        ".html"
    )

    $OutputFile = Join-Path $OutputDir $OutputRelativePath
    $OutputParent = Split-Path $OutputFile -Parent

    New-Item $OutputParent -ItemType Directory -Force | Out-Null

    & pandoc $SourceFile.FullName `
        --from=markdown-implicit_figures `
        --to=html5 `
        --standalone `
        --css=/style.css `
        "--include-before-body=$(Join-Path $LayoutDir 'header.html')" `
        "--include-after-body=$(Join-Path $LayoutDir 'footer.html')" `
        "--output=$OutputFile"

    if ($LASTEXITCODE -ne 0) {
        throw "Pandoc failed while building $RelativePath."
    }

    Write-Host "Built $OutputRelativePath"
}

# Remove copied Markdown source files from the published directory.
Get-ChildItem $OutputDir -Filter "*.md" -Recurse |
    Remove-Item -Force

Write-Host ""
Write-Host "Site built successfully in: $OutputDir"