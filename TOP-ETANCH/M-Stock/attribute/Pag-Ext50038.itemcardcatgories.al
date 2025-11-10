namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Attribute;

pageextension 50038 "item card catégories" extends "Item Card"
{
    layout { 
        addbefore("Item Category Code"){

            field("Famille Category";Rec."Famille Category"){
                ApplicationArea = all ;
            }
            field("Catégorie Category";Rec."Catégorie Category")
            {
                ApplicationArea = all ;

            }
            field("Produit Category";Rec."Produit Category")
            {
                ApplicationArea = all ;
            }
            field("Type category";Rec."Type category")
            {
                ApplicationArea = all ;
            }
            field("Fiche matériaux";Rec."Fiche matériaux")
            {
                ApplicationArea = all ;
            }
            


        }

          modify("Item Category Code")
        {
            visible=false ;
        }
    }
    actions {
         addafter(Navigation_Item)
    {    
        action (supprimer_mapping)
        {
            ApplicationArea= all;
              Promoted = true ;
                PromotedCategory = Process ;
            trigger OnAction() var IAVM : Record "Item Attribute Value Mapping";
                  ia : record "Item Attribute Value" ;
            begin 

                iavm.deleteall;
             end;
        }
         action(Extraire_attribut_matériaux)
            {
                caption = 'Extraire attributs matériaux';
                ApplicationArea = all;
                Image = Import;
                Promoted = true ;
                PromotedCategory = Process ;
            
                trigger OnAction()
                var
                    PropMatériaux: record "Propriété matériaux";
                    IAvaluesMapping: record "Item Attribute Value Mapping";
                    IA: record "Item Attribute";
                    IAV: Record "Item Attribute Value";
                    cu: codeunit "Item Attribute Management";
                    IAVID: record "Item Attribute Value Selection";
                begin
                    "PropMatériaux".SetRange("Code matériaux", rec."Fiche matériaux");
                    "PropMatériaux".findfirst;
                    repeat

                        IA.setrange(Name, "PropMatériaux"."Propriété");
                        IA.findfirst();

                        IAvaluesMapping.init();
                        IAvaluesMapping."Table ID" := 27 ;
                        
                        IAvaluesMapping."No." := rec."No." ;
                        IAvaluesMapping."Item Attribute ID" := IA.ID;
                        IAV.setrange("Attribute ID", IA.ID);
                        IAV.SetRange("Attribute Name", IA.Name);
                        IAV.Setfilter(Value, '%1', "PropMatériaux"."Valeur par défaut");
                        if IAV.FindFirst() then
                            IAvaluesMapping."Item Attribute Value ID" := IAV.ID
                        else begin
                            Iav.reset();
                            IAV.Init();
                            IAV."Attribute ID" := IA.ID;
                            Iav.validate(Value, "PropMatériaux"."Valeur par défaut");
                            if not Iav.insert(true) then
                                repeat
                                    IAV.Id += 1;
                                until IAV.insert(true);


                            // IAV.Modify();

                            Commit();
                            IAvaluesMapping."Item Attribute Value ID" := IAV.ID;


                        end;
                        // IAvaluesMapping.
                        if IAvaluesMapping.Insert() then;

                    until "PropMatériaux".next = 0;


                end;
            }
    }
    }
   
}
