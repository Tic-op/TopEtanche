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
    InsertAllowed = false;
    //  ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = sorting("Creation date", "Date début préparation", "Date fin préparation") order(descending);

    layout
    {

        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field(No;
                Rec.No)
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
            field("Date début préparation"; Rec."Date début préparation")
            {
                ApplicationArea = all;
            }
            Field("Nom demandeur"; Rec."Nom demandeur")
            { ApplicationArea = all; }
            field("Num document validé"; Rec."Num document validé")
            { ApplicationArea = all; }



        }
    }
}


}