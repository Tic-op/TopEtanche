namespace TopEtanch.TopEtanch;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Transfer;

page 50006 "Liste bon de préparation"
{
    ApplicationArea = All;
    Caption = 'Liste bon de préparation';
    PageType = List;
    SourceTable = "Ordre de preparation";
    CardPageId = "Bon de preparation";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                    ApplicationArea = all;
                }


                /*field(magasin; Rec.Magasin)
                {
                    ToolTip = 'Specifies the value of the Magasin field.', Comment = '%';
                }*/
                field("Order No"; Rec."Order No")
                {
                    ApplicationArea = all;
                }
                field(Magasin; Rec.Magasin)
                {
                    ApplicationArea = all;
                }
                field(statut; Rec.Statut)
                {
                    Editable = false;

                    ApplicationArea = all;
                }

                field("Préparateur"; Rec."Préparateur")
                {
                    ApplicationArea = all;

                }
                field("Creation date"; Rec."Creation date")
                { ApplicationArea = all; }


            }
        }
    }


}