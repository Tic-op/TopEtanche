namespace TOPETANCH.TOPETANCH;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Counting.Journal;

page 50002 "Inventory Header Card"
{
    ApplicationArea = All;
    Caption = 'Inventaire';
    PageType = Card;
    SourceTable = "Inventory header";
    UsageCategory = Administration;
    Permissions = tabledata "Inventory header" = RIMD;

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
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Sujet inventaire"; Rec."Sujet inventaire")
                {
                    ToolTip = 'Specifies the value of the Sujet inventaire field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Location code"; Rec."Location code")
                {
                    ToolTip = 'Specifies the value of the Location code field.', Comment = '%';
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if (xRec."Location Code" <> Rec."Location Code") then
                            Rec.Validate(Bin, '');
                    end;
                }
                field(Bin; Rec.Bin)
                {
                    ApplicationArea = all;
                    /* trigger OnValidate()
                    var
                        LocationCode: Code[10];
                    begin

                        if Rec."Location Code" <> xRec."Location Code" then begin
                            rec.Bin := '';
                        end;
                    end; */
                }

                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Date lancement"; Rec."Release Date")
                {
                    ToolTip = 'Specifies the value of the Release Date field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("N° comptage"; Rec."Count No.")
                {
                    ToolTip = 'Specifies the value of the N° Comptage field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                    trigger OnValidate()
                    begin
                        CurrPage.update();
                    end;

                }
                field("Code utilisateur"; Rec.UserCreator)
                {
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Date de comptabilisation"; Rec."Posting date")
                {
                    ToolTip = 'Specifies the value of the Date comptabilisation field.', Comment = '%';
                }


                field("Item Nbr"; Rec.CountItem())
                {
                    ToolTip = 'Specifies the value of the Nombre d''article field.', Comment = '%';
                    Caption = 'Nombre d''article';
                    ApplicationArea = all;
                    Editable = false;

                }



                /*

                                field("Valeur art. inventoriés"; Rec."Valeur art. inventoriés")
                                {
                                    ToolTip = 'Specifies the value of the Valeur art. inventoriés field.', Comment = '%';
                                    ApplicationArea = all;
                                }
                                field("Valeur art. à inventorier"; Rec."Valeur art. à inventorier")
                                {
                                    ToolTip = 'Specifies the value of the Valeur art. à inventorier field.', Comment = '%';
                                    ApplicationArea = all;
                                }
                                field(Validate; Rec.Validate)
                                {
                                    ToolTip = 'Specifies the value of the Validate field.', Comment = '%';
                                    ApplicationArea = all;
                                }
                            */

            }
            part(IL; "Inventory Lines")
            {
                EntityName = 'InventoryLine';
                EntitySetName = 'InventoryLines';
                SubPageLink = "Inventory No." = field(No);
                UpdatePropagation = Both;


            }
        }

    }
    actions
    {
        area(Processing)
        {
            action("Lancé")
            {
                ApplicationArea = All;
                Caption = 'Lancé';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Lancé then
                        Error('Le statut est déjà "Lancé"')
                    else
                        if Rec.Status = Rec.Status::Clôturé then
                            Error('Le statut est "Clôturé". Impossible de le changer');

                    Rec.Status := Rec.Status::Lancé;
                    Rec.Modify();

                end;
            }
            action("Rouvrir")
            {
                ApplicationArea = All;
                Caption = 'Rouvrir';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Ouvert then
                        Error('Le statut est déjà "Ouvert"');

                    if Rec.Status = Rec.Status::Clôturé then
                        Error('Le statut est "Clôturé". Impossible de le rouvrir');

                    Rec.Status := Rec.Status::Ouvert;
                    Rec.Modify();
                end;
            }
            action("Nouveau Comptage")
            {
                ApplicationArea = All;
                Caption = 'Nouveau Comptage';
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Count No." >= 5 then
                        Error('Vous avez atteint le nombre maximal de comptages');
                    Rec."Count No." := Rec."Count No." + 1;
                    Rec.Modify();

                end;
            }
            action(CalculInventory)
            {
                ApplicationArea = All;
                Caption = 'Calculer quantité en stock';
                Image = InventoryCalculation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CalculateInventory: Report "Calcul Stock";
                    inventoryheader: record "Inventory header";
                    param: text;
                begin
                    //inventoryheader.get(Rec.No);
                    //report.RunModal(50115, true, true, inventoryheader);
                    CalculateInventory.SetTableView(Rec);
                    // Report.Run(50115, true, true, Rec);
                    //CalculateInventory.Execute(StrSubstNo(rec.No));

                    CalculateInventory.Run();
                    CurrPage.Update();

                end;
            }
        }
    }

}
