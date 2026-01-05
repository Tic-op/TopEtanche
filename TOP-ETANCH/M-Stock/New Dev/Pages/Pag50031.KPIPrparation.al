namespace Top.Top;
using Microsoft.Inventory.Location;

page 50031 "KPI Préparation"
{
    ApplicationArea = All;
    Caption = 'KPI Préparation';
    PageType = CardPart;
    SourceTable = "Indicateur Préparation";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {   /* Group(Filters)

            {
                Caption ='Filtres';
                field(Magasin ; FiltreMagasin){
                 TableRelation = Location;  
                 trigger OnValidate()
                 begin 


                   // rec.Setrange(Locationfilter,FiltreMagasin);
                    Message(rec.Locationfilter +'   ' + FiltreMagasin);
                  // CurrPage.Update();

                 end;             
                  }
            } */




            field("Nouvelles prép."; Rec."Nouvelles prép.")
            {
                ToolTip = 'Specifies the value of the Préparations vente encours field.', Comment = '%';
            }
            field("Encours Vente"; Rec."Encours Vente")
            {
                ToolTip = 'Specifies the value of the Préparations vente regoupées field.', Comment = '%';
            }
            field("Encours Transf."; Rec."Encours Transf.")
            {
                ToolTip = 'Specifies the value of the Préparations transfert encours field.', Comment = '%';
            }


        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        rec.SetRange(Locationfilter, '');

        rec.SetAutoCalcFields("Prép transfer regoupées", "Nouvelles prép.", "Encours Transf.", "Encours Vente");

    end;

    var
        FiltreMagasin: code[10];

}


