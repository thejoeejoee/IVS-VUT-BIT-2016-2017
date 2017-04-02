
# IVS-VUT-BIT-2016-2017 Documentation

## Table of contents

* [Introduction](#introduction)
* [Usage](#usage)
  * [Installation](#installation)
  * [Uninstallation](#uninstallation)
* [Input syntax](#input-syntax)
  * [Number systems](#number-systems)
  * [Operators](#operators)
  * [Functions](#functinos)
* [Getting started](#getting-started)
  * [Components](#components)
  * [Step by step](#step-by-step)

## Introduction

This application represents classic calculator with special functions. Calculator can work with hugh nun numbers, because his core is written in [Python](https://www.python.org/).

## Usage /todo

### Installation

### Uninstallation

## Input syntax


### Number systems ???

Calculator can compute with classic number systems, such as decimal, hexa-decimal, octal and binary.

#### Decimal

Decimal mode is set implicitly.

Examples of decimal numbers:

`156`

`-56`

`42.666`

`-0.135`

#### Hexadecimal

Requires calculator to be switched to hexadecimal mode.

Valid characters: `0-9 A-F` (lower case `a-f` are not valid)

Examples:

`3A1F`

`FFFF`

`561`

#### Octal

Requires calculator to be switched to octal mode.

Valid characters: `0-7`

Examples:

`37`

`777`

#### Binary

Requires calculator to be switched to binary mode.

Valid characters: `0-1`

Examples:

`101101`

`1111`

### Operators

#### Add

Syntax:

`[left-operand] + [right-operand]`

Requires two operands.

Examples:

`3 + 6`

`-96 + 42`

#### Substract

Syntax:

`[left-operand] - [right-operand]`

Requires two operands.

Examples:

`3 - 6`

`26489 - (153 - 145)`

#### Multiply

Syntax:

`[left-operand] * [right-operand]`

Requires two operands.

Examples:

`3 * 6`

`-96 * 42`

#### Divide

Syntax:

`[left-operand] / [right-operand]`

Requires two operands.

Examples:

`3 / 6`

`-96 / 42`

#### Power of

Syntax:

`[base] ^ [exponent]`

or

`[base] ** [exponent]`

or

`pow([base], [exponent])`

Requires two operands.

Examples:

`3 ^ 6`

`-96 ** 42`

`pow(2, 10)`

#### Factorial

Factorial works only with integer numbers.

Syntax:

`[number]!`

or

`fact([number])`

Example:

`6!`

`4!!`

`(21 / 3)!`

`fact(6)`

`fact(fact(6))`

#### Absolute value

Syntax:

`|[number]|`

or

`abs([number])`

Examples:

`|-6|`

`||-12 + 4| + 5|`

`abs(-6)`

`abs(abs(-12 + 4) + 5)`

### Functions

#### Abs

Syntax:

`abs([number])`

Examples:

`|-6|`

`||-12 + 4| + 5|`

`abs(-6)`

`abs(abs(-12 + 4) + 5)`

#### Fact

Syntax:

`fact([number])`

Example:

`fact(6)`

`fact(fact(6))`

`fact(27 / 3)`

#### Ln

Ln is native logarithm (with Euler number base)

Syntax:

`ln([number])`

Example:

`ln(5)`

`ln(5 + 2)`

#### Log

Syntax:

`log([number], [log-base])`

Example:

`log(2, 2)`

`log(54 + 8, 15)`

#### Pow

Syntax:

`pow([number], [nth-power])`

Example:

`pow(5, 2)`

#### Rand /todo

#### Root

Root is computing real root of number

Syntax:

`root([number], [nth-root]`

Examples:

`3 + 6`

`-96 + 42`

#### Square root

Syntax:

`sqrt([number])`

Examples:

`sqrt(8)`

`sqrt(96 + 42)`

## Getting started

First of all you will start the Barbie calculator application. After that you will see working field:

[No value set calculator](empty.png)

*This main frame can be resized only with implicit proportions*.

### Components

In this subsection will be described main parts of calculator.

#### Number systems converter

If result is _integer type_, this result will be converted and showed in 4 different number systems (decimal, hexa-decimal, octal, binary).

[Number systems bar with zero](system1.png) [Number systems bar with numbers](system2.png)

#### Functions & expressions

There is a function bar with build-in functions like *rand()* or *pow()* and expression field where you can write expressions to compute.

[No expression](func1.png) [Functions + numbers](func2.png)

#### Variables

Barbie calculator also knows computing with variables, so you can set your own variables and use them in calculations.

Be aware, because variable names are **case sensitive**

[Variable bar](variable.png)

#### Results

There are 2 result windows one with actual result and one with whole result ??? /todo

### Step by step /todo















