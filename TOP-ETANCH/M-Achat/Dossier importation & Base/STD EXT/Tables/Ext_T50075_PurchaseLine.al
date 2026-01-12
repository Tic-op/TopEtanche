tableextension 50075 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        field(50101; "Tariff No."; Code[20])
        {
            Caption = 'Nomencalture Produit';
            DataClassification = ToBeClassified;
            TableRelation = "Tariff Number";
        }
        field(50102; "Droit douane"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50103; TVA; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Country region origin code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No Origine';
            TableRelation = "Country/Region";
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                itm: Record item;
                ItemCharge: Record "Item Charge";
            begin
                if rec.Type = Rec.type::Item then begin
                    itm.get(rec."No.");
                    Rec.validate("Tariff No.", itm."Tariff No.");
                    Rec.Validate("Country region origin code", itm."Country/Region of Origin Code");
                end;
                if rec.Type = rec.type::"Charge (Item)" then begin
                    ItemCharge.get(rec."No.");
                    "Droit douane" := ItemCharge."Droit Douane";
                    TVA := ItemCharge.TVA;


                end;
            end;

        }
    }
    trigger OnInsert()
    var
        CompInfo: record "Company Information";
    begin
        CompInfo.get();
        "Location Code" := CompInfo."Location Code";

    end;

    procedure GetLastLineNo(): integer
    var
        PurchL: record "Purchase Line";


    begin
        PurchL.setrange("Document Type", "Document Type");
        PurchL.setrange("Document No.", "Document No.");
        if PurchL.FindLast() then
            exit(PurchL."Line No.")
        else
            exit(0);


    end;

}