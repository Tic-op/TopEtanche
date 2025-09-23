table 50012 "Offre de prix "
{
    Caption = 'Offre de prix ';
    DataClassification = ToBeClassified;
    LookupPageId = 50039;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vendor: record vendor;
            begin
                Vendor.get("Vendor No.");
                "Vendor Name" := vendor.Name;

            end;
        }
        field(2; "Vendor Name"; text[100])
        {

            caption = 'Vendor Name';
            TableRelation = vendor.Name where("No." = field("Vendor No."));
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = item;
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                itemrec: Record item;
            begin
                itemrec.get("Item No.");
                "item description" := itemrec.Description;
            end;
        }
        field(4; "item description"; text[100])
        {
            Caption = 'item description';

        }
        field(5; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(6; Price; decimal)
        {
            Caption = 'Price';
            DecimalPlaces = 0 : 3;
        }
    }
    keys
    {
        key(PK; "Vendor No.", "Item No.", "date")
        {
            Clustered = true;
        }
        key("Date"; "Item No.", "Date", Price)
        { }

    }
}
