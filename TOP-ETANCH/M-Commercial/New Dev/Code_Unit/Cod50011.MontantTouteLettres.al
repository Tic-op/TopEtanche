/// <summary>
/// Unknown Pharmatec_Ticop.
/// </summary>
namespace Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.Sales.History;

codeunit 50011 "Montant Toute Lettres"
{



    local procedure "Montant en texte1"(VAR strprix: Text[250]; prix: Decimal)
    var
        entiere: Decimal;
        decimal: Decimal;
        nbre: Decimal;
        million: Text;
        mille: Text;
        cent: Text;
        nbre1: Decimal;
    begin
        entiere := ROUND(prix, 1, '<');
        decimal := ROUND((prix - entiere) * 100, 1, '<');

        nbre := entiere;
        //Chèque.FormatNumTexte(strprix,nbre);

        million := '';
        mille := '';
        cent := '';

        nbre1 := nbre DIV 1000000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(million, nbre1);
            million := million + ' million';
        END;

        nbre := nbre MOD 1000000;
        nbre1 := nbre DIV 1000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(mille, nbre1);
            IF mille <> 'un' THEN
                mille := mille + ' mille'
            ELSE
                mille := 'mille'
        END;

        nbre := nbre MOD 1000;

        IF nbre <> 0 THEN BEGIN
            Centaine(cent, nbre);
        END;

        IF million <> '' THEN
            strprix := million;
        IF ((mille <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + mille
        ELSE
            strprix := strprix + mille;
        IF ((cent <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + cent
        ELSE
            strprix := strprix + cent;

        IF entiere > 1 THEN
            strprix := strprix + ' Dinars Algérien';
        IF entiere = 1 THEN
            strprix := strprix + ' Dinar Algérien';

        cent := '';
        IF decimal <> 0 THEN BEGIN
            Centaine(cent, decimal);
            IF strprix <> '' THEN
                strprix := strprix + ' ' + cent
            ELSE
                strprix := strprix + cent;
            IF decimal = 1 THEN
                strprix := strprix + ' centime'
            ELSE
                strprix := strprix + ' centimes';
        END;

        strprix := UPPERCASE(strprix);
    end;

    local procedure MontantTexteDev(VAR strprix: Text[250]; prix: Decimal; Devise: Text[30])
    var
        entiere: Decimal;
        decimal: Decimal;
        nbre: Decimal;
        million: Text;
        mille: Text;
        cent: Text;
        nbre1: Decimal;
        VarDeviseEntiere: Text;
        VarDeviseDecimal: Text;
    begin
        // Chercher le Dinar et Millimes de la devise
        QuelleDevise(Devise);
        //

        entiere := ROUND(prix, 1, '<');
        decimal := ROUND((prix - entiere) * 100, 1, '<');

        nbre := entiere;
        //Chèque.FormatNumTexte(strprix,nbre);

        million := '';
        mille := '';
        cent := '';

        nbre1 := nbre DIV 1000000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(million, nbre1);
            million := million + ' million';
        END;

        nbre := nbre MOD 1000000;
        nbre1 := nbre DIV 1000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(mille, nbre1);
            IF mille <> 'un' THEN
                mille := mille + ' mille'
            ELSE
                mille := 'mille'
        END;

        nbre := nbre MOD 1000;

        IF nbre <> 0 THEN BEGIN
            Centaine(cent, nbre);
        END;

        IF million <> '' THEN
            strprix := million;
        IF ((mille <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + mille
        ELSE
            strprix := strprix + mille;
        IF ((cent <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + cent
        ELSE
            strprix := strprix + cent;

        IF entiere > 1 THEN
            strprix := strprix + ' ' + VarDeviseEntiere;
        IF entiere = 1 THEN
            strprix := strprix + ' ' + VarDeviseEntiere;

        cent := '';
        IF decimal <> 0 THEN BEGIN
            Centaine(cent, decimal);
            IF strprix <> '' THEN
                strprix := strprix + ' ' + cent
            ELSE
                strprix := strprix + cent;
            IF decimal = 1 THEN
                strprix := strprix + ' ' + VarDeviseDecimal
            ELSE
                strprix := strprix + ' ' + VarDeviseDecimal;



        END;

        strprix := UPPERCASE(strprix);
    end;

    local procedure MontantTexteDevise(VAR strprix: Text[250]; prix: Decimal; Devise: Text[30])
    var
        entiere: Decimal;
        decimal: Decimal;
        nbre: Decimal;
        million: Text;
        mille: Text;
        cent: Text;
        nbre1: Decimal;
        VarDeviseEntiere: Text;
        VarDeviseDecimal: Text;
    begin

        // Chercher le Dinar et Millimes de la devise
        QuelleDevise(Devise);
        //

        entiere := ROUND(prix, 1, '<');
        decimal := ROUND((prix - entiere) * 100, 1, '<');

        nbre := entiere;
        //Chèque.FormatNumTexte(strprix,nbre);

        million := '';
        mille := '';
        cent := '';

        nbre1 := nbre DIV 1000000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(million, nbre1);
            million := million + ' million';
        END;

        nbre := nbre MOD 1000000;
        nbre1 := nbre DIV 1000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(mille, nbre1);
            IF mille <> 'un' THEN
                mille := mille + ' mille'
            ELSE
                mille := 'mille'
        END;

        nbre := nbre MOD 1000;

        IF nbre <> 0 THEN BEGIN
            Centaine(cent, nbre);
        END;

        IF million <> '' THEN
            strprix := million;
        IF ((mille <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + mille
        ELSE
            strprix := strprix + mille;
        IF ((cent <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + cent
        ELSE
            strprix := strprix + cent;

        IF entiere > 1 THEN
            strprix := strprix + ' ' + VarDeviseEntiere;
        IF entiere = 1 THEN
            strprix := strprix + ' ' + VarDeviseEntiere;

        cent := '';
        IF decimal <> 0 THEN BEGIN
            Centaine(cent, decimal);
            IF strprix <> '' THEN
                strprix := strprix + ' ' + cent
            ELSE
                strprix := strprix + cent;
            IF decimal = 1 THEN
                strprix := strprix + ' ' + VarDeviseDecimal
            ELSE
                strprix := strprix + ' ' + VarDeviseDecimal;



        END;

        strprix := UPPERCASE(strprix);
    end;

    local procedure QuelleDevise(VAR StrDevise: Text[30])
    var
        VarDeviseEntiere: Text;
        VarDeviseDecimal: Text;

    begin
        //
        IF StrDevise = 'USD' THEN BEGIN
            VarDeviseEntiere := 'Dollars';
            VarDeviseDecimal := 'Cents';
        END;

        IF StrDevise = 'EURO' THEN BEGIN
            VarDeviseEntiere := 'Euro';
            VarDeviseDecimal := 'Centimes';
        END;

        IF StrDevise = 'EUR' THEN BEGIN
            VarDeviseEntiere := 'Euro';
            VarDeviseDecimal := 'Centimes';
        END;


        IF StrDevise = '£' THEN BEGIN
            VarDeviseEntiere := 'Livres Sterling';
            VarDeviseDecimal := 'Cens';
        END;
    end;

    local procedure "Montant en texte sans millimes"(VAR strprix: Text[250]; prix: Decimal)
    var
        entiere: Decimal;
        decimal: Decimal;
        nbre: Decimal;
        million: Text;
        mille: Text;
        cent: Text;
        nbre1: Decimal;
    begin
        entiere := ROUND(prix, 1, '<');
        decimal := ROUND((prix - entiere) * 1000, 1, '<');

        nbre := entiere;
        //Chèque.FormatNumTexte(strprix,nbre);

        million := '';
        mille := '';
        cent := '';

        nbre1 := nbre DIV 1000000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(million, nbre1);
            million := million + ' million';
        END;

        nbre := nbre MOD 1000000;
        nbre1 := nbre DIV 1000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(mille, nbre1);
            IF mille <> 'un' THEN
                mille := mille + ' mille'
            ELSE
                mille := 'mille'
        END;

        nbre := nbre MOD 1000;

        IF nbre <> 0 THEN BEGIN
            Centaine(cent, nbre);
        END;

        IF million <> '' THEN
            strprix := million;
        IF ((mille <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + mille
        ELSE
            strprix := strprix + mille;
        IF ((cent <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + cent
        ELSE
            strprix := strprix + cent;

        IF entiere > 1 THEN
            strprix := strprix + ' dinars';
        IF entiere = 1 THEN
            strprix := strprix + ' dinar';

        IF decimal <> 0 THEN BEGIN
            IF strprix <> '' THEN
                strprix := strprix + ' ' + FORMAT(decimal)
            ELSE
                strprix := strprix + FORMAT(decimal);
            IF decimal = 1 THEN
                strprix := strprix + ' millime'
            ELSE
                strprix := strprix + ' millimes';
        END;

        strprix := UPPERCASE(strprix);
    end;

    procedure "Montant en texte"(VAR strprix: Text[250]; prix: Decimal)
    var
        entiere: Decimal;
        decimal: Decimal;
        nbre: Decimal;
        million: Text;
        mille: text;
        cent: text;
        nbre1: Integer;

    begin
        entiere := ROUND(prix, 1, '<');
        decimal := ROUND((prix - entiere) * 1000, 1, '=');

        nbre := entiere;
        //Chèque.FormatNumTexte(strprix,nbre);

        million := '';
        mille := '';
        cent := '';

        nbre1 := nbre DIV 1000000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(million, nbre1);
            million := million + ' million';
        END;

        nbre := nbre MOD 1000000;
        nbre1 := nbre DIV 1000;
        IF nbre1 <> 0 THEN BEGIN
            Centaine(mille, nbre1);
            IF mille <> 'un' THEN
                mille := mille + ' mille'
            ELSE
                mille := 'mille'
        END;

        nbre := nbre MOD 1000;

        IF nbre <> 0 THEN BEGIN
            Centaine(cent, nbre);
        END;

        IF million <> '' THEN
            strprix := million;
        IF ((mille <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + mille
        ELSE
            strprix := strprix + mille;
        IF ((cent <> '') AND (strprix <> '')) THEN
            strprix := strprix + ' ' + cent
        ELSE
            strprix := strprix + cent;

        IF entiere > 1 THEN
            strprix := strprix + ' dinars';
        IF entiere = 1 THEN
            strprix := strprix + ' dinar';

        cent := '';
        IF decimal <> 0 THEN BEGIN
            Centaine(cent, decimal);
            IF strprix <> '' THEN
                strprix := strprix + ' ' + cent
            ELSE
                strprix := strprix + cent;
            IF decimal = 1 THEN
                strprix := strprix + ' millime'
            ELSE
                strprix := strprix + ' millimes';
        END;

        strprix := UPPERCASE(strprix);
    end;


    local procedure Centaine(VAR chaine: Text[250]; i: Integer)
    var
        k: Integer;

    begin
        ;
        k := i DIV 100;
        chaine := '';
        CASE k OF
            1:
                chaine := 'cent';
            2:
                chaine := 'deux cent';
            3:
                chaine := 'trois cent';
            4:
                chaine := 'quatre cent';
            5:
                chaine := 'cinq cent';
            6:
                chaine := 'six cent';
            7:
                chaine := 'sept cent';
            8:
                chaine := 'huit cent';
            9:
                chaine := 'neuf cent';
        END;
        k := i MOD 100;
        Dizaine(chaine, k);


    end;


    local procedure Dizaine(VAR chaine: Text[250]; i: Integer)
    var
        chaine1: Text;
        k: Integer;
        l: Integer;
    begin
        IF i > 16 THEN BEGIN
            k := i DIV 10;
            chaine1 := '';
            CASE k OF
                1:
                    chaine1 := 'dix';
                2:
                    chaine1 := 'vingt';
                3:
                    chaine1 := 'trente';
                4:
                    chaine1 := 'quarante';
                5:
                    chaine1 := 'cinquante';
                6:
                    chaine1 := 'soixante';
                7:
                    chaine1 := 'soixante';
                8:
                    chaine1 := 'quatre vingt';
                9:
                    chaine1 := 'quatre vingt';
            END;
            IF ((chaine1 <> '') AND (chaine <> '')) THEN
                chaine1 := ' ' + chaine1;
            chaine := chaine + chaine1;
            l := k;
            IF ((k = 7) OR (k = 9)) THEN
                k := (i MOD 10) + 10
            ELSE
                k := (i MOD 10);
        END
        ELSE
            k := i;

        IF ((l <> 8) AND (l <> 0) AND ((k = 1) OR (k = 11))) THEN
            chaine := chaine + ' et';
        IF (((k = 0) OR (k > 16)) AND ((l = 7) OR (l = 9))) THEN BEGIN
            chaine := chaine + ' dix';
            IF k > 16 THEN
                k := k - 10;
        END;

        Unité(chaine, k);

    end;

    local procedure Unité(VAR chaine: Text[250]; i: Integer)
    var
        chaine1: Text;
    begin
        chaine1 := '';
        CASE i OF
            1:
                chaine1 := 'un';
            2:
                chaine1 := 'deux';
            3:
                chaine1 := 'trois';
            4:
                chaine1 := 'quatre';
            5:
                chaine1 := 'cinq';
            6:
                chaine1 := 'six';
            7:
                chaine1 := 'sept';
            8:
                chaine1 := 'huit';
            9:
                chaine1 := 'neuf';
            10:
                chaine1 := 'dix';
            11:
                chaine1 := 'onze';
            12:
                chaine1 := 'douze';
            13:
                chaine1 := 'treize';
            14:
                chaine1 := 'quatorze';
            15:
                chaine1 := 'quinze';
            16:
                chaine1 := 'seize';
        END;
        IF ((chaine1 <> '') AND (chaine <> '')) THEN
            chaine1 := ' ' + chaine1;
        chaine := chaine + chaine1;

    end;




}