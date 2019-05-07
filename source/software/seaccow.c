/* #include "sys/alt_stdio.h" */

volatile unsigned * const tse_0 = (unsigned *) 0x1000;
volatile unsigned * const tse_1 = (unsigned *) 0x1400;
volatile unsigned * const mem_base  = (unsigned *) 0x0;

void init_eth(volatile unsigned * const base, unsigned phy_offset)
{
    // Initialize the MAC address 
    *(base + 3) = 0x116E6001;
    *(base + 4) = 0x00000F02; 
    
    // Specify the addresses of the PHY devices to be accessed through MDIO interfac
    *(base + 0x10) = phy_offset;
    // Write to register 16 of the PHY chip for Ethernet port 1 to enable automatic crossover for all modes
    *(base + 0xB0) |= 0x0060;
    // Write to register 20 of the PHY chip for Ethernet port 2 to set up delay for input/output clk
    *(base + 0xB4) |= 0x0082;

    // Software reset the second PHY chip and wait
    *(base + 0xA0) |= 0x8000;
    while ( *(base + 0xA0) & 0x8000  );	 


    // Enable RX and TX, set speed to gigabit and enable promiscuous mode
    *(base + 2) |= 0x0000005B;	

    //Omit CRC32
    *(base + 0x3A) |=  1 << 17;
}

int main(void) 
{
    init_eth(tse_0, 0x10);
    init_eth(tse_1, 0x11);
}
