namespace TopEtanch.TopEtanch;
using Microsoft.Sales.Document;

page 50005 "Bon de preparation"
{
    ApplicationArea = All;
    Caption = 'Bon de preparation';
    PageType = Card;
    SourceTable = "Ordre de preparation";


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Order No"; Rec."Order No")
                {
                    ToolTip = 'Specifies the value of the N° Commande field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("document type"; Rec."document type")
                {
                    ApplicationArea = all;
                }
                field(Magasin; Rec.Magasin)
                {
                    ToolTip = 'Specifies the value of the Magasin field.', Comment = '%';
                    ApplicationArea = all;
                }
                field(Statut; Rec.Statut)
                {
                    ToolTip = 'Specifies the value of the Statut field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Préparateur"; Rec."Préparateur")
                {
                    ToolTip = 'Specifies the value of the Préparateur field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Creation date"; Rec."Creation date")
                {
                    ToolTip = 'Specifies the value of the Date de création field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Date début préparation"; Rec."Date début préparation")
                {
                    ToolTip = 'Specifies the value of the Date début préparation field.', Comment = '%';

                    ApplicationArea = all;
                }
                field("Date fin préparation"; Rec."Date fin préparation")
                {
                    ApplicationArea = all;
                }


            }
            part(LigneCommande; "Lignes Commande")
            {
                Editable = false;
                SubPageLink = "Document No." = field("Order No"), "Location Code" = field(Magasin);
                Visible = LigneCommande;

            }
            part(LigneTransfert; "Lignes transfert")
            {
                Editable = false;
                SubPageLink = "Document No." = field("Order No"), "Transfer-from Code" = field(Magasin);
                Visible = LigneTransfert;
            }

        }
    }
    var
        LigneCommande: Boolean;
        LigneTransfert: Boolean;

    trigger OnAfterGetRecord()
    begin
        LigneCommande := Rec."document type" = rec."document type"::Commande;
        LigneTransfert := Rec."document type" = rec."document type"::Transfert;
    end;
}
