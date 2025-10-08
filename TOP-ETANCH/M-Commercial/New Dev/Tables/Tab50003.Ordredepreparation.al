table 50003 "Ordre de preparation"
{
    Caption = 'Ordre de preparation';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Code[20])
        {
            Caption = 'No';
        }
        field(3; Statut; Option)
        {
            Caption = 'Statut';
            OptionMembers = "Créé","En cours","Préparé","Regroupé","livré";
            trigger OnValidate()
            var
                SL: Record "Sales Line";
            begin
                SL.SetFilter("Document No.", "Order No");
                SL.SetRange("Location Code", Magasin);
                sl.Modifyall(Statut, Statut);
            end;

        }
        field(4; "Order No"; code[20])
        {
            Editable = false;
            Caption = 'N° document';

            TableRelation = if ("document type" = const(Commande)) "Sales Header" where("Document Type" = const("Sales Document Type"::Order)) else
            if ("document type" = const(Transfert)) "Transfer Header" else
            if ("document type" = const(Facture)) "Sales Header" where("Document Type" = const("Sales Document Type"::Invoice));



        }
        field(5; "Magasin"; Code[10])
        {
            Editable = false;
            Caption = 'Magasin';
            TableRelation = Location;
        }
        field(6; "Creation date"; DateTime)
        {
            Caption = 'Date de création';
        }
        field(7; "Date début préparation"; DateTime)
        {

        }
        field(8; "Date fin préparation"; DateTime)
        {

        }
        field(9; "Préparateur"; Text[50])
        {
            TableRelation = "Logistic resource" where(Magasin = field(Magasin), blocked = const(false));
        }
        field(10; "document type"; Option)
        {
            Caption = 'Type document';
            Editable = false;
            OptionMembers = "Commande","Transfert","Facture";

        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
        key(PK2; "document type", "Order No")
        {

        }

    }
    trigger OnInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        CuSeries: Codeunit "No. Series";
        PrépEvent: codeunit "PréparationEvent";

    begin
        SalesSetup.Get();
        "No" := CuSeries.GetNextNo(SalesSetup."Bon de prepation No");


        //  PrépEvent."InitialiserLignesPréparation"(No); Doesn't work because the Record is not inserted yet into the database So the procedure who use Get() wouldn't find the record 
        //I  used an integration event on the database on afterinsert // AM 


    end;


}
