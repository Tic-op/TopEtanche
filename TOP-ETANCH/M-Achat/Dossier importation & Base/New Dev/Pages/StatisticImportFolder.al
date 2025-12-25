page 50079 "Statistic Import Folder"
{
    Caption = 'Import folder Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Import Folder";

    layout
    {
        area(content)
        {
            field("Factures achat enregistrées"; Rec."Factures achat enregistrées")
            {
                ApplicationArea = RelationshipMgmt;
                ToolTip = 'Specifies the number of posted purchased invoices .';
            }
        }
    }
}