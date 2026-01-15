namespace TopEtanch.TopEtanch;

using Microsoft.Inventory.Item;
using BCSPAREPARTS.BCSPAREPARTS;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item.Catalog;

page 50178 "Recommandation Achats"
{
    ApplicationArea = All;
    Caption = 'Recommandation Achats';
    PageType = Worksheet;
    SourceTable = "My Item";
    UsageCategory = Tasks;
    InsertAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = true;
    SourceTableTemporary = true;

    layout
    {

        area(Content)
        {
            group(Période)
            {
                Caption = 'Période de calcul';

                field("date début"; "date début")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;

                }

                field("date fin"; "date fin")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;

                }
            }

            group(Filtres)
            {
                field(Fournisseur; Fournisseur)
                {
                    ShowMandatory = true;
                    ApplicationArea = all;
                    TableRelation = Vendor;



                }
                field(Désignation; FiltrerDescription)
                {
                    ShowMandatory = true;
                    ApplicationArea = all;
                }

                field(Item_Category; Item_Category)
                {
                    ApplicationArea = all;
                    TableRelation = "Item Category";
                    Caption = 'Catégorie article';
                    ShowMandatory = true;
                }
                field(Fabricant; FilterFabricant)
                {
                    ApplicationArea = all;
                    TableRelation = Manufacturer;
                    ShowMandatory = true;
                }
            }
            group("Option")
            {

                field(Methode_calculVMJ; Methode_calculVMJ)
                {
                    ApplicationArea = all;
                    Caption = 'Base de calcul recommandation achat';
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        recmyitem: record "My Item" temporary;
                        PlanMGT: Codeunit "Planning managment";
                    begin
                        /*  if BoolCalcul then
                             BoolCalcul := false; */
                        // CurrPage.update();
                        // CurrPage.GetRecord(recmyitem);
                        // Pagerecord.Copy(Rec);
                        /*  Message('%1',Pagerecord.Count);
                          if Pagerecord.Findset() then 
                          repeat 
                          Pagerecord.validate("Mode de calcul VMJ",Methode_calculVMJ);
                          Pagerecord.Modify(false);
                          until Pagerecord.next=0 ;

   */                 // updateMethodeCalcul();
                      //rec.ModifyAll("Mode de calcul VMJ",Methode_calculVMJ,true);
                      // CurrPage.SetRecord(Pagerecord);
                      /*  rec.Validate("Mode de calcul VMJ",Methode_calculVMJ);
                       rec.modify(false); */
                        if rec.Findset() then
                            repeat
                                PlanMGT.updateMethodeCalcul(Rec, Methode_calculVMJ);
                            until Rec.next = 0;
                        //CurrPage.update; */
                        if rec.FindFirst() then;

                    end;
                }
                field(OptionsAchat; OptionsAchat)
                {
                    ApplicationArea = all;
                    Caption = 'Type document achat';

                }

            }

            repeater(General)
            {
                Caption = 'General';


                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the item numbers that are displayed in the My Item Cue on the Role Center.';
                    Editable = false;

                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item.';
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the item''s unit price.';
                }
                field(Stock; Rec."Quantité en stock")
                {
                    ToolTip = 'Specifies the inventory quantities of my items.';
                    DecimalPlaces = 0 : 3;
                }
                /*  field("Item Origin"; Rec."Item Origin")
                 {
                     ToolTip = 'Specifies the value of the Origine parent field.', Comment = '%';
                     editable = false;
                 } */
                field("Mode de calcul VMJ"; Rec."Mode de calcul VMJ")
                {
                    ToolTip = 'Specifies the value of the Mode de calcul VMJ field.', Comment = '%';
                    trigger OnValidate()
                    var
                        item: Record item;
                    begin
                        item.get(rec."Item No.");

                        rec.Ecoulement := rec.CalculEcoulement("date début", "date fin", Rec."Mode de calcul VMJ", true);
                        rec."Qté à commander" := rec.CalcRecommandation("date début", "date fin", rec."Mode de calcul VMJ");
                        rec.Modify();


                    end;
                }
                field("VMJ / Période"; rec."VMJ / Période")
                {
                    Editable = false;
                }
                field("VMJ / Stock"; rec."VMJ / Stock")
                {

                    editable = false;
                }
                field(Ecoulement; Rec.Ecoulement)
                {
                    ToolTip = 'Specifies the value of the Écoulement field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Couverture demandée"; Rec."Couverture demandée")
                {
                    ToolTip = 'Specifies the value of the Couverture field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                    trigger OnValidate()
                    var
                    begin
                        rec."Qté à commander" := rec.CalcRecommandation("date début", "date fin", rec."Mode de calcul VMJ");

                    end;
                }

                field("Qté sur commande vente"; Rec."Qté sur commande vente")
                {
                    ToolTip = 'Specifies the value of the Qté sur commande vente field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Qté sur commande achat"; Rec."Qté sur commande achat")
                {
                    ToolTip = 'Specifies the value of the Qté sur commande achat field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("lignes demandes prix"; rec."lignes demandes prix")
                {

                }
                field("Qté à commander"; Rec."Qté à commander")
                {
                    ToolTip = 'Specifies the value of the Qté à commander field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Qté à confirmer"; Rec."Qté à confirmer")
                {
                    ToolTip = 'Specifies the value of the Qté à confirmer field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Dérnier prix"; Rec."Dérnier prix")
                {

                    ApplicationArea = all;
                    DecimalPlaces = 0 : 3;
                    Caption = 'Dérnier prix proposé';
                    editable = false;

                    trigger OnDrillDown()
                    var
                        OffrePrix: Record "Offre de prix ";
                        OffrePrixPage: page "Offre de prix";
                    begin
                        OffrePrix.setrange("Item No.", rec."Item No.");
                        OffrePrix.setfilter(Date, '>%1', CalcDate('<-1Y>', Today));
                        OffrePrixPage.SetTableView(OffrePrix);
                        OffrePrixPage.RunModal();

                    end;


                }
                field(Montant; Rec."Dérnier prix" * rec."Qté à confirmer")
                {
                    ToolTip = 'Specifies the value of the Montant field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
            }
            /*   part(ItemOrigin; "Item Part") {
                  Caption='Articles similaires' ; 
              Editable = false;
              SubPageLink = "Item Origin" = field("Item Origin");
              UpdatePropagation= both ; 

          } */

        }

    }
    actions
    {

        area(Processing)
        {

            action("Calculer articles")
            {
                ApplicationArea = all;
                Visible = true;
                trigger OnAction()
                var
                    item: record item;
                    itemCategory: record "Item Category";
                    TextuserID: text;
                    Dialog: Dialog;
                    TotalCount: Integer;
                    CurrentCount: Integer;
                    ProgressBar: Text;
                    ProgressPct: Integer;
                    ProgressBlocks: Integer;
                    PlanMNG: codeunit "Planning managment";
                    Myitem: record "My Item" temporary;
                begin

                    if not rec.IsEmpty then
                        if not Confirm('Cette action supprimera les données déjà calculées. Voulez-vous continuer ?') then
                            exit;


                    if ("date début" = 0D) or ("date fin" = 0D) or ("date début" > "date fin") then
                        error('Erreur au niveau des dates !!!');

                    if Methode_calculVMJ = Methode_calculVMJ::" " then
                        error('veuillez spécifier la méthode de calcul des ventes moyennes');


                    if (FilterFabricant + Fournisseur + FiltrerDescription + Item_Category + FilterMarque + FilterOrigine = '') and (DateDerniereSortie = 0D) then
                        Error('Vous devez au moins sélectionner un filtre ... Fabricant,Fournisseur,Description ou Categorie');

                    rec.DeleteAll();
                    TextuserID := UserId();
                    item.SetLoadFields("Search Description", "Vendor No.", "Item Category Code", "Manufacturer Code", "Qty. on Sales Order", "Qty. on Purch. Order", Inventory, "Couverture demandée", "Mode de calcul VMJ");


                    if DateDerniereSortie <> 0D then begin // Derniere Sortie
                        PlanMNG.getItemNoFilterFromDerniereDateSortie(DateDerniereSortie);
                        Item.SetCurrentKey("No.");
                        item.SetFilter("No.", PlanMNG.getItemNoFilterFromDerniereDateSortie(DateDerniereSortie));

                    end;
                    if FiltrerDescription <> '' then begin
                        item.SetCurrentKey("Search Description");
                        item.SetFilter("Search Description", FiltrerDescription);
                    end;
                    if Fournisseur <> '' then begin
                        item.SetCurrentKey("Vendor No.");
                        item.setrange("Vendor No.", Fournisseur);
                    end;
                    if Item_Category <> '' then begin
                        //   item.SetCurrentKey(key) //key to be added in Item table extention
                        item.setrange("Item Category Code", Item_Category);
                    end;
                    If FilterFabricant <> '' then begin
                        item.setfilter("Manufacturer Code", FilterFabricant)
                    end;
                    /*    If FilterMarque <> '' then begin
                           item.setrange(Marque, FilterMarque);
                       end;
                       If FilterOrigine <> '' then begin
                           item.setrange("Item Origin", FilterOrigine);
                       end; */


                    item.SetAutoCalcFields("Qty. on Sales Order", "Qty. on Purch. Order", Inventory, "lignes demandes prix");


                    if item.FindSet() then begin
                        TotalCount := Item.Count;
                        CurrentCount := 0;

                        // Ouvre une fenêtre avec une "barre" simulée
                        Dialog.Open('Traitement en cours : \n#1#####################');
                        repeat
                            rec.init();
                            rec."User ID" := TextuserID;
                            rec.Validate("Item No.", item."No.");
                            rec."Couverture demandée" := item."Couverture demandée";
                            // rec."Item Origin" := item."Item Origin";
                            if item."Mode de calcul VMJ" <> item."Mode de calcul VMJ"::" " then
                                rec."Mode de calcul VMJ" := item."Mode de calcul VMJ"
                            else
                                rec."Mode de calcul VMJ" := Methode_calculVMJ;
                            rec."datedebut" := "date début";
                            rec."datefin" := "date fin";

                            rec."Qté sur commande achat" := Item."Qty. on Purch. Order";
                            rec."Qté sur commande vente" := Item."Qty. on Sales Order";
                            rec."lignes demandes prix" := item."lignes demandes prix";
                            rec."Quantité en stock" := item.Inventory; // 180825
                            rec."Stock prévisionnel" := Item.Inventory + rec."Qté sur commande achat" - rec."Qté sur commande vente";

                            if rec.insert(true) then;
                            CurrentCount += 1;
                            ProgressPct := Round(CurrentCount * 100 / TotalCount) DIV 1;
                            ProgressBlocks := ProgressPct div 2; // 50 blocs max pour simuler

                            // Construction de la "barre"
                            ProgressBar := StringOfChar('|', ProgressBlocks) + StringOfChar('.', 50 - ProgressBlocks);
                            ProgressBar := ProgressBar + ' ' + Format(ProgressPct) + '%';

                            Dialog.Update(1, ProgressBar);




                        until item.next = 0;
                        Dialog.Close();
                    end;

                    /* rec.reset(); 
                    rec.FindFirst() ; 
                              repeat 
                             rec."VMJ / Période":= rec.CalculVMJ("date début","date fin",true) ;
                              rec."VMJ / Stock":= rec.CalculVMJEffective("date début","date fin",true);
                              rec.Ecoulement := rec.CalculEcoulement("date début","date fin",rec."Mode de calcul VMJ",true);
                               rec."Qté à commander":=rec.CalcRecommandation("date début","date fin",rec."Mode de calcul VMJ");
                               rec.Modify();
                               until rec.next =0 ;
                    */

                    //    CurrPage.Update();
                    Message('Importation terminée');
                    if Rec.FindFirst() then;
                end;

            }
            action("Calculer Ecoulement & recommandation")
            {
                ApplicationArea = all;
                Visible = true;
                trigger OnAction()
                var

                // PlanMNG : codeunit "Planning managment";
                begin

                    /*  rec.FindFirst();

                     repeat

                      PlanMNG.Execute(rec);
                     until rec.next = 0; */
                    CalcEcoulementProgress();

                    Message('Traitement terminé');
                    if Rec.FindFirst() then CurrPage.Update();
                end;

            }
            Action("Copier les quantitées")
            {
                ApplicationArea = all;
                Visible = true;
                trigger OnAction()
                var
                // rec: Record "My Item" temporary ;
                begin
                    //rec.setrange("User ID", UserId);
                    //rec.setfilter("Qté à commander",'>%1',0);
                    if rec.Findset() then
                        repeat
                            rec."Qté à confirmer" := rec."Qté à commander";
                            rec.Modify();
                        until rec.next = 0
                    else
                        error('il n''y a rien à copier');


                    if Rec.FindFirst() then;
                end;
            }
            action("Créer document d'achat")
            {
                ApplicationArea = All;
                Image = Create;

                Visible = true;
                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    PurchLine: Record "Purchase Line";
                    Item: Record Item;
                    Type: Enum "Purchase Document Type";
                    LineNo: Integer;
                    QuantitéRecommandée: Decimal;
                    ADesLignes: Boolean;
                begin


                    if Fournisseur = '' then error('Veuillez choisir le un fournisseur');

                    case OptionsAchat of
                        OptionsAchat::"Demande de prix":
                            Type := Type::Quote;
                        OptionsAchat::"Commande achat":
                            Type := Type::Order;
                    end;

                    ADesLignes := false;
                    LineNo := 10000;

                    //  if Item.FindFirst() then
                    rec.setfilter("Qté à confirmer", '> %1', 0);
                    if rec.FindFirst() then
                        repeat
                            // Item.CalcFields("lignes demandes prix");

                            if (Rec."lignes demandes prix" = 0) or (OptionsAchat = OptionsAchat::"Commande achat") then begin
                                // QuantitéRecommandée := rec.CalcRecommandation("date début", "date fin", Methode_calculVMJ);
                                if rec."Qté à confirmer" > 0 then begin
                                    if not ADesLignes then begin
                                        PurchHeader.Init();
                                        PurchHeader."Document Type" := Type;
                                        PurchHeader.Insert(true);
                                        PurchHeader.Validate("Buy-from Vendor No.", Fournisseur);
                                        PurchHeader.Modify(true);
                                        ADesLignes := true;
                                    end;

                                    PurchLine.Init();
                                    PurchLine."Document Type" := Type;
                                    PurchLine."Document No." := PurchHeader."No.";
                                    PurchLine."Line No." := LineNo;
                                    PurchLine.Validate(Type, PurchLine.Type::Item);
                                    PurchLine.Validate("No.", rec."Item No.");
                                    PurchLine.Validate(Quantity, rec."Qté à confirmer");
                                    PurchLine.Insert(true);
                                    LineNo += 10000;
                                end;
                            end;
                        until rec.Next() = 0;

                    if ADesLignes then begin
                        Message('Document %1 %2 créé avec succès.', PurchHeader."Document Type", PurchHeader."No.");

                        case Type of
                            Type::Quote:
                                Page.Run(Page::"Purchase Quote", PurchHeader);
                            Type::Order:
                                Page.Run(Page::"Purchase Order", PurchHeader);
                        end;
                    end else
                        Message('Aucune ligne trouvée');

                    if Rec.FindFirst() then;
                end;
            }



        }
    }
    trigger OnOpenPage()
    begin
        Methode_calculVMJ := Methode_calculVMJ::"VMJ stock disponible";

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var

    begin
        if not Confirm('Cette action supprimera les données déjà calculées. Voulez-vous continuer ?', false) then
            Error('Fermeture annulée...');

        rec.DeleteAll();

    end;
    /*  trigger OnModifyRecord(): Boolean
     var begin 
         if xRec."Mode de calcul VMJ"<> rec."Mode de calcul VMJ" then 
         rec.validate("Mode de calcul VMJ",Methode_calculVMJ) ;

     end; */
    local procedure CalcEcoulementProgress()



    var
        Dialog: Dialog;
        TotalCount: Integer;
        CurrentCount: Integer;
        ProgressBar: Text;
        ProgressPct: Integer;
        ProgressBlocks: Integer;
        PlanMNG: codeunit "Planning managment";
    begin

        // Initialiser();

        /*   rec.SetAutoCalcFields(Inventory);
          Rec.SetFilter(Inventory, '>0'); */


        if Rec.FindSet then begin
            TotalCount := Rec.Count;
            CurrentCount := 0;

            // Ouvre une fenêtre avec une "barre" simulée
            Dialog.Open('Traitement en cours :\n#1#####################');

            repeat

                PlanMNG.ExecuteEcoulement(rec);


                CurrentCount += 1;
                ProgressPct := Round(CurrentCount * 100 / TotalCount) DIV 1;
                ProgressBlocks := ProgressPct div 2; // 50 blocs max pour simuler

                // Construction de la "barre"
                ProgressBar := StringOfChar('|', ProgressBlocks) + StringOfChar('.', 50 - ProgressBlocks);
                ProgressBar := ProgressBar + ' ' + Format(ProgressPct) + '%';

                Dialog.Update(1, ProgressBar);
            until Rec.Next() = 0;


            Dialog.Close();

        end;
    end;

    local procedure StringOfChar(Char: Char; Count: Integer): Text
    var
        Result: Text;
        i: Integer;
    begin
        for i := 1 to Count do
            Result += Format(Char);
        exit(Result);
    end;

    local procedure updateMethodeCalcul()
    begin
        if Rec.FindSet then
            repeat
                rec.Validate("Mode de calcul VMJ", Methode_calculVMJ);
            until Rec.Next() = 0;
    end;



    var
        OptionsAchat: Option "Demande de prix","Commande achat";
        FilterFabricant, Fournisseur, FiltrerDescription, Item_Category, FilterMarque, FilterOrigine : code[50];

        Methode_calculVMJ: option " ","VMJ stock disponible","VMJ sur période";
        "date fin", "date début", DateDerniereSortie : Date;
        Pagerecord: record "My Item" temporary;
}
