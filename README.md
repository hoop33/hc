# hc -- Hex Colors on the Command Line

[![Join the chat at https://gitter.im/hoop33/hc](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/hoop33/hc?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/hoop33/hc.svg?branch=master)](https://travis-ci.org/hoop33/hc)
[![Issues](https://img.shields.io/github/issues/hoop33/hc.svg)](https://github.com/hoop33/hc/issues)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

`hc` is a command-line tool for working with hex colors. It's written in Objective-C and runs on Mac OS X 10.9+.

## Installation
Open the project in Xcode 10+ and build normally. You can also build from the command line using `xcodebuild`. To create a Release build, for example, you can type:

```
xcodebuild -scheme hc DSTROOT=. archive
```

This command creates a Release build in `./usr/local/bin`.

## Usage
`hc` commands take the form:

```
hc <command> [args]
```

You can get help by typing `hc help`.  Generally, you type `hc <command>` followed by a 3- or 6-digit hex color, and then any arguments required by the command. For example, to show a red color, type:

```
hc show f00
```

You can specify colors with or without a preceding **#**, but your shell will likely make you surround a **#** color with quotes:

```
hc show "#ab1278"
```

### Commands
Commands specify what you're trying to do to a color. You can get a list of commands by typing `hc commands`. The output will look like this:

```
   average     Average colors
   commands    List available commands
   complement  Show complement
   darken      Darken color
   desaturate  Desaturate color
   difference  Subtract colors
   exclusion   Subtract colors, with lower contrast
   grayscale   Desaturate color completely
   hardlight   Overlays, but with the color roles reversed
   help        Display help
   lighten     Lighten color
   mix         Mix two colors
   multiply    Multiply two colors
   negation    Opposite of difference
   options     List available options
   outputs     List available outputs
   overlay     Combine multiply and screen
   saturate    Saturate color
   screen      Opposite of multiply
   show        Show color
   softlight   Similar to overlay
   spin        Spin color
   version     Display version
```

You can get help for a specific command by typing:

```
hc help <command>
```

### Outputs
`hc` defaults to writing output to stdout. Using the `-o` option, however, you can direct `hc` to write its output elsewhere. To write a color to a file, for example, type:

```
hc show ab1278 -o file
```

That will write a file called `ab1278.png` to the current directory.

You can list the available outputs by typing:

```
hc outputs
```

The output will look like this:

```
   clip        Outputs to the clipboard
   file        Outputs as files
   note        Outputs as user notifications
   text        Outputs as text to stdout
```

You can get help for a specific output by typing:

```
hc help <output>
```

### Options
List available options by typing:

```
hc options
```

The output will look like this:

```
   -o, --output <output>   Use <output> to output data
   -v, --version           Display version
```

You can get help for a specific option by typing:

```
hc help <option>
```

## Notes About Colors
I'm no color guru. I wrote this tool to help me as I'm working with HTML, CSS, and LESS, so I've spent a fair amount of time googling color algorithms and looking at the source code of LESS. The HSL stuff has given me some headaches; not only do different algorithms exist, but also corresponding algorithms in different languages produce slightly different results because of rounding differences. Consequently, the results might not precisely match the LESS results.

Also, this is using the RGB color wheel, so rotating 180 degrees from red produces a complement of cyan, not green.

## Future Direction
* Implement the entire LESS command set
* Add the alpha channel
* Implement alternate color wheels
* Add other color formats
* Add ways to specify the color on the command line (HSL, RGB, et al.)

## Contributing
Fork and send pull requests. To add commands, outputs, or options, you can simply implement the corresponding protocol (`Command`, `Output`, or `Option`), and the `hc` framework will find it and make it fully available throughout the application.

## License
`hc` is licensed under the MIT license.
