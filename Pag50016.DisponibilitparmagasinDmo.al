namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;

page 50016 "Disponibilité par magasin Démo"
{
    ApplicationArea = All;
    Caption = 'Disponibilité par magasin de transfert';
    PageType = Worksheet;
    SourceTable = "Item Ledger Entry";
    UsageCategory = Tasks;
    InsertAllowed = false;
    DeleteAllowed = false;


    SourceTableView = where("Open" = const(true));

    layout
    {
        area(Content)
        {

            group(Filtres)
            {

                field("Filtre magasin"; locationFilter)
                {
                    TableRelation = Location where(Code = filter('<>PRINCIPAL'), "Use As In-Transit" = const(false));
                    trigger OnValidate()
                    begin

                        if locationFilter = 'PRINCIPAL' then
                            exit;


                        if locationFilter <> '' then begin
                            rec.setrange("Location Code", locationFilter);
                            CurrPage.Update();
                        end;
                    end;

                }
            }
            repeater(General)
            {
                Editable = false;
                field(Famille; Rec.Famille)
                {
                    ToolTip = 'Specifies the value of the Famille field.', Comment = '%';
                    ApplicationArea = all;
                    Caption = 'famille';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the number of the item in the entry.';
                    ApplicationArea = all;
                    Caption = 'N° article';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the entry.';
                    ApplicationArea = all;
                    Caption = 'Description';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;

                }
                field("Nom Origine"; Rec."Nom Origine")
                {
                    ToolTip = 'Specifies the value of the Nom Origine field.', Comment = '%';
                    ApplicationArea = all;
                    Caption = 'Nom Origine';
                }
                field("Motif de transfert"; Rec."Motif de transfert")
                {
                    ApplicationArea = all;
                    Caption = 'Motif de transfert';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the entry''s posting date.';
                    ApplicationArea = all;
                    Caption = 'Date';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Caption = 'Quantité';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ToolTip = 'Specifies the quantity in the Quantity field that remains to be processed.';
                    ApplicationArea = all;
                    Caption = 'Quantité restante';
                }

            }

        }

    }
    trigger OnOpenPage()
    begin
        locationFilter := 'Démo';
        Rec.SetRange("Location Code", locationFilter);
    end;

    var
        locationFilter: Code[15];

}
