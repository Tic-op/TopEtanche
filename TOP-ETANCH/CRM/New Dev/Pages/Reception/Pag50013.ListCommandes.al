namespace TopEtanch.TopEtanch;

using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;

page 50013 ListCommandes
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'listCommandes';
    DelayedInsert = true;
    EntityName = 'OrderList';
    EntitySetName = 'OrderLists';
    PageType = API;
    SourceTable = "Purchase Header";
    SourceTableView = where("Completely Received" = const(false), "Document Type" = const(Order));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId) { }
                field("No"; Rec."No.") { }
                field("Nvendor"; Rec."Buy-from Vendor No.") { }
                field("Name"; Rec."Pay-to Name") { }
                field("DateDocument"; Rec."Document Date") { }
                field("DateComptabilisation"; Rec."Posting Date") { }
                field(Status; Rec.Status) { }
            }
        }
    }

     
}
