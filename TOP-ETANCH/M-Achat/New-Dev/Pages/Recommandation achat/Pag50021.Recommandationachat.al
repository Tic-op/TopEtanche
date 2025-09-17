namespace TopEtanch.TopEtanch;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;

page 50121 "Recommandation Achat"
{
    ApplicationArea = All;
    Caption = 'Recommandation Achat';
    PageType = Worksheet;
    SourceTable = Item;
    UsageCategory = Tasks;
    // SourceTableView = where(ItemNo = filter(<> ''));
    DeleteAllowed = false;
    SaveValues = true;
    InsertAllowed = false;
    ShowFilter = true;




    layout
    {
        area(Content)
        {
            group(Période)
            {
                Caption = 'Période de calcul';

                field("date début"; "date début")
                {
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        if BoolCalcul then
                            BoolCalcul := false;
                        CurrPage.Update();

                    end;
                }

                field("date fin"; "date fin")
                {
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        if BoolCalcul then
                            BoolCalcul := false;
                        CurrPage.Update();

                    end;
                }
            }
            group(Filtres)
            {
                field(Fournisseur; Fournisseur)
                {
                    TableRelation = Vendor;
                    trigger OnValidate()
                    begin
                        if Fournisseur <> '' then
                            rec.SetFilter("Vendor No.", Fournisseur) else
                            rec.SetFilter("Vendor No.", '*');
                        if BoolCalcul then
                            BoolCalcul := false;
                        CurrPage.Update();


                    end;
                }
                field(Item_Category; Item_Category)
                {
                    TableRelation = "Item Category";
                    Caption = 'Catégorie article';
                    trigger OnValidate()
                    begin
                        if Item_Category <> '' then
                            rec.SetFilter("Item Category Code", Item_Category)
                        else
                            rec.SetFilter("Item Category Code", '*');
                        if BoolCalcul then
                            BoolCalcul := false;
                        CurrPage.update();

                    end;
                }


            }
            group("Option")
            {

                field(Methode_calculVMJ; Methode_calculVMJ)
                {
                    Caption = 'Base de calcul recommandation achat';
                    trigger OnValidate()
                    begin
                        /*  if BoolCalcul then
                             BoolCalcul := false; */
                        CurrPage.update();
                    end;
                }
                field(OptionsAchat; OptionsAchat)
                {
                    Caption = 'Type document achat';

                }


            }


            repeater(General)
            {
                field(ItemNo; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the ItemNo field.', Comment = '%';
                }
                field("Couverture demandée"; rec."Couverture demandée")

                {
                    Caption = 'Couverture demandée (en jours)';
                    //ToolTip = 'Specifies the value of the Couverture demandée field.', Comment = '%';
                    // DecimalPlaces = 3 : 0;
                }
                field(Stock; Rec.Inventory)
                {
                    Caption = 'Stock';
                    //ToolTip = 'Specifies the value of the Stock field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field(VMJ; rec.CalculVMJ("date début", "date fin", BoolCalcul))
                {
                    // ToolTip = 'Specifies the value of the VMJ field.', Comment = '%';
                    Caption = 'Vente moyenne journalière sur période';
                    DecimalPlaces = 0 : 3;
                }
                Field(CalculVMJEffective; Rec.CalculVMJEffective("date début", "date fin", BoolCalcul))
                {
                    caption = 'Vente moyenne journalière sur stock disponible';

                    DecimalPlaces = 0 : 3;

                }
                field(Ecoulement; Rec.CalculEcoulement("date début", "date fin", Methode_calculVMJ, BoolCalcul))
                {
                    // ToolTip = 'Specifies the value of the Ecoulement field.', Comment = '%';
                    DecimalPlaces = 0 : 3;
                }
                field("Qté sur commande vente"; Rec."Qty. on Sales Order")
                {
                    ToolTip = 'Specifies the value of the Qté sur commande vente field.', Comment = '%';

                }
                field("Qté sur commande achat"; Rec."Qty. on Purch. Order")
                {
                    ToolTip = 'Specifies the value of the Qté sur commande achat field.', Comment = '%';

                }
                field("lignes demandes prix"; Rec."lignes demandes prix")
                {
                    ApplicationArea = all;

                }
                field("Recommandation achat"; Rec.CalcRecommandation("date début", "date fin", Methode_calculVMJ))
                {
                    // ToolTip = 'Specifies the value of the Recommandation achat field.', Comment = '%';
                    DecimalPlaces = 0 : 0;
                }
            }


        }



    }

    actions
    {
        area(Processing)
        {
            /*  action("supprimer demande")
             {
                 ApplicationArea = All;
                 Image = Approve;

                 trigger OnAction()
                 var
                     PBA: Record "Recommandation Achat";
                     item: record item;
                 begin
                     item.FindFirst();
                     item.ModifyAll("Couverture demandée", 00);


                     PBA.DeleteAll();
                 end;
             } */

            action("Calculer les ventes moyenne journalières")
            {
                ApplicationArea = All;
                Image = Approve;
                trigger OnAction()
                var
                    item: record Item;
                begin

                    /* 
                                        item.SetFilter("Location Filter", '');
                                        item.SetAutoCalcFields(Inventory);
                                        item.findfirst();
                                        repeat

                                            //   if item.Inventory > 0 then begin

                                            PBA.init();
                                            PBA.ItemNo := item."No.";
                                            PBA.insert();

                                        // end


                                        until item.Next() = 0; */


                    if ("date début" = 0D) or ("date fin" = 0D) then
                        error('date vide !!!');

                    /* item.get(rec."No.");

                     if Methode_calculVMJ = Methode_calculVMJ::"VMJ sur période" then
                         VMJ := item.CalculVMJ("date début", "date fin") else
                         VMJ := item.CalculVMJEffective("date début", "date fin"); */
                    BoolCalcul := true;



                end;



            }

            action("Créer document d'achat")
            {
                ApplicationArea = All;
                Image = Create;

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

                    case OptionsAchat of
                        OptionsAchat::"Demande de prix":
                            Type := Type::Quote;
                        OptionsAchat::"Commande achat":
                            Type := Type::Order;
                    end;

                    ADesLignes := false;
                    LineNo := 10000;

                    if Item.FindFirst() then
                        repeat
                            Item.CalcFields("lignes demandes prix");

                            if Item."lignes demandes prix" = 0 then begin
                                QuantitéRecommandée := Item.CalcRecommandation("date début", "date fin", Methode_calculVMJ);
                                if QuantitéRecommandée > 0 then begin
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
                                    PurchLine.Validate("No.", Item."No.");
                                    PurchLine.Validate(Quantity, QuantitéRecommandée);
                                    PurchLine.Insert(true);
                                    LineNo += 10000;
                                end;
                            end;
                        until Item.Next() = 0;

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
                end;
            }


        }

    }

    trigger OnOpenPage()
    var
        item: record Item;
    begin
        /*  item.setrange("Vendor No.", '');
          item.setrange("Item Category Code", '');

          CurrPage.SetTableView(item);  */

        BoolCalcul := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        item: record item;
    begin
        //CurrPage.GetRecord(item);
        item.FindFirst();
        repeat
            item."Couverture demandée" := 0;
            item.modify;
        until item.next = 0;

    end;



    var
        "date début": Date;
        "date fin": Date;
        Fournisseur: code[20];
        Item_Category: code[20];
        Methode_calculVMJ: option "VMJ stock disponible","VMJ sur période";

        VMJ: Decimal;
        BoolCalcul: Boolean;
        OptionsAchat: Option "Demande de prix","Commande cadre achat","Commande achat";




}

