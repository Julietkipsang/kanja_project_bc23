page 50032 "FintechList"
{
    // version TL2.0

    Caption = 'Fintech List';
    //CardPageID = "Organization  Card";
    PageType = ListPart;
    //PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Comments,Category 7,Category 8';
    SourceTable = Fintechs;

    // Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(fintechCode; Rec.fintechCode)
                {
                    ApplicationArea = all;
                }
                field(FintechName; Rec.FintechName)
                {
                    ApplicationArea = all;
                }
                field("Fintech Type"; Rec."Fintech Type")
                {


                }
                field(receiveDeposit; Rec.receiveDeposit)
                {

                    ApplicationArea = all;
                    trigger
                    OnValidate()
                    begin
                        //count := 0;
                        if Rec."Fintech Type" = Rec."Fintech Type"::Cbs then begin
                            IF Rec.receiveDeposit = true then begin
                                Error('CBS cannot receive deposit');
                            end;
                        end;
                        IF Rec.receiveDeposit = true then begin
                            // saccpAppl.Reset();
                            // count := 0;
                            count += 1;
                            // until 
                        END else begin
                            count := 0;
                        end;
                        //  Message('%1', count);
                        if count > 1 then begin
                            Error('Can allow one for deposit');
                        end;
                        if Rec.receiveDeposit = true then begin
                            saccpAppl.Reset();
                            saccpAppl.SetRange("No.", Rec.applNo);
                            if saccpAppl.FindFirst() then begin
                                saccpAppl."Fintech Account" := Rec.fintechCode;
                                saccpAppl."Fintech Name" := Rec.FintechName;
                                saccpAppl.Modify();
                            end;
                        end;


                    end;

                }

            }
        }
    }

    actions
    {
        area(processing)
        {


        }
        // area(navigation)
        // {


        // }
    }

    var
        //ApprovalsMgmt: Codeunit "1535";
        ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalComments: Page "Approval Comments";
        Allow: Boolean;
        count: Integer;
        saccpAppl: Record "Sacco Application";


}

