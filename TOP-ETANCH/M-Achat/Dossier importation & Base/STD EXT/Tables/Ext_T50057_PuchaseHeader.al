tableextension 50057 PurchaseHeaderExt extends "Purchase Header"
{
    fields
    {

        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Vend: Record vendor;

            begin
                Vend.get("Buy-from Vendor No.");
                Stamp := Vend.Stamp;
            end;
        }
        field(50001; "DI No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No DI';
            TableRelation = if ("Document Type" = Const(order)) "Import Folder" where("Vendor No." = field("Buy-from Vendor No."), Status = const(Open)) else
            "import folder" where(Status = const(open));
        }
        field(50002; Stamp; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Timbre achat';

        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}



