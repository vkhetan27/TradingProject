//+------------------------------------------------------------------+
//|                                                 SimpleSystemV2.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int     StartHour   = 9;
extern int     TakeProfit  = 40;
extern int     StopLoss    = 40;
extern double  Lots        = 1;

void OnTick()
{
   static bool IsFirstTick = true;
   static int ticket = 0;
   
   if (Hour() == StartHour)
   {
      if (IsFirstTick == true)
      {
         IsFirstTick = false;
         
         bool res;
         res = OrderSelect(ticket, SELECT_BY_TICKET);
         
         if(res == true)
         {
            if (OrderCloseTime() == 0)
            {
               bool res2;
               res2 = OrderClose(ticket, Lots, OrderClosePrice(), 10*10);
               
               if(res2 == false)
               {
               Alert("Error Closing Order #", ticket);
               }
            }
         }
         
         if (Open[0] < Open[StartHour])
         {
            ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10*10, Bid - StopLoss*Point*10, Bid + TakeProfit*Point*10, "Set by SimpleSystem");
            if(ticket < 0)
            {
               Alert("Error Sending Order!");
            }
         }
         else
         {
            ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10*10, Ask + StopLoss*Point*10, Ask - TakeProfit*Point*10, "Set by SimpleSystem");
            if(ticket < 0)
            {
               Alert("Error Sending Order!");
            }
         }
      }
   }
   else
   {
      IsFirstTick = true;
   }

}
//+------------------------------------------------------------------+
