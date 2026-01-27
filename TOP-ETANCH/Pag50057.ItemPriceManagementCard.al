namespace Top.Top;

using Microsoft.Inventory.Item;

page 50057 "Item Price Management Card"
{
    ApplicationArea = All;
    Caption = 'Gestion des prix de vente';
    PageType = Card;
    SourceTable = Item;
    layout
    {
        area(Content)
        {
            group(Général)
            {
                Editable = false;
                field("No."; rec."No.") { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }

                field("Unit Cost"; rec."Unit Cost") { ApplicationArea = All; }
                field(LastPurchaseCost; rec."Last Direct Cost")
                {
                    Caption = 'Dernier coût d''achat';
                    Editable = false;
                }
            }
            group(Prix)
            {
                group("Marché")
                {
                    field("Market Price"; rec."Prix marché")
                    {
                        Caption = 'Prix';
                        Style = Ambiguous;
                        ApplicationArea = All;

                    }
                    field("%Mrg "; Rec."MrgMarché")

                    {
                        Caption = '%';
                        Style = Ambiguous;
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;

                    }
                }
                group("Standard (calculé)")
                {
                    field("Standard Sales Price"; rec."Prix standard")
                    {
                        Caption = 'Prix';
                        Style = StrongAccent;
                        ApplicationArea = All;

                    }
                    field("%Mrg"; Rec.MrgStd)
                    {
                        Caption = '%';
                        Style = StrongAccent;
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;

                    }
                }
                group("A appliquer")
                {
                    field("Unit Price"; rec."Unit Price") { Style = Favorable; Editable = false; ApplicationArea = All; }
                }
            }


            part(PriceLines; "Item Active Price ")
            {
                Caption = 'Prix par tarif';
                SubPageLink = "Product No." = field("No.");
                UpdatePropagation = Both;

            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        rec.SyncPriceAndMargin(1);
    end;





    //    var
    //        MrgMarché, MrgStd, LastPurchaseCost : Decimal;

}



