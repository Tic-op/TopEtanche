namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Attribute;

page 50038 "Affectation Valeur attribut"
{ ApplicationArea = All;
    Caption = 'Affectation Valeur attribut';
    PageType = Worksheet;
    SourceTable = Item;
    Permissions = tabledata item = Rm ;
   // SourceTableTemporary = true ;
    UsageCategory = Tasks ;
    DeleteAllowed= false;
  // ModifyAllowed = false ;
    InsertAllowed= false ;
     
    layout
    {
        area(Content)
        {   
              
          
            
            
            group("Attribut&value"){
                
       // GridLayout = Columns;
           
          group(Attributetvaleur){
             Caption = 'Attribut et valeur';
          field(attribut;attribut)
          { Enabled = not AffectationParArticle;
          Caption = 'Attribut';
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
            Enabled = not AffectationParArticle;
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

    trigger OnValidate()
    var begin 
        ControlType(attribut,AttributeValue);

    end;
    
                                                                                                           
            
          }
          field(AffectationParArticle;AffectationParArticle)
          {
            ApplicationArea = all ;
            Caption = 'Affectation multiple';
            trigger OnValidate()
            var 
            begin 
                if not AffectationParArticle then 
                Clear(DynCaption);
               // Clear(DynShow);
                clear(Attributdictionnary);
                AttributesCount:=0 ;
                CurrPage.Update();
                
            end;
            
          } 
         /*  group(attributs)
            {  
                Editable = true ;
                Enabled = true ;
                Visible = AffectationParArticle;  
                 
                 part(ListeAttribut;listeattribut){
          Visible=AffectationParArticle;
          Editable = true ;
        Enabled= true ; 
    
          }
          
          } */
         /*    group(attributs)
            {  
                Editable = true ;
                Enabled = true ;
                Visible = AffectationParArticle;  */
                
              /*    part(ListeAttribut;listeattribut){
          Visible=AffectationParArticle;
          Editable = true ;
        Enabled= true ; */
    
          //}

          //  }
         
    
    

    
  // }
   }
       grid(attributs)
            {  
                Editable = true ;
                Enabled = true ;
                Visible = AffectationParArticle; 
                
                
               
                  
                 part(ListeAttribut;listeattribut){
                    
          Visible=AffectationParArticle;
          Editable = true ;
        Enabled= true ; 
        UpdatePropagation = Both ;
    
        }
          
          }}
        
  group (Articles){}
            repeater(General)
            { 
                
                
                
                 //Editable = false ;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Numéro de l’article.';
                    TableRelation= Item."No.";
                   // enabled =false ;
                    editable = false ;
                }
                field("Vendor Item No.";Rec."Vendor Item No."){
                        //  enabled =false ;
                    editable = false ;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description de l’article.';
                     //  enabled =false ;
                    editable = false ;
                }
               
                field("Famille Category"; Rec."Famille Category")
                {
                    ToolTip = 'Specifies the value of the Famille field.', Comment = '%';
                       enabled =false ;
                    editable = false ;
                }
                field("Catégorie Category"; Rec."Catégorie Category")
                {
                    ToolTip = 'Specifies the value of the Catégorie field.', Comment = '%';
                       enabled =false ;
                    editable = false ;
                }
                  field("Produit Category"; Rec."Produit Category")
                {
                    ToolTip = 'Specifies the value of the Produit field.', Comment = '%';
                       enabled =false ;
                    editable = false ;

                }
                field("Type category"; Rec."Type category")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                     TableRelation= "Item Category";
                        enabled =false ;
                    editable = false ;
                }
                field("Matériau category";Rec."Matériau category")
                    {
                          TableRelation= "Item Category";
                             enabled =false ;
                    editable = false ;
                    }

              
              field(DynAttr1; rec.DynAttr1)
{
    CaptionClass = getCaption(1);
    Visible = AttributesCount >=1;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[1] <> '') and (rec.DynAttr1 <> '') then
            ControlType(DynCaption[1], rec.DynAttr1);
    end;
}

field(DynAttr2; rec.DynAttr2)
{
    CaptionClass = getCaption(2);
    Visible = AttributesCount >=2;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[2] <> '') and (rec.DynAttr2 <> '') then
            ControlType(DynCaption[2], rec.DynAttr2);
    end;
}

field(DynAttr3; rec.DynAttr3)
{
    CaptionClass = getCaption(3);
    Visible = AttributesCount >=3;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[3] <> '') and (rec.DynAttr3 <> '') then
            ControlType(DynCaption[3], rec.DynAttr3);
    end;
}

field(DynAttr4; rec.DynAttr4)
{
    CaptionClass = getCaption(4);
    Visible = AttributesCount >=4;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[4] <> '') and (rec.DynAttr4 <> '') then
            ControlType(DynCaption[4], rec.DynAttr4);
    end;
}

field(DynAttr5; rec.DynAttr5)
{
    CaptionClass = getCaption(5);
    Visible = AttributesCount >=5;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[5] <> '') and (rec.DynAttr5 <> '') then
            ControlType(DynCaption[5], rec.DynAttr5);
    end;
}

field(DynAttr6; rec.DynAttr6)
{
    CaptionClass = getCaption(6);
    Visible = AttributesCount >=6;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[6] <> '') and (rec.DynAttr6 <> '') then
            ControlType(DynCaption[6], rec.DynAttr6);
    end;
}

field(DynAttr7; rec.DynAttr7)
{
    CaptionClass = getCaption(7);
    Visible = AttributesCount >=7;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[7] <> '') and (rec.DynAttr7 <> '') then
            ControlType(DynCaption[7], rec.DynAttr7);
    end;
}

field(DynAttr8; rec.DynAttr8)
{
    CaptionClass = getCaption(8);
    Visible = AttributesCount >=8;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[8] <> '') and (rec.DynAttr8 <> '') then
            ControlType(DynCaption[8], rec.DynAttr8);
    end;
}

field(DynAttr9; rec.DynAttr9)
{
    CaptionClass = getCaption(9);
    Visible = AttributesCount >=9;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[9] <> '') and (rec.DynAttr9 <> '') then
            ControlType(DynCaption[9], rec.DynAttr9);
    end;
}

field(DynAttr10; rec.DynAttr10)
{
    CaptionClass = getCaption(10);
    Visible = AttributesCount >=10;
    trigger OnValidate() 
    var 
    begin 
        if (DynCaption[10] <> '') and (rec.DynAttr10 <> '') then
            ControlType(DynCaption[10], rec.DynAttr10);
    end;
}


                
            }
        
        


    }}


    actions{
          area(Processing){
            Action(Valider)
            {  ApplicationArea= all ;
            Image = Apply;
               Trigger OnAction() 
               var 
               i : integer ;
               begin 
                //rec.SetCurrentKey("No.");
                
                  If confirm('Cette action va affecter %1 article, veuillez confirmer pour appliquer ces changement',false,rec.count) then 
                  begin 
                    if not AffectationParArticle 
                    then begin 
                    Rec.Findfirst() ;
                     rec.assignattribute(attribut,AttributeValue);
                  repeat
                 rec.assignattribute(attribut,AttributeValue);
                  until rec.Next()=0 ;
               end;



                  if AffectationParArticle then 
                  begin 
                     rec.FindFirst();
                     repeat 
                  if (DynCaption[1] <> '') and (rec.DynAttr1 <> '') then
    rec.AssignAttribute(DynCaption[1], rec.DynAttr1);

if (DynCaption[2] <> '') and (rec.DynAttr2 <> '') then
    rec.AssignAttribute(DynCaption[2], rec.DynAttr2);

if (DynCaption[3] <> '') and (rec.DynAttr3 <> '') then
    rec.AssignAttribute(DynCaption[3], rec.DynAttr3);

if (DynCaption[4] <> '') and (rec.DynAttr4 <> '') then
    rec.AssignAttribute(DynCaption[4], rec.DynAttr4);

if (DynCaption[5] <> '') and (rec.DynAttr5 <> '') then
    rec.AssignAttribute(DynCaption[5], rec.DynAttr5);

if (DynCaption[6] <> '') and (rec.DynAttr6 <> '') then
    rec.AssignAttribute(DynCaption[6], rec.DynAttr6);

if (DynCaption[7] <> '') and (rec.DynAttr7 <> '') then
    rec.AssignAttribute(DynCaption[7], rec.DynAttr7);

if (DynCaption[8] <> '') and (rec.DynAttr8 <> '') then
    rec.AssignAttribute(DynCaption[8], rec.DynAttr8);

if (DynCaption[9] <> '') and (rec.DynAttr9 <> '') then
    rec.AssignAttribute(DynCaption[9], rec.DynAttr9);

if (DynCaption[10] <> '') and (rec.DynAttr10 <> '') then
    rec.AssignAttribute(DynCaption[10], rec.DynAttr10);


                     until rec.next=0;
                 rec.ModifyAll(DynAttr1, '');
rec.ModifyAll(DynAttr2, '');
rec.ModifyAll(DynAttr3, '');
rec.ModifyAll(DynAttr4, '');
rec.ModifyAll(DynAttr5, '');
rec.ModifyAll(DynAttr6, '');
rec.ModifyAll(DynAttr7, '');
rec.ModifyAll(DynAttr8, '');
rec.ModifyAll(DynAttr9, '');
rec.ModifyAll(DynAttr10, '');
                  end;
                   Clear(Attributdictionnary);
                Clear(DynCaption);
                AttributesCount:=0 ;
               end
               end ;

            }
            Action(Générer)
            {
                Caption= 'Générer les colonnes des attributs';
                   visible= AffectationParArticle ;
                   Enabled=AffectationParArticle;
                trigger onAction()
                var 
                IA : Record "Item Attributes Buffer"  ;
                i :integer ;
                 begin 
                CurrPage.ListeAttribut.Page.GetTempAttributes(IA);
                AttributesCount:=IA.count ;
                i := 1 ;
                Clear(Attributdictionnary);
                Clear(DynCaption);
                IA.FindFirst() ;
                repeat 
                Attributdictionnary.Add(IA.ID,IA.Name);
                DynCaption[i]:=IA.Name;
                i:=i+1 ;

                until IA.next=0;
                CurrPage.update();


                end;

            }
          }

    }

     Procedure ControlType(attName :text[250];AttributeValue:text[250]) 
    var 
    IA : record "Item Attribute";
    varint : integer ;
    vardecimal : decimal ; 
    vardate : Date ;
    Iav : record "Item Attribute Value";

    begin 
        Ia.SetRange(Name,attName);
        Ia.findfirst();
    
    Case ia.Type of 
      Ia.type::Date :
        if not Evaluate(vardate,AttributeValue) then Error('Date non valide');  
    IA.type::Decimal:
    begin 
         if not(Evaluate(vardecimal,AttributeValue)) then error('') ;
         if (vardecimal*100 ) mod 1 <> 0 then error('veuillez saisir un décimal avec 2 chiffres aprés la virgule');
         end;
     IA.Type::Integer:
     begin 
         if not evaluate(varint,AttributeValue)then error('') ;
         if varint mod 1 <> 0 then error('veuillez saisir un type entier');
     end;

      Ia.Type::Option:
      begin 
          iav.setrange("Attribute ID",ia.ID);
          Iav.SetRange(Value,AttributeValue);
          If not iav.FindFirst() then Error('Valeur attribut non existante');


      end;

    
    
    End;
        



    end;



    Procedure getCaption(I : Integer) : text [100]
    begin 

        exit (DynCaption[I]);
    end;
/* 
    Procedure getvisibility(I :Integer): Boolean
    begin 


        exit (DynShow[I]);
    end; */
    var famille,catégory, "type" , Produit,Matériau : code [20];
        
      AttributeValue ,attribut: text[250];
      AffectationParArticle : Boolean ;
     // ListeAttribut : array []
     AttributesCount : integer ;
     Attributdictionnary :  Dictionary of [Integer,text];

     DynCaption: array[10] of Text[100];
     // DynShow: array[10] of Boolean; 


}

