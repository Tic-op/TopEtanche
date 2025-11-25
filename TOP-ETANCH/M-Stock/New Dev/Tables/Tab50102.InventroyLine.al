table 50102 "Inventroy Line"
{
    Caption = 'Inventroy Line';
    DataClassification = ToBeClassified;

    fields
    {


        field(50000; "line No"; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;

        }
        field(50001; "Inventory No."; Code[20])
        {
            Caption = 'N° inventaire';
            // TableRelation = "Inventory Entry";
        }
        field(50002; "Item No."; Code[20])
        {
            Caption = 'N° article';
            TableRelation = Item;
        }
        field(50003; "Item Description"; Text[300])
        {
            Caption = 'Désignation';
            TableRelation = Item;
        }
        field(50004; "Location Code"; Code[20])
        {
            Caption = 'Code magasin';
            TableRelation = Location;
        }
        field(50005; Enseigne; Code[20])
        {
            Caption = 'Enseigne';
        }
        field(50006; "Shelf No."; Code[250])
        {
            Caption = 'N° emplacement';
        }
        field(50007; Inventory; Decimal)
        {
            Caption = 'Stock';
        }
        field(50008; "count 1 (QTY)"; Decimal)
        {
            Caption = 'count 1 (QTY)';
            FieldClass = FlowField;
            CalcFormula = Sum("Inventory Entry".Quantity WHERE("Count No." = CONST(1), "Inventory No." = FIELD("Inventory No."), "Item No." = FIELD("Item No.")));
            TableRelation = "Inventory Entry";
            Editable = false;
        }
        field(50009; "count 2 (QTY)"; Decimal)
        {
            Caption = 'count 2 (QTY)';
            Editable = false;
        }
        field(50010; "count 3 (QTY)"; Decimal)
        {
            Caption = 'count 3 (QTY)';
            Editable = false;

        }
        field(50011; "count 4 (QTY)"; Decimal)
        {
            Caption = 'count 4 (QTY)';
            Editable = false;
        }
        field(50012; "count 5 (QTY)"; Decimal)
        {
            Caption = 'count 5 (QTY)';
            Editable = false;
        }
        field(50013; "Ecart 1"; Decimal)
        {
            Caption = 'Ecart 1';
            Editable = false;

        }
        field(50014; "Ecart 2"; Decimal)
        {
            Caption = 'Ecart 2';
            Editable = false;

        }
        field(50015; "Ecart 3"; Decimal)
        {
            Caption = 'Ecart 3';
            Editable = false;

        }
        field(50016; "Ecart 4"; Decimal)
        {
            Caption = 'Ecart 4';
            Editable = false;

        }
        field(50017; "Ecart 5"; Decimal)
        {
            Caption = 'Ecart 5';
            Editable = false;

        }
        /* field(50018; Status; Option)
        {
            Caption = 'Status';
        } */
        field(50019; "Qty to validate"; Decimal)
        {
            Caption = 'Qty to validate';
        }
        field(50020; "Date creation"; Date)
        {
            Caption = 'Date creation';
        }
        field(50021; "Count Num"; Integer)
        {
            Caption = 'N° Comptage actuel';
            Editable = false;

        }
        field(50022; "Posting Date"; Date)
        {
            Caption = 'Date clôture';
        }
        field(50023; "Valeur art. à inventorier"; Decimal)
        {
            Caption = 'Valeur art. à inventorier';
        }
        field(50024; "Valeur art. inventoriés"; Decimal)
        {
            Caption = 'Valeur art. inventoriés';
        }
        field(50025; "Qté proposée"; Decimal)
        {
            Caption = 'Qté proposée';
        }
        field(50026; "Bin code"; text[20])
        {
            Caption = 'Code emplacement';
        }
        field(50027; "N° lot"; code[25])
        {
            Caption = 'N° lot';
        }
          field(50028; Unité; Code[10])
        {
           
        }

    }
    keys
    {
        key(PK; "line No", "Inventory No.")
        {
            Clustered = true;
        }
        key(lot_key; "N° lot", "Bin code")
        {


        }
    }


}