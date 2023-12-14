# Marcus Playground Frontend :earth_africa:

<div align="center">

Frontend 🌍 for realmoneycompany.com

![Logo](./.github/images/image.png)

[Development](#development-sparkles) •
[Roadmap](#roadmap-world_map) •
[FAQ](#faq-question) •
[Support](#support-love_letter)  

</div>

## Development :sparkles:

### Prerequisites :clipboard:

- [Node](https://nodejs.org/en/download/)
  - Windows: `choco install nodejs`
- [Elm](https://guide.elm-lang.org/install/elm.html)
  - Windows: `choco install elm-platform`
- [Live-server](https://www.npmjs.com/package/live-server)
  - Windows: `npm install -g live-server`
- [Sass](https://sass-lang.com/install)
  - Windows: `choco install sass`

### Build :hammer:

`.\build.ps1`, will build to `./out`

### Test :white_check_mark:

`npx elm-test`

### Run local :computer:

Run both these in seperate terminals:  
`live-server --port=8080 --entry-file=./out/index.html`  
`.\watcher.ps1`

### Deploy :rocket:

Assumes you have access to the server and have setup ssh keys.
`.\publish.ps1`

## Roadmap :world_map:

- Boardgames
- Blog

## FAQ :question:

- How do I do X?
  - Just do Y!

## Support :love_letter:  

Submit an [issue!](https://github.com/mackeper/marcus-playground-frontend/issues/new?assignees=&labels=question&projects=&template=question.yaml&title=%5BQUESTION%5D+%3Ctitle%3E)
