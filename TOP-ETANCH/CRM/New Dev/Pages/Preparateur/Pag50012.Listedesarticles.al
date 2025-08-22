namespace TopEtanch.TopEtanch;
using Microsoft.Sales.Document;

page 50012 "Listedesarticles"
{
    APIGroup = 'TICOP';
    APIPublisher = 'TICOP';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'listeDesArticles';
    DelayedInsert = true;
    EntityName = 'ligne';
    EntitySetName = 'lignes';
    PageType = API;
    SourceTable = "Ordre de preparation";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Articles)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(orderNo; Rec."Order No")
                {
                    Caption = 'Order No';
                }
                field(no; Rec.No)
                {
                    Caption = 'No';
                }
                field(statut; Rec.Statut)
                {
                    Caption = 'Statut';
                }
                field(magasin; Rec.Magasin)
                {
                    Caption = 'Magasin';
                }


                part(lignesprep; "salesLine")
                {
                    ApplicationArea = All;
                    EntityName = 'ligneprep';
                    EntitySetName = 'lignesprep';
                    SubPageLink = "Document No." = field("Order No"), "Document Type" = const(Order);
                }
            }
        }
    }
}