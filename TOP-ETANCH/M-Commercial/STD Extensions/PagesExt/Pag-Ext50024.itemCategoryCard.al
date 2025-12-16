namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Attribute;

pageextension 50024 itemCategoryCard extends "Item Category Card"
{


    layout
    {


        addafter(Description)
        {
            field(Level; Rec.Level)
            {
                ApplicationArea = all;
                enabled = rec.Parent='';
            }

            field("Default Depot"; Rec."Default Depot") {
                
                 ApplicationArea = all; 
                 Enabled = (rec.Level= rec.Level::Type);}
           /*  field("Fiche matériaux"; Rec."Fiche matériaux")
            {
                enabled = rec.Level = rec.Level::Type;
                ApplicationArea = all;
            } */

            field(Parent;Rec.Parent){
                ApplicationArea= all;
                Enabled = ((rec.level<>rec.level::Famille)and (Rec.level <> 0));
            }
        }
        modify("Parent Category"){
                        Visible = false ;

        }
    }
    Actions
    {

        addlast(processing)
        {
            action(supprimer)
            {
                ApplicationArea = all;
                Caption = 'supprimer mapping';
                visible=false;

                trigger onaction()
                var
                    iavmap: Record "Item Attribute Value Mapping";
                begin
                    iavmap.DeleteAll(false);
                end;

            }

           /*  action(Extraire_attribut_matériaux)
            {
                caption = 'Extraire attributs matériaux';
                ApplicationArea = all;
                Image = Import;
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
                        IAvaluesMapping."Table ID" := 5722;
                        IAvaluesMapping."No." := rec.Code;
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
            } */
        }
    }
}
