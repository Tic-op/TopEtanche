table 50003 "Ordre de preparation"
{
    Caption = 'Ordre de preparation';
    DataClassification = ToBeClassified;
    DrillDownPageID = "Liste bon de préparation";
    LookupPageID = "Liste bon de préparation";

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
                //  SL: Record "Sales Line";
                PrepLine: record "Ligne préparation";
            begin
                /*  if (Statut = Statut::"Créé") and (xRec.Statut <> Statut::"Créé") then
                     error('impossible de passer à statut "Crée" depuis un statut postérieur'); */


                If (Statut = Statut::"En cours") and (xrec.Statut = Statut::"Créé") then begin
                    "Date début préparation" := CurrentDateTime;

                end;
                If (Statut = Statut::"Préparé") then begin
                    "Date fin préparation" := CurrentDateTime;

                end;





                PrepLine.setrange("Document No.", No);
                if PrepLine.findset() then
                    PrepLine.ModifyAll(Statut, Statut);

                /*  SL.SetFilter("Document No.", "Order No");
                 SL.SetRange("Location Code", Magasin);
                 sl.Modifyall(Statut, Statut); */
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
        field(11; Printed; integer)
        {
            initvalue = 0;

        }
        Field(12; Demandeur; Text[50]) { }
        field(13; "Nom demandeur"; text[100])
        {

        }
        field(14; "Num document validé"; Code[20])
        {
            TableRelation = if ("document type" = const(commande)) "Sales Shipment Header" where("No." = field("Num document validé"))
            else if ("document type" = const(facture)) "Sales Invoice Header" where("No." = field("Num document validé"))
            else if ("document type" = const(Transfert)) "Transfer Shipment Header" where("No." = field("Num document validé"));
        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
        key(Sourcekey; "document type", "Order No")
        {

        }

        key(StatusKey; Statut) { }
        key(Datekey; "Creation date", "Date début préparation", "Date fin préparation") { }
        key(Locationkey; Magasin, "Préparateur") { }

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

    Trigger OnDelete()
    var
        Lignepréparation: Record "Ligne préparation";
    begin

        if (Statut <> Statut::"Créé") and (Statut <> Statut::"En cours")
        then
            error('Impossible de supprimer un bon de préparation de statut %1 ', Statut);
        //"Lignepréparation".SetRange("Source type.", "document type");
        "Lignepréparation".SetRange("Document No.", No);
        if "Lignepréparation".findset then
            "Lignepréparation".DeleteAll(true);
    end;

    Procedure Countligne(): Boolean
    var
        Preplines: record "Ligne préparation";
    begin
        Preplines.setrange("Document No.", No);
        exit(Preplines.count < 2);
    end;


}
