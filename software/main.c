volatile int * tse_0 = (int *) 0x1000;
volatile int * tse_1 = (int *) 0x1400;
//volatile int * mem_base  = (int *) 0x0;

int main(void) 
{


    // Initialize the MAC address 
    *(tse_0 + 3) = 0x116E6001;
    *(tse_0 + 4) = 0x00000F02; 
    // Specify the addresses of the PHY devices to be accessed through MDIO interfac
    *(tse_0 + 0x10) = 0x10;
    // Write to register 16 of the PHY chip for Ethernet port 1 to enable automatic crossover for all modes
    *(tse_0 + 0xB0) = *(tse_0 + 0xB0) | 0x0060;
    // Write to register 20 of the PHY chip for Ethernet port 2 to set up delay for input/output clk
    *(tse_0 + 0xB4) = *(tse_0 + 0xB4) | 0x0082;
    // Software reset the second PHY chip and wait
    *(tse_0 + 0xA0) = *(tse_0 + 0xA0) | 0x8000;
    while ( *(tse_0 + 0xA0) & 0x8000  );	 
    *(tse_0 + 2) = *(tse_0 + 2) | 0x0000005B;	

    // Initialize the MAC address 
    *(tse_1 + 3) = 0x116E6001;
    *(tse_1 + 4) = 0x00000F02; 
    // Specify the addresses of the PHY devices to be accessed through MDIO interfac
    *(tse_1 + 0x10) = 0x11;
    // Write to register 16 of the PHY chip for Ethernet port 1 to enable automatic crossover for all modes
    *(tse_1 + 0xB0) = *(tse_1 + 0xB0) | 0x0060;
    // Write to register 20 of the PHY chip for Ethernet port 2 to set up delay for input/output clk
    *(tse_1 + 0xB4) = *(tse_1 + 0xB4) | 0x0082;
    // Software reset the second PHY chip and wait
    *(tse_1 + 0xA0) = *(tse_1 + 0xA0) | 0x8000;
    while ( *(tse_1 + 0xA0) & 0x8000  );	 
    *(tse_1 + 2) = *(tse_1 + 2) | 0x0000005B;	
}
