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
        modify("Vendor Shipment No.")
        {
            trigger OnAfterValidate()
            var
                PL: Record "Purchase Line";
                CU: Codeunit PurchaseEvents;
            begin
                /*   PL.setrange("Document Type", "Document Type");
                  PL.setrange("Document No.", "No.");
                  PL.ModifyAll("Vendor Shipment No.", "Vendor Shipment No."); */

                if "Vendor Shipment No." <> '' then
                    CU.UpdateShipmtNoReception(rec."No.", "Vendor Shipment No.");

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



