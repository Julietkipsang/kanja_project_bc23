report 50003 "Service Type Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\SubscribedReport.rdl';

    dataset
    {
        dataitem(DataItemName; Organisation)
        {
            RequestFilterFields = "No.";
            column(Full_Name; "Full Name")
            {


            }
            column(No_; "No.")
            {

            }
            column(PIN_No_; "PIN No.")
            {

            }
            column(applicationNo; applicationNo)
            {

            }
            dataitem("Entity Service Subscription"; "Entity Service Subscription")
            {
                DataItemLink = "Application No." = field(applicationNo);
                column(Account_Type; "Account Type")
                {

                }
                column(Description; Description)
                {

                }
                column(Status; Status)

                {

                }
                column(Application_No_; "Application No.")
                {

                }
                column(EntityNo; EntityNo)
                {

                }
            }

        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        myInt: Integer;
}