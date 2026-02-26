namespace TopAPI.TopAPI;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;

page 50036 InsertReceptionLine
{
    APIGroup = 'InsertRece';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'insertPurchLine';
    DelayedInsert = true;
    EntityName = 'insertPurchLine';
    EntitySetName = 'insertPurchLines';
    PageType = API;
    ModifyAllowed = true;
    InsertAllowed = true;
    SourceTable = "Purchase Line";
    ODataKeyFields = SystemId;


    SourceTableView = where("Document Type" = filter(Order));
    Permissions = tabledata "Purchase Line" = RIMD;


    layout
    {
        area(Content)
        {

            repeater(General)
            {

                field(SystemId; Rec.SystemId) { }
                field("Document_No"; Rec."Document No.") { }
                field("No"; Rec."No.") { }
                field(Description; Rec.Description) { }
                field(Quantity; qty) { }
            }



        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.Type := rec.Type::Item;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        LastLineNo: Integer;
    begin
        if not PurchHeader.Get(PurchHeader."Document Type"::Order, Rec."Document No.") then
            Error('commande inexistante');

        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindLast() then
            LastLineNo := PurchLine."Line No." + 10000
        else
            LastLineNo := 10000;

        Rec."Document Type" := PurchHeader."Document Type";
        Rec."Document No." := PurchHeader."No.";
        Rec."Line No." := LastLineNo;
        Rec.Type := Rec.Type::Item;

        Rec.Validate("No.", Rec."No.");
        rec.Validate(Quantity, qty);



        exit(true);
    end;

    var
        qty: decimal;
}