namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;

pageextension 50017 PurchaseOrderSubformExt extends "Purchase Order Subform"
{
    //InsertAllowed = false;

    layout
    {
        addafter(Description)
        {
            /*   field("Tariff No."; Rec."Tariff No.")
              {
                  ApplicationArea = all;
              }
              field("Country region origin code"; Rec."Country region origin code")
              {
                  ApplicationArea = all;
              } */
            /*  field("DOP No."; Rec."DOP No.")  //IS 070822025
             {
                 ApplicationArea = all;
             }
             field("DOP Line No."; Rec."DOP Line No.")
             {
                 ApplicationArea = all;
             } */

        }
        modify(Quantity)
        {
            trigger OnAfterValidate()

            var
                LigneCadre: Record "Purchase Line";
                Max: Decimal;
            begin
                if (rec."Blanket Order No." <> '') and (rec."Blanket Order Line No." <> 0) then begin
                    if LigneCadre.Get(LigneCadre."Document Type"::"Blanket Order", rec."Blanket Order No.", rec."Blanket Order Line No.") then begin
                        //  Max := LigneCadre.Quantity - LigneCadre."A commander";
                        if rec."Quantity (Base)" > LigneCadre."Quantity (Base)" then
                            Error('La quantité ne peut pas dépasser la quantité restante');
                    end;
                end;
                rec."MAJ_Qté_Restante"();
                rec.modify;
            end;

        }
        /*   modify("No.")
           {
               trigger OnAfterValidate()
               begin
                   if xrec."No." <> '' then
                       error('On peut pas modifier la référence');
               end;
           }
           modify("Description")
           {
               trigger OnAfterValidate()
               begin
                   if xrec."No." <> '' then
                       error('On peut pas modifier la description');
               end;
           }
   */
    }
}
