# Tibetan-English translator for CLI

[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

![Bod](bod.png)

## About

The Hibet translates with all dictionaries from [tibetan-dictionary](https://github.com/christiansteinert/tibetan-dictionary) project. It consume both [Wylie transliteration](https://en.wikipedia.org/wiki/Wylie_transliteration) and [tibetan script](https://en.wikipedia.org/wiki/Tibetan_script) from input.

## Features

1. Hibet uses about 40 dictionaries to translate Tibetan words to English or Tibetan.
2. If translations have Tibetan texts it printed as wylie (and as tibetan script for dictionary №37 yet).

## Installation

1. Install [stack](https://docs.haskellstack.org/en/stable/README/#how-to-install)

2. Install Hibet

        git clone https://github.com/willbasky/Hibet.git

        cd ./Hibet

        stack install Hibet

## Usage video

[![asciicast](https://asciinema.org/a/Me0raohKWoXNLFd9YbFeTNQZt.svg)](https://asciinema.org/a/Me0raohKWoXNLFd9YbFeTNQZt)

Help commands:

$ tibet -h

    Hibet is command line translator from Tibet to English language.

    Usage: tibet [-v|--version] COMMAND
      Translate from Tibetan to English
    Available options:
      -h,--help                Show this help text
      -v,--version             Show Hibet's version

    Available commands:
      shell                    Start the translate shell
      om                       Print Om to a terminal
      show                     Show titles or descriptions of dictionaries

$ tibet show -h

    Usage: tibet show COMMAND
      Show commands

    Available options:
      -h,--help                Show this help text

    Available commands:
      names                    Show dictionary titles
      meta                     Show dictionary description

$ tibet shell -h

    Usage: tibet shell [-s|--select ID_LIST]
      Start the translate shell

    Available options:
      -h,--help                Show this help text
      -s,--select ID_LIST      Select id list of dictionaries separeted by space or comma

Input `tibet shell` in terminal. And then write your `query` using _Wylie_ or _Tibet script_:

    $ tibet shell
    Which a tibetan word to translate?
    > mo
    5. Hopkins 2015
    ► (1) female; woman; wife; feminine particle; she; (2) particle indicating the end of a statement

    7. Rangjung Yeshe
    ► the girl
    ► lady, female, woman. 2) divination, prophecy
    ► 1) auspicious, mo divination/ prophesy [R]; 2) feminine particle, female, woman, she [R]; 3)  terminative after MA; 4) noun forming particle [R]; 5) is [don ci mo: what is the meaning]

    8. Berzin
    ► prognostication

    etc...

To quit, just input:

    :q

To get queries of the session, input:

    :h

## Contribution

Contribution is welcome!
