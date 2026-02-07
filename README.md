# 🧑‍⚖️ OSS Audit
Simple, opinionated tool to compile a list of the open source software in use
in a project. Each library is listed together with its licenses and links,
ready to be audited.

**Useful features:**
* No dependencies, can be ran anywhere
* Does not require any package manager nor for the code to work or be installed
* Output can be in JSON or CSV format
* Scans for nested packages
* Accepts an override file to programmatically amend results

## Installation

Can be installed with

    $ gem install oss_audit

## Usage

A useful help screen will be displayed if launched with no arguments.

Run as

    $ oss_audit [options] <dir1> ... <dirN>

Output is printed on STDOUT and can be easily redirected using `>`. Informative
logging is sent to STDERR.

A more complete example is

    $ oss_audit -f csv -o overrides.json pj/serviceA pj/serviceB > libs.csv

## Overrides

Not all libraries specify the license or useful links in their configuration
files. Instead of manually fixing that after the fact, create an override file
in JSON and pass it as argument to the tool, e.g.,
```json
[
  { "manager":"Bundler", "name":"barnes", "licenses":["MIT"] },
  { "manager":"Yarn", "name":"sinon", "homepage":"https://sinonjs.org/" }
]
```

## Limitations

Package Managers currently supported:
* Bundler
* Yarn / NPM (anything with `package.json`)

Adding others is trivial, look in `lib/oss_audit/managers` for examples.

Currently ignores version numbers but that too can be easily added.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alessio-signorini/oss_audit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
