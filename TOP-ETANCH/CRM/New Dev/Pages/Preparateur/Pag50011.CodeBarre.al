namespace TopEtanch.TopEtanch;

using Microsoft.Warehouse.ADCS;
using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Item;


page 50101 ScanCode
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'codeBarre';
    DelayedInsert = true;
    EntityName = 'CodeBarres';
    EntitySetName = 'CodeBarres';
    PageType = API;
    SourceTable = "Bin Content";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field(SystemId; Rec.SystemId) { }
                field(CodeBarre; CodeBarre)
                {
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(description; Designation)
                {
                    Caption = 'Désignation';
                }

                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Code Magasin';
                }

                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Code Emplacement';
                }

            }
        }
    }


    trigger OnAfterGetRecord()
    var
        ItemIdentifier: Record "Item Identifier TICOP";
        Item: Record Item;
    begin
        CodeBarre := '';
        Designation := '';

        if ItemIdentifier.findfirst() then begin
            if ItemIdentifier."Item No." = Rec."Item No." then
                CodeBarre := ItemIdentifier.Code;
        end;

        if Item.Get(Rec."Item No.") then
            Designation := Item.Description;
    end;

    var
        CodeBarre: Code[50];
        Designation: Text[100];

    /* trigger OnAfterGetRecord()
    var
        ItemIdentifier: Record "Item Identifier";
        Item: Record Item;
    begin
        CodeBarre := '';
        Designation := '';

        
        if Item.Get(Rec."Item No.") then
            Designation := Item.Description;

        ItemIdentifier.SetRange("Item No.", Rec."Item No.");
        if ItemIdentifier.FindFirst() then begin
            CodeBarre := ItemIdentifier.Code;
        end else begin
            CodeBarre := TrouverParDesignation(Designation);
        end;
    end;


    procedure TrouverParDesignation(Description: Text[100]): Code[50]
var
    item: Record Item;
    ItemIdentifier: Record "Item Identifier";
begin
    item.SetRange(Description, Description);
    if item.FindFirst() then begin
        repeat
            ItemIdentifier.SetRange("Item No.", item."No.");
            if ItemIdentifier.FindFirst() then
                exit(ItemIdentifier.Code);
        until item.Next() = 0;
    end;
    exit('');
end;

 */

}

