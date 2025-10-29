page 50012 BankDetails
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = BankDetails;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(BankNo; Rec.BankNo)
                {
                    ApplicationArea = All;

                }
                field(BankName; Rec.BankName)
                {
                    ApplicationArea = All;

                }
                field(BankBranchCode; Rec.BankBranchCode)
                {
                    ApplicationArea = All;

                }
                field(BankBranchName; Rec.BankBranchName)
                {

                }
                field(AccounNo; Rec.AccounNo)
                {

                }
                field(paybillNumber;Rec.paybillNumber)
                {
                    
                    
                }



            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}