tableextension 50055 "ItemLedgerEntryExtension" extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "Profit %"; decimal)
        {
            Caption = 'Marge sur vente %';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "Nom Origine"; Text[100])
        {
            Caption = 'Nom Origine';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50002; "Purchase Profit %"; decimal)
        {
            Caption = 'Marge sur Achat %';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Operation Cost"; decimal)
        {
            Caption = 'Coût de l''opération';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Sales Operation Amount"; decimal)
        {
            Caption = 'Chiffre d''affaire';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50005; "Profit Amount"; decimal)
        {
            Caption = 'Valeur Marge';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50100; "Contact Number"; Code[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'vis à vis emprunt';
        }

        field(50101; "Type de transfert"; option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "",Transfert,Entrée,Sortie,"Sortie Définitive";
            OptionCaption = ''',Transfert,Entrée,Sortie,Sortie Définitive';

        }
        field(50102; "Motif de transfert"; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(60001; Famille; Code[20])
        {
            Caption = 'Famille';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category"."Code" where("Parent Category" = const(''));
            Editable = false;


        }
        field(60002; "Sous-famille 1"; Code[20])
        {
            Caption = 'Sous-famille 1';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category"."Code" where("Parent Category" = field(Famille));
            Editable = false;

        }
        field(60003; "Sous-famille 2"; Code[20])
        {
            Caption = 'Sous-famille 2';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category"."Code" where("Parent Category" = field("Sous-famille 1"));
            Editable = false;

        }
        field(60004; "Designation"; Text[100])
        {
            Caption = 'Désignation';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description where("No." = field("Item No.")));

        }
        field(60005; "code vendeur"; code[20])
        {
            Caption = 'Code vendeur';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."Salesperson Code" where("No." = field("Document No.")));
        }
        field(60006; "Groupe Compta Client"; code[20])
        {
            Caption = 'Groupe Compta Client';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Customer Posting Group"; //OD090725
        }

        field(60007; "Date Facturation"; date)
        {
            Caption = 'Date Facturation';
            FieldClass = FlowField;
            CalcFormula = lookup("Value Entry"."Posting Date" where("Item Ledger Entry No." = field("Entry No."), "Invoiced Quantity" = field(Quantity)));
            Editable = false;
            //"Sales Shipment Header"."Salesperson Code" where("No." = field("Document No.")));
        }
        field(60008; "reference fournisseur"; Text[50])
        {
            FieldClass = FlowField;
            Calcformula = lookup(item."Vendor Item No." where("No." = field("Item No.")));
            editable = false;
        }



    }
    keys
    {
        key("Expiration Key"; "Expiration Date", "Item No.")
        {

        }
        key(Destroy; "Type de transfert")
        {

        }
        key(key22; Open, Positive)
        {

        }
        key(Famille; Famille, "Sous-famille 1", "Sous-famille 2")
        {

        }
    }


}
