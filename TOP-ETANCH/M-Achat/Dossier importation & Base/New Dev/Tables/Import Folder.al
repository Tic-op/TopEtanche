table 50119 "Import Folder"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Import Folder List";
    LookupPageId = "Import Folder List";
    DataCaptionFields = "no.", "vendor no.", "Purchase Invoice No.";


    fields
    {
        field(1; "No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No. fournisseur';
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                frs: Record Vendor;
            begin
                frs.get("Vendor No.");
                "Vendor Name" := frs.Name;
                frs.TestField("Currency Code");
                Validate("Currency Code", frs."Currency Code");


            end;

        }
        field(3; "Vendor Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'Nom fournisseur';

        }
        field(4; "Vendor Address"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Adresse fournisseur';
        }
        field(5; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date création';
        }
        field(6; "Closed Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'date clôture';
        }
        field(7; "Status"; Option)
        {
            OptionMembers = "Open","Invoiced","Closed";
            OptionCaption = 'Ouvert,Facturé,Clôturé';

        }
        field(8; "Currency Code"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code devise';
            TableRelation = Currency;


            trigger OnValidate()
            var
                recCurrency: Record Currency;
                rectaux: Record "Currency Exchange Rate";
            begin
                if "Currency Code" <> '' then begin

                    recCurrency.get("Currency Code");

                    if rectaux.GetCurrentCurrencyFactor("Currency Code") <> 0 then
                        "Currency Factor" := 1 / rectaux.GetCurrentCurrencyFactor("Currency Code")
                    else
                        "Currency Factor" := 1;


                end;

            end;
        }

        field(9; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Taux de change';
            DecimalPlaces = 3 : 6;
        }
        field(10; "N° déclaration"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Date déclaration"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Date Arr. Marchandise"; code[20])
        {
            DataClassification = ToBeClassified;

        }


        field(13; "Date Liv. Marchandise"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Order Count"; Integer)
        {
            caption = 'Nbre commandes';
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where("Document Type" = const(order), "DI No." = field("No.")));// Import folder No

        }
        field(15; "Invoice Count"; Integer)
        {
            caption = 'Nbre factures';
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where("Document Type" = const(invoice), "DI No." = field("No.")));// Import folder No

        }
        field(16; "Purchase Invoice No."; Code[20])
        {
            caption = 'Facture Achat';



        }
        field(17; "N° Titre Importation"; code[20])
        {

        }
        field(18; "N° Assurance"; code[20])
        {

        }
        field(19; "Provenance"; Integer)
        {

        }
        field(20; "Nombre de colis"; Integer)
        {

        }
        field(21; "Position actuelle"; Option)

        {
            OptionMembers = " ","Cde en cours","Pro-forma","En cours de chargement","Chargement effectué","Facture définitive","Embarquement","Port d'embarquement","En cours de transport","Arrivé au port débarquement","Livré","Constat","Attente Doc originaux","Dédouanement","En cours de livraison","Livraison partielle","Anged";


        }
        field(22; "Prochaine Position"; Option)

        {
            OptionMembers = " ","Cde en cours","Pro-forma","En cours de chargement","Chargement effectué","Facture définitive","Embarquement","Port d'embarquement","En cours de transport","Arrivé au port débarquement","Livré","Constat","Attente Doc originaux","Dédouanement","En cours de livraison","Livraison partielle","Anged";


        }
        field(23; "Réceptions validées"; Integer)

        {
            FieldClass = FlowField;

            CalcFormula = count("Purch. Rcpt. Header" where("DI No." = field("No.")));// Import folder No

        }
        field(24; "Factures achat enregistrées"; Integer)

        {
            FieldClass = FlowField;

            CalcFormula = count("Purch. Inv. Header" where("DI No." = field("No.")));// Import folder No

        }
        field(25; "Avoirs Achat Enregistrées"; Integer)

        {
            FieldClass = FlowField;
            CalcFormula = count("Purch. Cr. Memo Hdr." where("DI No." = field("No.")));// Import folder No

        }
    }

    keys
    {
        key(No; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Vendor Name", "N° déclaration")
        {
        }
        fieldgroup(Brick; "No.", "No.", "Vendor Name", "N° déclaration")
        {
        }
    }


    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        CuSeriesNo: Codeunit "No. Series";
    begin
        PurchSetup.Get();
        "No." := CuSeriesNo.GetNextNo(PurchSetup."Import folder No");
        "Creation Date" := Today();


    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;



}