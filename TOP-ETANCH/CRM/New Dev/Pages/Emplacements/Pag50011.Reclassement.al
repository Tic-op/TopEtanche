namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Item;

page 50011 Reclassement
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'reclassement';
    DelayedInsert = true;
    EntityName = 'IJL';
    EntitySetName = 'IJLS';
    PageType = API;
    SourceTable = "Item Journal Line";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field("JournalTemplateName"; Rec."Journal Template Name")
                {
                }
                field("LineNo"; Rec."Line No.")
                {
                }
                field("EntryType"; Rec."Entry Type")
                {
                }
                field("JournalBatchName"; Rec."Journal Batch Name")
                { }
                field(documentDate; Rec."Document Date")
                {
                    Caption = 'Document Date';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        if Item.Get(Rec."Item No.") then
                            Rec.Description := Item.Description;
                    end;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field("NewLocationCode"; Rec."New Location Code")
                { }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(newBinCode; Rec."New Bin Code")
                {
                    Caption = 'New Bin Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        LastLine: Record "Item Journal Line";
    begin
        Rec."Journal Template Name" := 'ARTICLE';
        Rec."Journal Batch Name" := 'DEFAUT';
        Rec."Entry Type" := Rec."Entry Type"::Transfer;
        Rec."Document Date" := Today;



        LastLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        LastLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");

        if LastLine.FindLast then
            Rec."Line No." := LastLine."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;

}
