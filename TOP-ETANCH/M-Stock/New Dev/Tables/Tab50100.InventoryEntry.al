table 50100 "Inventory Entry"
{
    Caption = 'Inventory Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(50001; "Entry No."; Integer)
        {
            Caption = 'N° séquence';
            AutoIncrement = true;
        }
        field(50002; "Inventory No."; Code[20])
        {
            Caption = 'N° inventaire';
            TableRelation = "Inventory header";

            trigger OnValidate()
            var
                InventoryHeaderRec: Record "Inventory header";
            begin
                if InventoryHeaderRec.Get("Inventory No.") then begin
                    "Count No." := InventoryHeaderRec."Count No.";

                end;
            end;
        }
        field(50003; "Count No."; Integer)
        {
            Caption = 'N° comptage';

            Editable = false;
        }
        field(50004; "Item No."; Code[20])
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
        field(50005; "Item Bar Code"; code[50])
        {
            Caption = 'CAB article';
            TableRelation = "Item Identifier TICOP";
        }
        field(50006; "Quantity"; Decimal)
        {
            Caption = 'Quantité';
            DecimalPlaces = 0 : 3;
        }
        field(50007; "Scan Date"; DateTime)
        {
            Caption = 'Date lecture';
        }
        field(50008; "Vrac Quantity"; decimal)
        {
            Caption = 'Quantité Vrac';
            DecimalPlaces = 0 : 3;
        }
        field(50009; "Terminal ID"; Text[50])
        {
            //Caption = ''
        }
        field(50010; Description; Text[300])
        { }



    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        item: Record item;
    begin

    end;


}
