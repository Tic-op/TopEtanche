table 50011 "Importation offre prix"
{
    Caption = 'Importation offre prix';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(2; "item No."; Code[20])
        {
            Caption = 'item No.';
            TableRelation = Item."No." where ("Vendor No." = field("Vendor No."));
            ValidateTableRelation = false;
            trigger OnValidate() var item : record item ;
            begin 
                 item.get("item No.");
                 "Désignation":= item.Description ;

            end;
        }
        field(3; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(4; Désignation; Text[100])
        {

        }
        field(5; IsItem; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist(Item where("No." = field("item No.")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Vendor No.", "item No.")
        {
            Clustered = true;
        }
    }
}
