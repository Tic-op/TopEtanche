namespace Top.Top;

using Microsoft.Inventory.Item;

page 50042 "item list attribut sort"
{ Caption = 'Articles triés par attribut';
    PageType = List;
    ApplicationArea = All;
    SourceTable = Item;
    SourceTableTemporary = true;
    UsageCategory = None; // Pour ne pas l’afficher dans la recherche standard
    InsertAllowed = false ;
    ModifyAllowed = false ;
    DeleteAllowed = false ;

    
    
    
    
    
    layout{

         area(content)
        {
            repeater(General)
            {
                ShowCaption = false;

                field("No.";rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Numéro de l’article.';
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description de l’article.';
                }
                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
               
                field("Item Category Code"; rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                 field("Valeur attribut";Rec."Valeur attribut"){
                   // Visible = Not Numerique ;
            editable= false ;
            CaptionClass = ''+ Captiontext ;
          }
          field("Valeur Attribut Numérique";Rec."Valeur Attribut Numérique")
          {  
           // Visible = Numerique ;
             editable= false ;
            CaptionClass = ''+ Captiontext ;
          }
               
            

              
             
            }
        }
    
    } 
    trigger OnOpenPage()
    begin 
        if Captiontext<>'' then 
        CurrPage.Caption('Articles triés par '+ Captiontext );
    end;
    procedure setcaption(Caption : text) 
    begin 
     Captiontext := Caption ;

    end;
    Procedure Setnumerique( num : Boolean)
    begin 
     Numerique := Num ;

    end;
    Procedure SetView ( ITemTemp :Record Item temporary)
    begin 
/* 
          Rec.Copy(ItemTemp);
          //Itemtemp.findfirst;
          REc.findfirst;
          repeat
          rec:=itemtemp;
          Rec.Insert();
          until rec.Next()=0 ; */
    end;



    var 
    Captiontext : text ;
    Numerique : Boolean ;

   
    }
       
   

       

        
      
    



  

