# AnsiMail @ bsd.ac

## Work-flow for generating the website

### Clone

```
git clone --recurse-submodules git@github.com:AnsiMail/ansimail.bsd.ac
```

### Generate markdown

The website is stored in an org mode format, which needs to be converted to markdown for hugo.

Use `ox-hugo`: https://ox-hugo.scripter.co/

### Create static webpages

Create the static webpages in the `public` directory
```
hugo -D
```

## Contributing

Only pull requests updating the files in `org` folder are accepted.

Everything else is generated automatically.
