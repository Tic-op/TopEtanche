namespace TopEtanch.TopEtanch;

page 50017 InsertReceptionEntry
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'insertReceptionEntry';
    DelayedInsert = true;
    EntityName = 'InsertReception';
    EntitySetName = 'InsertReceptions';
    PageType = API;
    SourceTable = "Reception Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("EntryNo"; Rec."Entry No.") { }
                field("Ncommande"; Rec."Purchase Order No.") { }
                field("NFournisseur"; Rec."Vendor No.") { }
                field("Article"; Rec."Item No.") { }
                field("Quantite"; Rec.Quantity) { }
                field("ScanDate"; Rec."Scan Date") { }
                field("TerminalID"; Rec."Terminal ID") { }
                field(Description; Rec.Description) { }
            }
        }
    }
}
