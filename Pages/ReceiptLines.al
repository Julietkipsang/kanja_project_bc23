page 50061 "Receipt Lines"
{
    // version TL2.0
    Caption = 'Receipt Lines';
    PageType = ListPart;
    SourceTable = "Payment/Receipt Lines";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Type"; rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; rec."Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Applies to Doc. No"; rec."Applies to Doc. No")
                {
                    ApplicationArea = All;
                }
                field("External Document No"; rec."External Document No")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Amount; rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }

                field("Net Amount"; rec."Net Amount")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {


        }
    }

    trigger OnAfterGetRecord();
    begin
        //AssistEdit := 'Add W/Tax On Payments';
    end;

    var
        // CashMngt: Codeunit "Cash Management";
        AssistEdit: Code[40];

}

