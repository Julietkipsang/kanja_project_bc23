page 50018 "Change Entity Subscripted"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = EntitySubscripted;
    // DeleteAllowed = false;
    Editable = true;


    layout
    {
        area(Content)
        {
            repeater("")
            {

                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Caption = 'Service Type';
                    trigger OnValidate()
                    var
                        ServiceType: Record "Services Type";
                    begin
                        if ServiceType.Get(Rec."Account Type") then
                            if ServiceType.Active = false then
                                Error('The service is Not active');
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(oldStatus; Rec.oldStatus)
                {

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(oldMinimumAmount; Rec.oldMinimumAmount)
                {

                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field(oldMaximumAmount; Rec.oldMaximumAmount)
                {

                }

                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field(oldMaximumDaily; Rec.oldMaximumDaily)
                {

                }

                field("Maximum Daily"; Rec."Maximum Daily")
                {
                    ApplicationArea = All;
                }

            }
        }
        // area(Factboxes)
        // {

        // }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    trigger
    OnNewRecord(BelowxRec: Boolean)
    begin
        if rec."Application No." = '' then begin
            Rec.EntityNo := xRec.EntityNo;
            Rec."Account Type" := xRec."Account Type";
            Rec.Description := xRec.Description;
            Rec."Application No." := xRec."Application No.";
            Rec.Insert();
        end;

    end;

}