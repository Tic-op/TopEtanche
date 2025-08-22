namespace TopEtanch.TopEtanch;

page 50018 ExportScannedItemR
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'exportScannedItemR';
    DelayedInsert = true;
    EntityName = 'Item';
    EntitySetName = 'Items';
    PageType = API;
    SourceTable = "Reception Entry";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId) { }
                field(OrderNo; Rec."Purchase Order No.")
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

                field(terminalID; Rec."Terminal ID")
                {

                }
            }
        }
    }
}
