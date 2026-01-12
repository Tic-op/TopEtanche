table 50111 "Indicateur TICOP"
{
    Caption = 'Indicateur TICOP';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[25])
        {
            Caption = 'Code';
        }
        field(2; "Ventes du mois"; Decimal)
        {
            Caption = 'Vente M';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = sum("Item Ledger Entry"."Sales Operation Amount" where("Entry Type" = filter(Sale), "Posting Date" = field("Filtre date Mois")));
        }
        field(3; "Marge du mois"; Decimal)
        {
            Caption = 'Marge M';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Item Ledger Entry"."Profit Amount" where("Entry Type" = filter(Sale), "Posting Date" = field("Filtre date Mois")));
        }
        field(4; "Commande en cours"; Decimal)
        {
            Caption = 'Commande en cours';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Amount (LCY)" where("Document Type" = const(Order)));

        }
        field(5; "Solde clients"; Decimal)
        {
            Caption = 'Solde clients';
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Posting Group" = filter(<> 'IMPAYÉ')));
            Editable = false;
            FieldClass = FlowField;

        }
        field(6; "Solde fournisseurs Etranger"; Decimal)
        {
            Caption = 'Solde fournisseurs Etrangers';
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Currency Code" = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;

        }
        field(7; "Engagement financier"; Decimal)
        {
            Caption = 'Engagement financier';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Payment Line"."Amount (LCY)" where("copied to no." = filter(''), "Engagement financier" = filter(1 | 2 | 3)));

        }

        field(8; "Ventes"; Decimal)
        {
            Caption = 'Vente';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = sum("Item Ledger Entry"."Sales Operation Amount" where("Entry Type" = filter(Sale), "Posting Date" = field("Filtre date jour")));
        }
        field(9; "Marge"; Decimal)
        {
            Caption = 'Marge';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Item Ledger Entry"."Profit Amount" where("Entry Type" = filter(Sale), "Posting Date" = field("Filtre date jour")));
        }

        /*   field(10; "Préparation en cours"; Decimal)
          {
              Caption = 'Préparation en cours';

              Editable = false;
              FieldClass = FlowField;
              CalcFormula = SUM("Ligne préparation"."Montant Ligne HT" where(Statut = filter("En Attente" .. "Préparé")));

          }
   */
        field(11; "Valeur Stock"; Decimal)
        {
            Caption = 'Stock';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = sum("Item Ledger Entry"."Operation Cost");
        }
        /*  field(12; "Engagement Etranger"; Decimal)
         {
             Caption = 'Engagement bancaire';
             Editable = false;
             FieldClass = FlowField;
             CalcFormula = sum("Payment Line"."Amount (LCY)" where("copied to no." = filter(''), "Engagement financier" = filter(7 | 8 | 9 | 10 | 11 | 12 | 14 | 15 | 16 | 17)));

         } */
        field(13; "Portefeuille"; Decimal)
        {
            Caption = 'Portefeuille';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = - sum("Payment Line"."Amount (LCY)" where("copied to no." = filter(''), Risque = filter(CPF | EPF)));

        }
        field(14; "Solde fournisseurs Locaux"; Decimal)
        {
            Caption = 'Solde fournisseurs Locaux';
            CalcFormula = - sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Currency Code" = filter(= '')));
            Editable = false;
            FieldClass = FlowField;

        }
        field(15; "Impayé"; Decimal)
        {
            Caption = 'Impayé';
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Posting Group" = filter('IMP')));
            Editable = false;
            FieldClass = FlowField;

        }
        field(16; "Caisse en cours"; Decimal)
        {
            Caption = 'Caisse en cours';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = - sum("Payment Line"."Amount (LCY)" where("copied to no." = filter(''), "Status No." = Const(0)));

        }


        field(100; "Filtre date jour"; Date)
        {
            Caption = 'Filtre date jour';
            FieldClass = FlowFilter;
        }
        field(101; "Filtre date Mois"; Date)
        {
            Caption = 'Filtre date Mois';
            FieldClass = FlowFilter;
        }
    }



    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    procedure Escompte(): Decimal


    begin
        PL.SetCurrentKey("Copied To No.", "Copied To Line");
        PL.SetRange("Copied To No.", '');
        //  PL.SetCurrentKey("Banque Entête", "Rapproché");
        PL.SetFilter("Banque Entête", '<>%1', '');
        PL.SetCurrentKey("Due date");
        PL.SetRange("Due Date", today - 3, 20500101D);
        PL.SetFilter(Risque, '%1|%2', PL.Risque::EEN, PL.Risque::BQ);
        PL.CalcSums(Amount);

        exit(-PL.Amount)


    end;

    procedure ShowEscompte()
    begin
        if not PL.IsEmpty then
            Page.RunModal(50076, PL);
    end;

    var
        PL: Record "Payment Line";
}
