namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.History;
using Microsoft.Warehouse.ADCS;
using Microsoft.Purchases.Document;

tableextension 50026 "Purch. Rcpt. Line Ext." extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50009; "DOP No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° DOP';
            TableRelation = "Purchase Header"."no." WHERE("Document Type" = CONST(Quote), "Buy-from Vendor No." = field("Buy-from Vendor No."));
            Editable = false;
        }

        field(50010; "DOP Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ligne DOP';
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = CONST(Quote), "Buy-from Vendor No." = field("Buy-from Vendor No.")
            , "Document No." = field("DOP No."));
            Editable = false;
        }

        field(50020; "Vendor Shipment No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'BL fourn.';

        }
        field(50021; Order; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Commande';

        }
    }
    keys
    {
        key(DOP; "DOP No.", "DOP Line No.") { }
        key(ItemCategoryKey; "Item Category Code") { }

    }


}

