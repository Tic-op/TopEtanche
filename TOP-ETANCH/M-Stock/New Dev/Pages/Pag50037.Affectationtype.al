namespace Top.Top;

using Microsoft.Inventory.Item;

page 50037 "Affectation type"
{
    ApplicationArea = All;
    Caption = 'Affectation type';
    PageType = Worksheet;
    SourceTable = Item;
    UsageCategory = Tasks ;
    DeleteAllowed= false;
    ModifyAllowed = false ;
    InsertAllowed= false ;
    
    layout
    {
        area(Content)
        {    Group(Catégories){

            Caption = 'Catégorisation des articles';
           field(famille;famille)
           {
           TableRelation = "Item Category"."Code" where("Parent Category" = const(''),Level= const(Famille));
           } 
            field("catégory";"catégory")
           {
             TableRelation = "Item Category"."Code" where(Level= const(Catégorie)); 
            trigger OnLookup(var Text: Text): Boolean
    var
        ItemCat: Record "Item Category";
        PageLookup: Page "item Categories";
    begin
       ItemCat.SetRange("Parent Category",famille);
        PageLookup.SetTableView(Itemcat);
        PageLookup.LookupMode:=true;
        PageLookup.Editable:= false ; 
        if PageLookup.RunModal() = Action::LookupOK then
            PageLookup.GetRecord(ItemCat);

        "catégory":= ItemCat.code;
        //exit(true);
    end;
             
             }

              field(Produit;Produit)
           {
             TableRelation = "Item Category"."Code" where(Level= const(Produit)); 
                trigger OnLookup(var Text: Text): Boolean
    var
        ItemCat: Record "Item Category";
        PageLookup: Page "item Categories";
    begin
       ItemCat.SetRange("Parent Category","catégory");
        PageLookup.SetTableView(Itemcat);
        PageLookup.LookupMode:=true;
        PageLookup.Editable:= false ; 
        if PageLookup.RunModal() = Action::LookupOK then
            PageLookup.GetRecord(ItemCat);

        Produit:= ItemCat.code;
        //exit(true);
    end;
             
             }
              field("Type";"type")
           {
             TableRelation = "Item Category"."Code" where(Level= const("type")); 
                           trigger OnLookup(var Text: Text): Boolean
    var
        ItemCat: Record "Item Category";
        PageLookup: Page "item Categories";
    begin
       ItemCat.SetRange("Parent Category",Produit);
        PageLookup.SetTableView(Itemcat);
        PageLookup.LookupMode:=true;
        PageLookup.Editable:= false ; 
        if PageLookup.RunModal() = Action::LookupOK then
            PageLookup.GetRecord(ItemCat);
        "type":= ItemCat.code;
        //exit(true);
    end;}
     field(Matière;Matière)
           {
             TableRelation = "Item Category"."Code" where(Level= const(Matière)); 
                           trigger OnLookup(var Text: Text): Boolean
    var
        ItemCat: Record "Item Category";
        PageLookup: Page "item Categories";
    begin
       ItemCat.SetRange("Parent Category","type");
        PageLookup.SetTableView(Itemcat);
        PageLookup.LookupMode:=true;
        PageLookup.Editable:= false ; 
        if PageLookup.RunModal() = Action::LookupOK then
            PageLookup.GetRecord(ItemCat);
        Matière:= ItemCat.code;
        //exit(true);
    end;
             
             }}


            repeater(General)
            {  Editable = false ;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Numéro de l’article.';
                }
                field("Vendor Item No.";Rec."Vendor Item No."){

                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description de l’article.';
                }
               
                field("Famille Category"; Rec."Famille Category")
                {
                    ToolTip = 'Specifies the value of the Famille field.', Comment = '%';
                }
                field("Catégorie Category"; Rec."Catégorie Category")
                {
                    ToolTip = 'Specifies the value of the Catégorie field.', Comment = '%';
                }
                  field("Produit Category"; Rec."Produit Category")
                {
                    ToolTip = 'Specifies the value of the Produit field.', Comment = '%';
                }
                field("Type category"; Rec."Type category")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Matière category";Rec."Matière category")
                    {

                    }
              

            }
        }
        
         

    }


    actions{
          area(Processing){
            Action(Valider)
            {  ApplicationArea= all ;
            Image = Apply;
               Trigger OnAction() 
               var begin 
                  Rec.FindFirst() ;
                  If confirm('Cette action va affecter %1 article, veuillez confirmer pour appliquer ces changement',false,rec.count) then 
                  repeat
                  REC.validate("Famille Category",famille);
                  REC.Validate("Catégorie Category","catégory");
                  rec.validate("Produit Category",Produit);
                  rec.validate("Type category",type);
                  rec.Validate("Matière category","Matière");
                  rec.Modify()
                  until rec.Next()=0 ;

                  


               end;

            }
          }

    }
    var famille,catégory, "type" , Produit,Matière : code [20];
        
     
}
