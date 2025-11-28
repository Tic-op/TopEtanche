namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Attribute;

page 50038 "Affectation Valeur attribut"
{ ApplicationArea = All;
    Caption = 'Affectation Valeur attribut';
    PageType = Worksheet;
    SourceTable = Item;
    UsageCategory = Tasks ;
    DeleteAllowed= false;
    ModifyAllowed = false ;
    InsertAllowed= false ;
    
    layout
    {
        area(Content)
        {    Group("Attribut&value"){

            Caption = 'Attribut et valeur';
          
          field(attribut;attribut)
          { 
               trigger OnLookup(var Text: Text): Boolean
    var
       IA: Record "Item Attribute";
        PageLookup: Page "Item Attributes" ;
        fg : page 7504;
    begin
      // IAV.SetRange("Attribute Name",attribut);
       // PageLookup.SetTableView(IAV);
        PageLookup.LookupMode:=true;
        PageLookup.Editable:= false ; 
        if PageLookup.RunModal() = Action::LookupOK then
            PageLookup.GetRecord(IA);
        attribut:= IA.Name;
        //exit(true);
    end;
            
            
            
          }
          field("Valeur attribut";AttributeValue)
          {   
            //TableRelation = "Item Attribute Value".Value ;
            trigger OnLookup(var Text: Text): Boolean
    var
       IAV: Record "Item Attribute Value";
        PageLookup: Page "Item Attribute Values" ;
        fg : page 7504;
    begin
       IAV.SetRange("Attribute Name",attribut);
        PageLookup.SetTableView(IAV);
        PageLookup.LookupMode:=true;
        PageLookup.Editable:= false ; 
        if PageLookup.RunModal() = Action::LookupOK then
            PageLookup.GetRecord(IAV);
        AttributeValue:= IAV.Value;
        //exit(true);
    end;
                                                                                                           
            
          }
    }


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
                 rec.assignattribute(attribut,AttributeValue);
                  until rec.Next()=0 ;

                  


               end;

            }
          }

    }
    var famille,catégory, "type" , Produit,Matière : code [20];
        
      AttributeValue ,attribut: text[250];
}

