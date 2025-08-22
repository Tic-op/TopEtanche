namespace TOPETANCH.TOPETANCH;

using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.Structure;

tableextension 50022 "Reservation Entry" extends "Reservation Entry"
{
    fields
    {
        field(50000; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            // DataClassification = ToBeClassified;
            TableRelation = Bin where(code = field("Bin Code"));
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Bin Code" where("Document type" = filter(order), "Document No." = field("Source ID"), "Line No." = field("Source Ref. No.")));
        }
    }
}