namespace BSPCloud.BSPCloud;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;

tableextension 50098 MyItemExt extends "My Item"
{
    fields
    {
        /* field(50000;"Item Origin"; Code[200])
        {
            Caption = 'Origine parent';
            DataClassification = ToBeClassified;
        } */
        field(50001;"Mode de calcul VMJ"; Option)
        {  
             Caption = 'Mode de calcul VMJ';
            DataClassification = ToBeClassified;
              OptionMembers = "","VMJ stock disponible","VMJ sur période"; 
                  trigger OnValidate()
                    var
                        item: Record item;
                    begin
                        item.get(rec."Item No.");

                        Ecoulement :=CalculEcoulement(datedebut, datefin,"Mode de calcul VMJ", true);
                        "Qté à commander" :=CalcRecommandation(datedebut, datefin,"Mode de calcul VMJ");
                        Modify();


                    end; 
        }
           field(50002;Ecoulement; decimal)
        {  
             Caption = 'Écoulement';
            DataClassification = ToBeClassified;
            editable = false ;
               
        }
          field(50003;"Couverture demandée"; decimal)
        {  
             Caption = 'Couverture demandée';
            DataClassification = ToBeClassified;
        }
         field(50004;"Qté à commander"; decimal)
        {  
             //Caption = '';
            DataClassification = ToBeClassified;
            editable= false ;      
        }
           field(50005;"Qté à confirmer"; decimal)
        {  
             //Caption = '';
            DataClassification = ToBeClassified;      
        }
           field(50006;"Qté sur commande vente"; decimal)
        {  
             //Caption = '';
           

           /*   CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                            Type = const(Item),
                                                                            "No." = field("Item No.")
                                                                           ));
            /*/
            //Caption = 'Qty. on Sales Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
         }
       field(50007;"Qté sur commande achat"; decimal)
        {
       //    CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
         //                                                                      Type = const(Item),
//                                                                               "No." = field("Item No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
      //      FieldClass = FlowField;    

        }
          field(50008;"Dérnier prix"; decimal)
        {  
             //Caption = '';
            DataClassification = ToBeClassified; 
            editable = false ;     
        } 
        /* field(50009;Montant ; decimal ) 
        {

        } */

         field(50009;"Stock prévisionnel"; decimal)
        {  
             //Caption = '';
            DataClassification = ToBeClassified; 
            editable = false ;     
        } 
          field(50010;"VMJ / Période"; decimal)
        {  
             //Caption = '';
            DataClassification = ToBeClassified;      
        } 
        field(50011;"VMJ / Stock"; decimal)
        {  
             //Caption = '';
            DataClassification = ToBeClassified;      
        } 
        field(50012;"datedebut"; Date)
        {}
        
        field(50013;"datefin"; Date)
        {}
         field(50014;"Quantité en stock"; decimal)
        {}
        
        
        
    }
    trigger OnInsert() var item : record Item ; begin

          
          "Dérnier prix" := "DernierPrixProposé"();
          /*  "VMJ / Période":= CalculVMJ(datedebut,datefin,true) ;
          "VMJ / Stock":= CalculVMJEffective(datedebut,datefin,true);
           Ecoulement := CalculEcoulement(datedebut,datefin,"Mode de calcul VMJ",true);
        
            "Qté à commander":=CalcRecommandation(datedebut,datefin,"Mode de calcul VMJ")
 */   
    /*  item.get("Item No.");
     item.CalcFields("Qty. on Sales Order","Qty. on Purch. Order",Inventory);
"Qté sur commande vente" := item."Qty. on Sales Order" ;
"Qté sur commande achat":=item."Qty. on Purch. Order" ;
"Quantité en stock" := item.Inventory ; */


           
    end;
   

      procedure CalculVMJ(Datefirst: Date; Datelast: Date): decimal
    var
        item: record item;
        ILE: record "Item Ledger Entry";
        /* Datefirst: Date;
        Datelast: Date; */
        VMJ: decimal;
        int: integer;
    begin
         ILE.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        
        ILE.setrange("Item No.", "Item No."); 
        ILE.setrange("Entry Type", "Item Ledger Entry Type"::Sale);
        ILE.setrange("Posting Date", Datefirst, Datelast);
       
        if Ile.findfirst() then begin
            // Datefirst := ILE."Posting Date";
            // ILE.FindLast();
            // Datelast := ILE."Posting Date";
            ILE.CalcSums(Quantity);
            VMJ :=  -ILE.Quantity / (Datelast - Datefirst + 1);
            exit(VMJ);
        end
        else
            exit(0);
    end;
    procedure CalculVMJEffective(DateDebut: Date; DateFin: Date)  CMJ: decimal;

    var
        NJ: Decimal;
        NJR: Decimal;
        QtéVendue: Decimal;
        DDV: date;
        ILE: record "Item Ledger Entry";
        D0: date;
        Item: record item;
        ItemSold: record item;
        // CalendarMgmt: Codeunit "Calendar Management";
        NJ_Repos: integer;
       
        // cal: record "Base Calendar";
        // baseCal: Record "Customized Calendar Change";
        location: record Location;

    begin
        NJ := 0;   // Dispo
        NJR := 0; // Rupture
        QtéVendue := 0;
        DDV := 0D;
        if DateDebut = 0D then exit(0);

        ILE.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        
        ILE.SETFILTER("Item No.", "Item No.");
        ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
        ILE.SETCURRENTKEY("Item No.", "Posting Date");
        ILE.SETRANGE("Posting Date", DateDebut, DateFin);
        ILE.CalcSums(Quantity) ;
        QtéVendue -= ILE.Quantity;

      //  if "Item No." = '2630002752' then 
        //Message('%1',QtéVendue);

        ILE.SetRange(Positive,false);
        if ILE.FindLast() then //Eviter les cas de retour ou avoir ou annulation de BL
        DDV := ILE."Posting Date"; 
    
        ItemSold.GET("Item No.");

         D0 := DateDebut;
        REPEAT
            ItemSold.SETRANGE("Date Filter", D0); 
            ItemSold.Calcfields("Sold (Qty.)");
  //                  if "Item No." = '2630002752' then 
//Message(ItemSold.getfilters);
if ItemSold."Sold (Qty.)" > 0 then   begin
 NJ  += 1 ;
  //  Message('sold %1  NJ %2',ItemSold."Sold (Qty.)",NJ);

end

 else begin
            Item.GET("Item No.");
            Item.SETRANGE("Date Filter", 0D, D0);
            Item.CALCFIELDS("Net Change");
            IF  Item."Net Change" > 0 then 
             NJ  += 1
 end;     
            D0 := CALCDATE('<1D>', D0);  
         UNTIL D0 = DateFin;

      //  if "Item No." = '2630002752' then 
         IF (NJ) <> 0 THEN
            CMJ := QtéVendue / NJ;


        exit(CMJ);

    end;




     procedure CalculEcoulement(Datefirst: Date; Datelast: Date; Methode_calculVMJ: option "","VMJ Effective","VMJ sur période"; BoolCalcul: Boolean): decimal
     begin
        if BoolCalcul = false then exit(0);
       // item.get("Item No.");
        //item."Location Filter" := '';
       // CalcFields("Qté sur commande achat","Qté sur commande vente", Inventory);
        if Methode_calculVMJ = 0 then exit(0);
        if Methode_calculVMJ = Methode_calculVMJ::"VMJ sur période" then begin
            if "VMJ / Période" <> 0 then begin
                //exit((Inventory -"Qté sur commande vente") / "VMJ / Période");
                exit(("Quantité en stock" -"Qté sur commande vente") / "VMJ / Période");
            end
            else
                exit(0);
        end
        else begin
            if "VMJ / Stock" <> 0 then begin
               // exit((Inventory - "Qté sur commande vente") / "VMJ / Stock");
               exit(("Quantité en stock" - "Qté sur commande vente") / "VMJ / Stock");
            end
            else
                exit(0);
        end;




    end;


     procedure CalcRecommandation(Datefirst: Date; Datelast: Date; Methode_calculVMJ: option "","VMJ Effective","VMJ sur période"): decimal;
    var
        Recommandation: decimal;
        CD: DateFormula;
        item : Record item ;

    begin 
        //item.get("Item No.");
    // CalcFields("Qté sur commande achat","Qté sur commande vente", Inventory);
        if "Couverture demandée" = 0 then exit(0);
        if Methode_calculVMJ = 0 then exit(0);

        if Methode_calculVMJ = Methode_calculVMJ::"VMJ sur période" then begin
            if "VMJ / Période" <> 0 then
                Recommandation := Round(((("Couverture demandée") - Ecoulement) *"VMJ / Période"  - "Qté sur commande achat"), 1, '>');


            if Recommandation > 0 then begin
                "Qté à commander" := Recommandation;
               // Rec.Modify(false);

                exit(Recommandation)
            end
            else begin
                "Qté à commander" := -1;
                //Rec.Modify(false);


                exit(-1)
            end;

        end
        else begin
            if "VMJ / Stock" <> 0 then
                Recommandation := Round(((("Couverture demandée") -Ecoulement) * "VMJ / Stock" - "Qté sur commande vente"), 1, '>');


            if Recommandation > 0 then begin
                "Qté à commander" := Recommandation;
           //     Rec.Modify(false);

                exit(Recommandation)
            end else begin
                "Qté à commander" := -1;
               // Rec.Modify(false);


                exit(-1)
            end;

        end;




    end;


Procedure DernierPrixProposé(): decimal
    var
        OffrePrix: Record "Offre de prix ";
    begin
        OffrePrix.SetCurrentKey("Item No.", "Date", Price);
        OffrePrix.setrange("Item No.", "Item No.");
        if OffrePrix.findlast then
            exit(OffrePrix.Price)
        else
            exit(0);

    end;




}
