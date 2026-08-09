# nickgovier.github.io

Add a new folder to .\content, this will become the url, e.g.
folder name: post-stuff
url: x.github.io/post-stuff/

add an index.md inside that folder, with images alongside

update the main index.md to add the page to the table of contents

go to root and in powershell
Set-Location <root of this repo>
.\build.ps1

this will generate the output in docs which can then be committed to the repo and will automatically appear on the site

Install pandoc with:
winget install --source winget --exact --id JohnMacFarlane.Pandoc

Use draw.io to make flowcharts and save them as .webp

Footnotes:
Use [^first] somewhere in the article to add the first footnote. Then at the bottom, add:
[^first]: the footnote text.
pandoc will automatically link the footnote number to the text, and backlink as well

Three backticks delineate a code block:
```
some code
some code
some code
```

single backtick for inline code:
holding `ALT` and

## is a heading

Embed an image:
![Widget architecture](diagram.webp)

Embed an image with tooltip:
![Widget architecture](diagram.webp "Widget architecture")

