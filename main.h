#ifndef __MAIN_H
#define __MAIN_H

@far @interrupt void uartReceive(void);
@far @interrupt void tim1Update(void);
@far @interrupt void tim2Update(void);

#endif