namespace TopEtanch.TopEtanch;

page 50085 InsertInvEntry
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'InsertEcritureInventaire';
    DelayedInsert = true;
    EntityName = 'EcritureInventaire';
    EntitySetName = 'EcritureInventaires';
    PageType = API;
    SourceTable = "Inventory Entry";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId) { }

                field(inventoryNo; Rec."Inventory No.")
                {

                }
                field(itemNo; Rec."Item No.")
                {

                }

                field(itemBarCode; Rec."Item Bar Code")
                {

                }
                field(quantity; Rec.Quantity)
                {

                }
                field(scanDate; Rec."Scan Date")
                {

                }

                field(vracQuantity; Rec."Vrac Quantity")
                {

                }
                field("TerminalID"; Rec."Terminal ID") { }
                field(countNo; GetCountNo())
                {
                    Caption = 'Count No.';
                }
                field(Description; Rec.Description)
                { }
            }
        }
    }

    local procedure GetCountNo(): Integer
    var
        InvHeader: Record "Inventory Header";
    begin
        if InvHeader.Get(Rec."Inventory No.") then
            exit(InvHeader."Count No.");
        exit('0');
    end;
}
