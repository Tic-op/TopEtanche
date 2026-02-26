table 50199 "Item Search Buffer"
{
    DataClassification = CustomerContent;
    Caption = 'Item Attribute Search Index';

    fields
    {
        field(1; "Item No."; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Category Code"; Code[20]) { DataClassification = CustomerContent; }
        field(3; "Attribute Code"; Code[20]) { DataClassification = CustomerContent; }
        field(4; "Value Code"; Code[50]) { DataClassification = CustomerContent; }
        field(5; "Value Decimal"; Decimal) { DataClassification = CustomerContent; }

        field(6; "Value Text"; Text[50]) { DataClassification = CustomerContent; }


    }

    keys
    {
        key(PK; "Item No.", "Attribute Code") { Clustered = true; }
        key(SearchKey1; "Category Code", "Attribute Code", "Value Code") { }
        key(SearchKey2; "Category Code", "Attribute Code", "Value Decimal") { }
    }
}