page 50056 "Posted Payment Voucher"
{
    // version TL2.0

    CardPageID = "Payment Vouchers";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Payment/Receipt Voucher";
    SourceTableView = WHERE(Status = CONST(Released),
                            Posted = CONST(true),
                           "Line type" = CONST(Payment));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Paying Code."; rec."Paying Code.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Description';
                }
                field("Payment Date"; rec."Payment Date")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Payment Mode"; rec."Payment Mode")
                {
                    ApplicationArea = All;
                }
                field("Paying Bank"; rec."Paying Bank")
                {
                    ApplicationArea = All;
                }
                field("Paying/Receiving Bank Name"; rec."Paying/Receiving Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Paying Bank Name';
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Created By"; rec."Created By")
                {
                    ApplicationArea = All;
                }
               
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        CurrPage.EDITABLE(FALSE);
    end;
}

