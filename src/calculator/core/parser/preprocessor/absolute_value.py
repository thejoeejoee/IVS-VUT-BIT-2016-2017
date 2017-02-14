# coding=utf-8


class AbsoluteValuePreprocessor(object):
    """
    Preprocessor, which converts all absolute values in expression to call math function abs.
    |x| -> abs(x)
    |3 + |3 - 6|| -> abs(3 + abs(3 - 6))
    """
    ABSOLUTE_VALUE_SIGN = '|'
    ABSOLUTE_VALUE_FUNCTION_NAME = 'abs'

    def __call__(self, expression: str) -> str:
        if self.ABSOLUTE_VALUE_SIGN not in expression:
            return expression

        expression = abs(expression)
        return expression
    def abs(self, string):

        """ Promenne definujici zakladni retezce pro praci a 'pocet', ve kterem je ulozen pocet '|' """
        pocet = string.count('|')
        operatory = "+-*/"
        promenne = "abcdefx"
        cisla = "0123456789"

        """ Osetreni zda neni lichy pocet zavorek """
        if (pocet % 2):
            return "ERROR"
        else:
            """ Zakladni promenne pro praci """
            counter = 0  # pocet pruchodu cyklem for
            abs_vystup = ''  # vysledny retezec
            pocet_svislitka = 0  # pocet '|' znaku
            je_cislo = 0  # prakticky bool => nabyva hodnoty 1/0 viz cyklus while
            je_operator = 0  # stejne jako 'pocet_operatory'

            for znak in string:
                """ Pomocne indexovaci hodnoty pro 'lepsi' orientaci """
                index_1 = counter - 1
                index1 = counter + 1
                index2 = counter + 2
                index = counter

                """ Aby se osetril zasah mimo pole jsou indexy od urcite pozice stejne jako 'counter' """
                if (counter == (len(string) - 1)):
                    index1 = counter
                if (counter == (len(string) - 2)):
                    index2 = counter

                """ Na zaklade prochazeni vstupniho retezce po nejblizsi '|' se urci zda je to zacatek a nebo konec absolutni hodnoty """
                while (((string[index] != "|")) and (index != (len(string) - 1))):
                    if (string[index] in cisla):
                        je_cislo = 1
                    elif (string[index] in operatory):
                        je_operator = 1
                    index += 1

                if (znak == '|'):
                    """ Asi to jde zjednodusit ale ted na to nemam :D """
                    pocet_svislitka += 1
                    if (pocet_svislitka > (pocet / 2)):
                        if ((string[index_1]) in operatory):
                            if ((je_operator and je_cislo) or je_operator):
                                abs_vystup += 'abs('
                            else:
                                abs_vystup += ')'
                        else:
                            abs_vystup += ')'
                    else:
                        if (string[index1] in operatory):
                            if (string[index2] in ("|" + cisla + promenne)):
                                if ((je_operator and je_cislo) or (je_operator) or (counter == 0)):
                                    abs_vystup += 'abs('
                                else:
                                    abs_vystup += ')'
                            else:
                                abs_vystup += ')'
                        elif (string[index1] not in (cisla + promenne + "+-|")):
                            return "ERROR"
                        else:
                            abs_vystup += 'abs('
                    je_operator = je_cislo = 0
                elif (znak in operatory):
                    abs_vystup += znak
                elif (znak in promenne):
                    abs_vystup += znak
                elif (znak in cisla):
                    abs_vystup += znak
                    je_operator = 0
                else:
                    return "ERROR"
                counter += 1
            if (abs_vystup.count('(') == abs_vystup.count(')')):
                print(abs_vystup)
            else:
                return "ERROR"