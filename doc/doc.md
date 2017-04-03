
# IVS-VUT-BIT-2016-2017 Documentation

## Table of contents

* [Úvod](#uvod)
* [Instalace](#instalace)
* [Odinstalace](#odinstalace)
* [Funkce](#funkce)
  * [Absolutní hodnota](#abs-hodnota)
  * [Faktorial](#faktorial)
  * [Přirozený logaritmus](#n-logaritmus)
  * [Obecný logaritmus](#logaritmus)
  * [Mocnina](#mocnina)
  * [Náhodné číslo](#rand-cislo)
  * [Obecná odmocnina](#obecna-odmocnina)
  * [Odmocnina](#odmocnina)
* [Tutorial](#tutorial)
  * [Komponenty](#komponenty)
  * [Přáce s kalkulačkou](#calc-work)

## Introduction

This application represents classic calculator with special functions. Calculator can work with hugh nun numbers, because his core is written in [Python](https://www.python.org/).

## Instalace

## Odinstalace

## Funkce

Ve všech funkcích jdou použít klasické operátory (+, -, *, /) a i jiné funkce.

### Absolutní hodnota

Zápis:

`abs([číslo])`

nebo

`|[číslo]|`

Příklady:

`|-6|`

`||-12 + 4| + 5|`

`abs(-6)`

`abs(abs(-12 + 4) + 5)`

### Faktorial

Zápis:

`fact([číslo])`

nebo

`[číslo]!`

Příklady:

`6!`

`6!!`

`fact(6)`

`fact(fact(6))`

### Přirozený logaritmus

Zápis:

`ln([číslo])`

Příklady:

`ln(5)`

`ln(5 + 2)`

### Obecný logaritmus

Zápis:

`log([číslo], [základ logaritmu])`

Příklady:

`log(2, 2)`

`log(54 + 8, 15)`

### Mocnina

Zápis:

`pow([mocněnec], [mocnitel])`

nebo

`[mocněnec]**[mocnitel]`

Příklady:

`5**2`

`pow(5, 2)`

### Náhodné číslo

Zápis:

`rand()`

### Obecná odmocnina

Zápis:

`root([odmocněnec], [odmocnitel])`

Příklady:

`root(3, 6)`

`root(86, 15*2)`

### Odmocnina

Zápis:

`sqrt([odmocněnec])`

Příklady:

`sqrt(8)`

`sqrt(96 + 42)`

## Tutorial

V této kapitole bude popsána práce v Barbie Calculator, jeho funkce a užitečné vlastnosti, a dále také základní panely pro práci.

Zde na obrázku je Barbie Calculator po zapnutí

[Prázdná kalkulačka](empty.png)

*Okno programu má pevně nastavený poměr stran*.

### Komponenty

#### Převod do číselných soustav

Pokud je výsledek _celočíselný_, tak bude výsledek převeden a zobrazen ve 4 číselných soustavách (desítkové, šestnáctkové, osmičkové, dvojkové).

[Číselné soustavy po otevření](system1.png) [Číselné soustavy s převedeným číslem](system2.png)

#### Funkce a zápisové okno

Jednou z hlavních částí je panel s funkcemi a k němu navazující okno s výrazem k výpočtu.

[Bez výrazu - prázdné](func1.png) [S funkcí a operací](func2.png)

#### Proměnné

Barbie Calculator umí také používat proměnné, takže si můžete uložit výpočty do proměnných a dále je používat

Dávejte si ale pozor na to, že proměnné jsou **case sensitive**.

[Panel proměnných](variable.png)

### Práce s kalkulačkou

Na následujícím obrázku je ukázané tzv. dopňování kódu

[Doplňování kódu](complete.png)

Dále také rozšíření výrazu do funkce.

Pokud výraz označíte a a kliknete na funkci, tak se celý výraz vloží do požadované funkce.

[Výraz před použitím funkce](enfunc1.png)

[Výraz po použití funkce](enfunc2.png)

Jak vidíte už jsou inicializované nějaké proměnné. V jejich nastavení je možný přepis na `1` nebo `0`, a nebo také proměnnou smazat. Pokud bude proměnnýc příliš, můžete se k nim dostat pomocí posuvníku (případně kolečka myši).

[Mnoho proměnných a jejich nastavení](many_vars.png)

Další ukázkou bude kombinace mnoha funkcí s vysokým výsledkem. Při vysokých (nebo nízkých) výsledcích se výsledek vypisuje ve formátu `[cifra].[2 cifry]` se zaokrouhlením na příslušné 2. desetinné místo.

[Posuvník u číselných soustav při vysoké hodnotě](long_result.png)







