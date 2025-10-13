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
          
               
                
                
                field("Préparations vente encours"; Rec."Prép vente encours")
                {
                    ToolTip = 'Specifies the value of the Préparations vente encours field.', Comment = '%';
                }
                field("Préparations vente regoupées"; Rec."Prép vente regoupées")
                {
                    ToolTip = 'Specifies the value of the Préparations vente regoupées field.', Comment = '%';
                }
                field("Préparations transfert encours"; Rec."Prép transfert encours")
                {
                    ToolTip = 'Specifies the value of the Préparations transfert encours field.', Comment = '%';
                }
                field("Prép transfert regoupées"; Rec."Prép transfer regoupées")
                {
                    ToolTip = 'Specifies the value of the Préparations transfert regoupées field.', Comment = '%';
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

        rec.SetRange(Locationfilter,'');

          rec.SetAutoCalcFields("Prép transfer regoupées","Prép transfert encours","Prép vente encours","Prép vente regoupées");

        end;
        var 
        FiltreMagasin : code [10];
       
        }
   

