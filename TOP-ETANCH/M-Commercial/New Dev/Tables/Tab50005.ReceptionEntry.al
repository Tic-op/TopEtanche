table 50005 "Reception Entry"
{
    Caption = 'Reception Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Purchase Order No."; Code[20])
        {
            Caption = 'N° commande achat';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(3; "Vendor No."; Code[100])
        {
            Caption = 'N° fournisseur';
            TableRelation = Vendor;
            //Editable = false;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'N° article';
            TableRelation = Item;

            trigger OnValidate()
            var
                ItemRec: Record Item;
            begin
                if ItemRec.Get("Item No.") then begin
                    Description := ItemRec.Description;
                end;
            end;
        }
        field(5; "Quantity"; Decimal)
        {
            Caption = 'Quantité';
            DecimalPlaces = 0 : 3;
        }
        field(6; "Scan Date"; DateTime)
        {
            Caption = 'Date lecture';
        }
        field(7; "Terminal ID"; Text[50])
        {
            Caption = 'ID Terminal';
        }
        field(8; Description; Text[300])
        {
            Caption = 'Description';
        }
        field(9; "Item Bar Code"; code[50])
        {
            Caption = 'CAB article';
            TableRelation = "Item Identifier TICOP";
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;
}
